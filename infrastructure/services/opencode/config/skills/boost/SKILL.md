---
name: Boost
description: Use the Boost C++ libraries (Asio, Beast, JSON, Program_options, Spirit...) with CMake.
---

Boost 1.83, all libraries installed. Prefer the standard library when it has the feature: `std::filesystem`, `std::optional`, `std::variant`, `std::thread`, `std::format`, `<chrono>`.

```cmake
find_package(Boost 1.83 REQUIRED CONFIG COMPONENTS program_options json)
target_link_libraries(app PRIVATE Boost::program_options Boost::json)
```

- Header-only libraries (Asio, Beast, Spirit, Container, Circular_buffer...): `find_package(Boost REQUIRED CONFIG)` and `Boost::headers`.
- Asio and Beast also need `find_package(Threads REQUIRED)` and `Threads::Threads`.
- Unit tests: use GoogleTest (`cpp-testing` skill), not Boost.Test, unless the project already uses Boost.Test.

## Docs

No local Boost documentation. Read the headers in `/usr/include/boost/` for exact signatures, and search the web (`site:boost.org 1.83`) for explanations.
