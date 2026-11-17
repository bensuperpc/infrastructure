---
name: C++ tests and benchmarks
description: Write and run C++ tests (GoogleTest, GMock, Catch2), benchmarks (Google Benchmark) and coverage with CTest.
---

Installed: GoogleTest and GMock 1.16, Catch2 3.7, Google Benchmark 1.9. Use GoogleTest unless the project already uses another framework.

Put the tested code in a library target (`add_library(core ...)`), linked by the application and by the tests.

## GoogleTest

```cmake
find_package(GTest REQUIRED)
enable_testing()
add_executable(tests tests/test_core.cpp)
target_link_libraries(tests PRIVATE core GTest::gtest_main)   # GTest::gmock_main for GMock
include(GoogleTest)
gtest_discover_tests(tests)
```

- `TEST(Suite, Name)`, `TEST_F` with a fixture class, `TEST_P` with `INSTANTIATE_TEST_SUITE_P` for parameters.
- `EXPECT_*` continues after a failure, `ASSERT_*` stops the test. Floats: `EXPECT_NEAR`, `EXPECT_DOUBLE_EQ`.
- Crash expected: `EXPECT_DEATH(statement, "message regex")`.
- GMock: `MOCK_METHOD(int, read, (int fd), (override));` then `EXPECT_CALL(mock, read(3)).WillOnce(Return(1));`

## Catch2 v3

```cmake
find_package(Catch2 3 REQUIRED)
target_link_libraries(tests PRIVATE core Catch2::Catch2WithMain)
include(Catch)
catch_discover_tests(tests)
```

## Run

```bash
ctest --test-dir build --output-on-failure
ctest --test-dir build -R 'Suite\.' --output-on-failure      # filter by name
ctest --test-dir build --repeat until-fail:50 -R Name        # flaky test
./build/tests --gtest_filter='Suite.*' --gtest_shuffle --gtest_repeat=10
```

## Benchmarks

```cmake
find_package(benchmark REQUIRED)
add_executable(bench bench/bench_core.cpp)
target_link_libraries(bench PRIVATE core benchmark::benchmark_main)
```

```cpp
#include <benchmark/benchmark.h>

static void BM_Parse(benchmark::State& state) {
    const std::string input(state.range(0), 'a');
    for (auto _ : state)
        benchmark::DoNotOptimize(parse(input));
}
BENCHMARK(BM_Parse)->Range(64, 64 << 10);
```

- Always in a Release build. For a comparison, run several times: `./build/bench --benchmark_repetitions=5 --benchmark_report_aggregates_only=true`.
- Report the numbers before and after, from the same machine.

## Coverage

```bash
cmake -S . -B build-cov -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS=--coverage -DCMAKE_CXX_FLAGS=--coverage
cmake --build build-cov && ctest --test-dir build-cov
gcovr --root . --exclude tests/ --exclude build-cov/ build-cov
```

## Docs

Markdown in `/docs/googletest` (`primer.md`, `gmock_for_dummies.md`, `advanced.md`) and `/docs/benchmark` (`user_guide.md`).
