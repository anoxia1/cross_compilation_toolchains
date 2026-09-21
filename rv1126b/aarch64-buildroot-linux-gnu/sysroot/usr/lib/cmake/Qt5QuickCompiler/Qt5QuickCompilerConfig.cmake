# RV1126B portable toolchain note:
# qmlcachegen is not shipped. Fail only when the optional resource compiler is
# invoked, and do not retain the SDK machine path in the package metadata.
include(CMakeParseArguments)

function(QTQUICK_COMPILER_DETERMINE_OUTPUT_FILENAME outvariable filename)
    file(RELATIVE_PATH relpath ${CMAKE_CURRENT_SOURCE_DIR} ${filename})
    string(REPLACE ".qml" "_qml" relpath ${relpath})
    string(REPLACE ".js" "_js" relpath ${relpath})
    string(REPLACE ".mjs" "_mjs" relpath ${relpath})
    string(REPLACE "/" "_" relpath ${relpath})
    set(${outvariable} ${CMAKE_CURRENT_BINARY_DIR}/${relpath}.cpp PARENT_SCOPE)
endfunction()

function(QTQUICK_COMPILER_ADD_RESOURCES outfiles)
    message(FATAL_ERROR
            "Qt5QuickCompiler requires qmlcachegen, which is not included in "
            "the portable RV1126B toolchain")
endfunction()
