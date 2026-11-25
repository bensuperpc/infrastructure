---
name: Qt 6
description: Build and test Qt 6 applications (Widgets or QML/Qt Quick) with CMake. Load for any Qt or QML task.
---

- Qt 6.8.2. Modules: Core, Gui, Widgets, Network, Sql, Xml, Concurrent, DBus, PrintSupport, OpenGL, OpenGLWidgets, Test, Qml, Quick, QuickControls2, QuickWidgets, QuickTest, WebSockets, SerialPort, SerialBus, LinguistTools.
- There is no display: `QT_QPA_PLATFORM=offscreen` is set. Apps run without a window. Test behavior with Qt Test, not by looking at the UI.
- Connect with pointers to members: `connect(button, &QPushButton::clicked, this, &MainWindow::save);`

## Widgets

```cmake
cmake_minimum_required(VERSION 3.21)
project(app LANGUAGES CXX)
find_package(Qt6 REQUIRED COMPONENTS Widgets)
qt_standard_project_setup()
qt_add_executable(app main.cpp mainwindow.cpp mainwindow.h)
target_link_libraries(app PRIVATE Qt6::Widgets)
```

## QML

```cmake
find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)
qt_add_executable(app main.cpp)
qt_add_qml_module(app URI App QML_FILES Main.qml SOURCES backend.h backend.cpp)
target_link_libraries(app PRIVATE Qt6::Quick)
```

- Load it in `main.cpp` with `engine.loadFromModule("App", "Main");`.
- C++ type usable in QML: a `QObject` subclass with `Q_OBJECT` and `QML_ELEMENT`, listed in `SOURCES`. Properties: `Q_PROPERTY(int count READ count NOTIFY countChanged)`. Methods called from QML: `Q_INVOKABLE`.
- Check QML files with `cmake --build build --target all_qmllint`: it knows the project's modules, unlike `qmllint` alone. Format them with `/usr/lib/qt6/bin/qmlformat -i Main.qml`.

## Tests

C++ (Qt Test):

```cmake
find_package(Qt6 REQUIRED COMPONENTS Test)
enable_testing()
qt_add_executable(tst_foo tst_foo.cpp)
target_link_libraries(tst_foo PRIVATE Qt6::Test)
add_test(NAME tst_foo COMMAND tst_foo)
```

A test file ends with `QTEST_MAIN(TestClass)` and `#include "tst_foo.moc"`. Signals: `QSignalSpy spy(obj, &Obj::changed); QCOMPARE(spy.count(), 1);`

QML (Qt Quick Test), with `tst_*.qml` files next to the CMakeLists.txt:

```cmake
find_package(Qt6 REQUIRED COMPONENTS QuickTest)
qt_add_executable(tst_qml tst_qml.cpp)
target_link_libraries(tst_qml PRIVATE Qt6::QuickTest)
target_compile_definitions(tst_qml PRIVATE QUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")
add_test(NAME tst_qml COMMAND tst_qml)
```

`tst_qml.cpp` contains `#include <QtQuickTest>` and `QUICK_TEST_MAIN(qml)`. A test file:

```qml
import QtQuick
import QtTest

TestCase {
    name: "Math"
    function test_add() { compare(1 + 1, 2) }
}
```

## Notes

- The CMake warning "The qml plugin ... will not be linked" is harmless.
- Docs: ZIM file `/data/devdocs_en_qt.zim`, JavaScript in QML: `/data/devdocs_en_javascript.zim`.
