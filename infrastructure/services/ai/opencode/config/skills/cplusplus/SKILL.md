---
name: C/C++
description: Installed compilers and libraries for C or C++ projects, and which skills to load. Load for any C or C++ task.
---

Load these skills too, now, if the task involves them:

| Task | Skill |
| --- | --- |
| CMakeLists.txt, presets | `cmake` |
| Compiler flags, warnings, compilation errors | `gcc`, `clang` |
| Crash, backtrace | `gdb` |
| Memory errors, undefined behavior, data races | `sanitizers`, then `valgrind` |
| clang-tidy, cppcheck | `static-analysis` |
| Linker errors, undefined symbols, shared libraries | `elf-inspection`, `dynamic-linking` |
| Tests, benchmarks, coverage | `cpp-testing` |
| Qt, Boost, OpenCV, protobuf or nanopb | `qt6`, `boost`, `opencv`, `protobuf` |

## Environment

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
```

- If the project has `CMakePresets.json`, use its presets: `cmake --workflow --preset debug`.
- No internet: never use `FetchContent`, `ExternalProject` or downloads, even when a skill shows them. Use the installed packages below with `find_package`.
- Compilers: gcc 14 (default) and clang 19 (`-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++`), up to C++23.
- ccache is already enabled.
- If the project has a `.clang-format`, edited files are formatted automatically.
- Performance: build in Release and measure before claiming an improvement. Google Benchmark for functions (`cpp-testing` skill), `hyperfine ./build/app` for whole programs.

## Installed packages

| `find_package` | Targets | Skill |
| --- | --- | --- |
| `Threads` | `Threads::Threads` | |
| `GTest` | `GTest::gtest_main`, `GTest::gmock_main` | `cpp-testing` |
| `Catch2 3` | `Catch2::Catch2WithMain` | `cpp-testing` |
| `benchmark` | `benchmark::benchmark_main` | `cpp-testing` |
| `Qt6 COMPONENTS Widgets Quick ...` | `Qt6::Widgets`, `Qt6::Quick`... | `qt6` |
| `Boost CONFIG COMPONENTS ...` | `Boost::headers`, `Boost::program_options`... | `boost` |
| `OpenCV` | `${OpenCV_LIBS}` | `opencv` |
| `Protobuf` | `protobuf::libprotobuf` | `protobuf` |
| `PkgConfig` | `pkg_check_modules(X REQUIRED IMPORTED_TARGET x)` then `PkgConfig::X` | |

## Docs

ZIM files `/data/devdocs_en_cpp.zim`, `/data/devdocs_en_c.zim`, `/data/devdocs_en_gcc.zim`, `/data/devdocs_en_cmake.zim`. POSIX and Linux functions (`open`, `pthread_create`, `socket`...): `/data/devdocs_en_man.zim`.
