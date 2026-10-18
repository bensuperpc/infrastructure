#!/usr/bin/env bash
# Markdown docs of projects missing from Kiwix, in /docs/<name>.
set -euo pipefail

# fetch_doc <name> <repository> <version> <folder>
fetch_doc() {
    local dest=/docs/$1 tmp
    [[ -d $dest ]] && return
    tmp=$(mktemp -d)
    git clone -q --depth 1 --branch "$3" --filter=blob:none --no-checkout "$2" "$tmp"
    git -C "$tmp" sparse-checkout set --no-cone "/$4**/*.md" "/$4**/*.markdown"
    git -C "$tmp" checkout -q
    rm -rf "$tmp/.git"
    mv "$tmp/$4" "$dest.part"
    mv "$dest.part" "$dest"
    rm -rf "$tmp"
}

rm -rf /docs/*.part
fetch_doc googletest https://github.com/google/googletest.git v1.16.0 docs/
fetch_doc benchmark https://github.com/google/benchmark.git v1.9.1 docs/
fetch_doc protobuf https://github.com/protocolbuffers/protocolbuffers.github.io.git main content/
fetch_doc nanopb https://github.com/nanopb/nanopb.git nanopb-0.4.9.1 docs/
fetch_doc opencv https://github.com/opencv/opencv.git 4.10.0 doc/
fetch_doc gitlab-ci https://gitlab.com/gitlab-org/gitlab.git master doc/ci/
fetch_doc github-actions https://github.com/github/docs.git main content/actions/
fetch_doc mermaid https://github.com/mermaid-js/mermaid.git mermaid@12.3.0 docs/syntax/

chown -R "$PUID:$PGID" /docs
chown "$PUID:$PGID" /workspace
