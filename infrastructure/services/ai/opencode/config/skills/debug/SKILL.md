---
name: Debugging
description: Find the cause of a crash, segfault, abort, memory error, leak, undefined behavior, data race or failing system call in C or C++, with gdb, sanitizers, valgrind and strace.
---

Reproduce first, with a Debug build: `cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug && cmake --build build`.

## Crash: gdb, always with `-batch`

```bash
gdb -q -batch -ex run -ex bt -ex 'info locals' --args ./build/app arg1 arg2
```

- A test: `--args ./build/tests --gtest_filter='Suite.Name'`.
- More details: `-ex 'bt full'` (locals of every frame), `-ex 'frame 2' -ex 'info locals'`, `-ex 'print *ptr'`.
- `warning: Error disabling address space randomization: Operation not permitted` is harmless: ignore it.
- There are no core dumps here: reproduce the crash under gdb. Without `-batch`, gdb waits for input forever.

## Memory errors, leaks, undefined behavior: sanitizers

In a separate build directory, with gcc or clang. Never add sanitizer flags to the project's `CMakeLists.txt`:

```bash
f="-fsanitize=address,undefined -fno-omit-frame-pointer"
cmake -S . -B build-asan -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="$f" -DCMAKE_CXX_FLAGS="$f"
cmake --build build-asan
UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1 ctest --test-dir build-asan --output-on-failure
```

- The cause is in the first report: `ERROR: AddressSanitizer: heap-buffer-overflow`, `LeakSanitizer: detected memory leaks`, `runtime error:` (undefined behavior). Look at the first stack frame in the project's files.
- Data races: `f="-fsanitize=thread"` in `build-tsan`. It cannot be combined with `address`.
- Clang: add `-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++`. The warning `Manually-specified variables were not used by the project: CMAKE_C_FLAGS` is harmless.
- One file: `g++ -g -fsanitize=address,undefined -fno-omit-frame-pointer main.cpp -o app && ./app`.

## Valgrind

On the Debug build, without sanitizers. 10 to 50 times slower: use it when the sanitizers find nothing, or for uninitialized values.

```bash
valgrind --leak-check=full --track-origins=yes --error-exitcode=1 ./build/app
```

## Failing system calls: strace

File not found, permission denied, connection refused:

```bash
strace -f -e trace=file,network -o strace.txt ./build/app; rg -n 'ENOENT|EACCES|ECONNREFUSED' strace.txt
```

`ENOENT` on `/etc/ld.so.preload` and on library search paths is normal: look at the files of the program.

## Rules

- Quote the report of the tool (error, file, line). Never guess the cause of a crash.
- Fix the cause, not the symptom, then run the same command again to show that the error is gone.
