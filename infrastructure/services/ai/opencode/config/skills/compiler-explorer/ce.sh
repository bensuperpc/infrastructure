#!/bin/bash
# Compiler Explorer client.
# ce.sh asm|remarks <g14|clang19|cg14|cclang19> '<flags>' <file>
set -euo pipefail

if [[ $# -ne 4 || ! $1 =~ ^(asm|remarks)$ ]]; then
    echo "usage: ce.sh asm|remarks g14|clang19|cg14|cclang19 '<flags>' <file>" >&2
    exit 2
fi
mode=$1 compiler=$2 flags=$3 file=$4
response=$(mktemp)
trap 'rm -f "$response"' EXIT

jq -n --rawfile src "$file" --arg flags "$flags -fdiagnostics-color=never" --argjson remarks "$([[ $mode == remarks ]] && echo true || echo false)" \
    '{source: $src, options: {userArguments: $flags, compilerOptions: {produceOptInfo: $remarks},
      filters: {intel: true, demangle: true, labels: true, directives: true, commentOnly: true, libraryCode: true}}}' \
    | curl -sS --fail-with-body -H 'Content-Type: application/json' -H 'Accept: application/json' --data-binary @- \
        "http://compiler-explorer:10240/api/compiler/$compiler/compile" > "$response"

jq -r '.stderr[].text' "$response"
code=$(jq -r .code "$response")
if [[ $code != 0 ]]; then
    echo "Compilation failed (exit code $code)"
    exit 1
fi

if [[ $mode == asm ]]; then
    # <line in the file> <tab> <instruction>
    jq -r '.asm[] | "\(if .source.file == null then .source.line // "" else "" end)\t\(.text)"' "$response"
else
    # <Passed|Missed> line <N> <message>, headers and register allocation left out
    # (Compiler Explorer names the source example.cpp or example.c)
    jq -r '.optOutput[]? | select(.optType != "Analysis" and .displayString != "" and .Pass != "regalloc"
        and (.DebugLoc.File | test("(^|/)example\\.(cpp|c)$")))
        | "\(.optType)\tline \(.DebugLoc.Line)\t\(.displayString | ltrimstr(" "))"' "$response" | awk '!seen[$0]++'
fi
