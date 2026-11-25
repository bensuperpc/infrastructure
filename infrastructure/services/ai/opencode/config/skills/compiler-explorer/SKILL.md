---
name: Compiler Explorer
description: Is a loop vectorized or unrolled, is a function inlined, what assembly do GCC and Clang generate with given flags. Uses the local Compiler Explorer.
---

Put only the code to study in a file, with its includes. Use non-`static` functions taking their inputs as parameters, otherwise the compiler removes them or computes the result at compile time. No `main` needed.

Compilers: `g14` (GCC 14) and `clang19` (Clang 19) for C++, `cg14` and `cclang19` for C.

## Vectorized, unrolled, inlined? Run `remarks`

```bash
bash /etc/opencode/skills/compiler-explorer/ce.sh remarks g14 '-O3 -march=x86-64-v3' code.cpp
bash /etc/opencode/skills/compiler-explorer/ce.sh remarks clang19 '-O3 -march=x86-64-v3' code.cpp
```

Each line: `Passed` (done) or `Missed` (not done, with the reason), the line in `code.cpp`, the message. Example: `Passed	line 2	vectorized loop (vectorization width: 8, interleaved count: 4)`.

Answer from these lines and quote them. Never conclude from the assembly alone: a vectorized loop also contains a scalar loop for the remaining elements.

## Assembly: run `asm`

```bash
bash /etc/opencode/skills/compiler-explorer/ce.sh asm g14 '-O2 -std=c++20' code.cpp
```

Each line: the line in `code.cpp`, then the instruction (Intel syntax, no directives). Add `| head -200` for long output.

## Rules

- Compare with the same file and change one thing at a time: compiler, `-O2`/`-O3`, `-march=x86-64-v3`...
- Give the compiler and the flags with every result.
- `Compilation failed`: the compiler errors are printed above, fix the code.
- Assembly does not measure speed: before claiming a speedup, benchmark (`cpp-testing` skill).
- `Could not resolve host: compiler-explorer`: Compiler Explorer is not started. Use the local compilers: `g++ -O3 -fopt-info-vec-all -c -o /dev/null code.cpp` or `clang++ -O3 '-Rpass=.*' '-Rpass-missed=.*' -c -o /dev/null code.cpp` for remarks, `g++ -O2 -S -masm=intel -o - code.cpp | c++filt` for assembly.
