---
name: Protocol Buffers
description: Use Protocol Buffers in C++ or Python (protoc, libprotobuf), or in C for microcontrollers (nanopb).
---

Installed: protobuf 3.21 (`protoc`, C++ library, Python module) and nanopb 0.4.9. Write `.proto` files in `proto3` syntax.

## C++

```cmake
find_package(Protobuf REQUIRED)
add_library(proto proto/msg.proto)
target_link_libraries(proto PUBLIC protobuf::libprotobuf)
target_include_directories(proto PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
protobuf_generate(TARGET proto)
```

Include `"proto/msg.pb.h"`. `msg.SerializeToString(&bytes)`, `msg.ParseFromString(bytes)` (check the returned bool).

## Python

`protoc --python_out=. msg.proto`, then `import msg_pb2`; `msg_pb2.Point.FromString(data)`, `msg.SerializeToString()`.

## nanopb (C, no dynamic allocation)

Fix the size of strings and repeated fields in a `.options` file next to the `.proto` (same name), otherwise they become callbacks:

```
Point.name max_size:16
Point.values max_count:4
```

```cmake
find_package(nanopb CONFIG REQUIRED)
add_custom_command(
    OUTPUT msg.pb.c msg.pb.h
    COMMAND nanopb_generator -D ${CMAKE_CURRENT_BINARY_DIR} msg.proto
    DEPENDS proto/msg.proto proto/msg.options
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/proto)
add_executable(app main.c ${CMAKE_CURRENT_BINARY_DIR}/msg.pb.c)
target_include_directories(app PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(app PRIVATE nanopb::protobuf-nanopb-static)
```

```c
uint8_t buf[Point_size];
Point p = Point_init_zero;
pb_ostream_t os = pb_ostream_from_buffer(buf, sizeof buf);
if (!pb_encode(&os, Point_fields, &p)) { /* PB_GET_ERROR(&os) */ }

Point q = Point_init_zero;
pb_istream_t is = pb_istream_from_buffer(buf, os.bytes_written);
if (!pb_decode(&is, Point_fields, &q)) { /* PB_GET_ERROR(&is) */ }
```

The library installed here is for the PC. A microcontroller project compiles nanopb's `pb_common.c`, `pb_encode.c` and `pb_decode.c` itself.

## Docs

`/docs/protobuf` (`programming-guides/proto3.md`, `reference/cpp/`, `reference/python/`) and `/docs/nanopb` (`concepts.md`, `reference.md`).
