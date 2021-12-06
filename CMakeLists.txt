cmake_minimum_required(VERSION 3.14)

project(controlpanelNewLayout LANGUAGES CXX C)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(X11 REQUIRED)
if(X11_FOUND)
    message(STATUS "X11 FOUND")
else()
    message(STATUS "X11 NOT FOUND")
endif(X11_FOUND)

include(FindPkgConfig)
pkg_check_modules(XCB xcb xcb-keysyms REQUIRED)
#find_package(XCB REQUIRED)

#find_package(ECM REQUIRED NO_MODULE)
#set(CMAKE_MODULE_PATH ${ECM_FIND_MODULE_DIR})

if(X11_XCB_FOUND)
    message(STATUS "XCB FOUND")
else()
    message(STATUS "XCB NOT FOUND")
endif(X11_XCB_FOUND)


find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick LinguistTools REQUIRED)

set(TS_FILES controlpanelNewLayout_zh_CN.ts)

set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        ${TS_FILES}
)


add_executable(controlpanelNewLayout  ${PROJECT_SOURCES})

qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})


include_directories(./ ${X11_INCLUDE_DIR})

target_compile_definitions(controlpanelNewLayout
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

message(STATUS "Debug:"${X11_LIBRARIES}"\n\t;"${XCB_LDFLAGS})

target_link_libraries(controlpanelNewLayout
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick ${X11_LIBRARIES} ${XCB_LDFLAGS})
