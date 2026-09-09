if (CMAKE_VERSION VERSION_LESS 2.8.3)
    message(FATAL_ERROR "Qt 5 requires at least CMake version 2.8.3")
endif()

get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
# Use original install prefix when loaded through a
# cross-prefix symbolic link such as /lib -> /usr/lib.
get_filename_component(_realCurr "${_IMPORT_PREFIX}" REALPATH)
get_filename_component(_realOrig "/usr/lib/cmake/Qt5DocTools" REALPATH)
if(_realCurr STREQUAL _realOrig)
    get_filename_component(_qt5_qdoctools_install_prefix "/usr/lib/../" ABSOLUTE)
else()
    get_filename_component(_qt5_qdoctools_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)
endif()
unset(_realOrig)
unset(_realCurr)
unset(_IMPORT_PREFIX)

macro(_qt5_DocTools_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The package \"Qt5DocTools\" references the file
   \"${file}\"
but this file does not exist.  Possible reasons include:
* The file was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
    endif()
endmacro()

if (NOT TARGET Qt5::qdoc)
    add_executable(Qt5::qdoc IMPORTED)

    set(imported_location "/home/xie/workspace/codes/neardi_lkb1126bp_sdk/Neardi-LKB1126BP-SDK-Linux-v1.2/buildroot/output/rockchip_rv1126b_vnc/host/bin/qdoc")
    _qt5_DocTools_check_file_exists(${imported_location})

    set_target_properties(Qt5::qdoc PROPERTIES
        IMPORTED_LOCATION ${imported_location}
    )
endif()

# Create versionless tool targets.
foreach(__qt_tool qdoc)
    if(NOT "${QT_NO_CREATE_VERSIONLESS_TARGETS}" AND NOT TARGET Qt::${__qt_tool}
       AND TARGET Qt5::${__qt_tool})
        add_executable(Qt::${__qt_tool} IMPORTED)
        get_target_property(__qt_imported_location Qt5::${__qt_tool} IMPORTED_LOCATION)
        set_target_properties(Qt::${__qt_tool}
                              PROPERTIES IMPORTED_LOCATION "${__qt_imported_location}")
    endif()
endforeach()
