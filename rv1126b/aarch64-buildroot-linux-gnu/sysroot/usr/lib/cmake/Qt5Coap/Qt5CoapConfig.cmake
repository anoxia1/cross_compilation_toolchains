if (CMAKE_VERSION VERSION_LESS 3.1.0)
    message(FATAL_ERROR "Qt 5 Coap module requires at least CMake version 3.1.0")
endif()

get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
# Use original install prefix when loaded through a
# cross-prefix symbolic link such as /lib -> /usr/lib.
get_filename_component(_realCurr "${_IMPORT_PREFIX}" REALPATH)
get_filename_component(_realOrig "/usr/lib/cmake/Qt5Coap" REALPATH)
if(_realCurr STREQUAL _realOrig)
    get_filename_component(_qt5Coap_install_prefix "/usr/lib/../" ABSOLUTE)
else()
    get_filename_component(_qt5Coap_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)
endif()
unset(_realOrig)
unset(_realCurr)
unset(_IMPORT_PREFIX)

# For backwards compatibility only. Use Qt5Coap_VERSION instead.
set(Qt5Coap_VERSION_STRING 5.15.2)

set(Qt5Coap_LIBRARIES Qt5::Coap)

macro(_qt5_Coap_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The imported target \"Qt5::Coap\" references the file
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


macro(_populate_Coap_target_properties Configuration LIB_LOCATION IMPLIB_LOCATION
      IsDebugAndRelease)
    set_property(TARGET Qt5::Coap APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

    set(imported_location "${_qt5Coap_install_prefix}/lib/${LIB_LOCATION}")
    _qt5_Coap_check_file_exists(${imported_location})
    set(_deps
        ${_Qt5Coap_LIB_DEPENDENCIES}
    )
    set(_static_deps
    )

    set_target_properties(Qt5::Coap PROPERTIES
        "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        "IMPORTED_SONAME_${Configuration}" "libQt5Coap.so.5"
        # For backward compatibility with CMake < 2.8.12
        "IMPORTED_LINK_INTERFACE_LIBRARIES_${Configuration}" "${_deps};${_static_deps}"
    )
    set_property(TARGET Qt5::Coap APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 "${_deps}"
    )


endmacro()

if (NOT TARGET Qt5::Coap)

    set(_Qt5Coap_OWN_INCLUDE_DIRS "${_qt5Coap_install_prefix}/include/qt5/" "${_qt5Coap_install_prefix}/include/qt5/QtCoap")
    set(Qt5Coap_PRIVATE_INCLUDE_DIRS
        "${_qt5Coap_install_prefix}/include/qt5/QtCoap/5.15.2"
        "${_qt5Coap_install_prefix}/include/qt5/QtCoap/5.15.2/QtCoap"
    )

    foreach(_dir ${_Qt5Coap_OWN_INCLUDE_DIRS})
        _qt5_Coap_check_file_exists(${_dir})
    endforeach()

    # Only check existence of private includes if the Private component is
    # specified.
    list(FIND Qt5Coap_FIND_COMPONENTS Private _check_private)
    if (NOT _check_private STREQUAL -1)
        foreach(_dir ${Qt5Coap_PRIVATE_INCLUDE_DIRS})
            _qt5_Coap_check_file_exists(${_dir})
        endforeach()
    endif()

    set(Qt5Coap_INCLUDE_DIRS ${_Qt5Coap_OWN_INCLUDE_DIRS})

    set(Qt5Coap_DEFINITIONS -DQT_COAP_LIB)
    set(Qt5Coap_COMPILE_DEFINITIONS QT_COAP_LIB)
    set(_Qt5Coap_MODULE_DEPENDENCIES "Core")


    set(Qt5Coap_OWN_PRIVATE_INCLUDE_DIRS ${Qt5Coap_PRIVATE_INCLUDE_DIRS})

    set(_Qt5Coap_FIND_DEPENDENCIES_REQUIRED)
    if (Qt5Coap_FIND_REQUIRED)
        set(_Qt5Coap_FIND_DEPENDENCIES_REQUIRED REQUIRED)
    endif()
    set(_Qt5Coap_FIND_DEPENDENCIES_QUIET)
    if (Qt5Coap_FIND_QUIETLY)
        set(_Qt5Coap_DEPENDENCIES_FIND_QUIET QUIET)
    endif()
    set(_Qt5Coap_FIND_VERSION_EXACT)
    if (Qt5Coap_FIND_VERSION_EXACT)
        set(_Qt5Coap_FIND_VERSION_EXACT EXACT)
    endif()

    set(Qt5Coap_EXECUTABLE_COMPILE_FLAGS "")

    foreach(_module_dep ${_Qt5Coap_MODULE_DEPENDENCIES})
        if (NOT Qt5${_module_dep}_FOUND)
            find_package(Qt5${_module_dep}
                5.15.2 ${_Qt5Coap_FIND_VERSION_EXACT}
                ${_Qt5Coap_DEPENDENCIES_FIND_QUIET}
                ${_Qt5Coap_FIND_DEPENDENCIES_REQUIRED}
                PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
            )
        endif()

        if (NOT Qt5${_module_dep}_FOUND)
            set(Qt5Coap_FOUND False)
            return()
        endif()

        list(APPEND Qt5Coap_INCLUDE_DIRS "${Qt5${_module_dep}_INCLUDE_DIRS}")
        list(APPEND Qt5Coap_PRIVATE_INCLUDE_DIRS "${Qt5${_module_dep}_PRIVATE_INCLUDE_DIRS}")
        list(APPEND Qt5Coap_DEFINITIONS ${Qt5${_module_dep}_DEFINITIONS})
        list(APPEND Qt5Coap_COMPILE_DEFINITIONS ${Qt5${_module_dep}_COMPILE_DEFINITIONS})
        list(APPEND Qt5Coap_EXECUTABLE_COMPILE_FLAGS ${Qt5${_module_dep}_EXECUTABLE_COMPILE_FLAGS})
    endforeach()
    list(REMOVE_DUPLICATES Qt5Coap_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5Coap_PRIVATE_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5Coap_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5Coap_COMPILE_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5Coap_EXECUTABLE_COMPILE_FLAGS)

    # It can happen that the same FooConfig.cmake file is included when calling find_package()
    # on some Qt component. An example of that is when using a Qt static build with auto inclusion
    # of plugins:
    #
    # Qt5WidgetsConfig.cmake -> Qt5GuiConfig.cmake -> Qt5Gui_QSvgIconPlugin.cmake ->
    # Qt5SvgConfig.cmake -> Qt5WidgetsConfig.cmake ->
    # finish processing of second Qt5WidgetsConfig.cmake ->
    # return to first Qt5WidgetsConfig.cmake ->
    # add_library cannot create imported target Qt5::Widgets.
    #
    # Make sure to return early in the original Config inclusion, because the target has already
    # been defined as part of the second inclusion.
    if(TARGET Qt5::Coap)
        return()
    endif()

    set(_Qt5Coap_LIB_DEPENDENCIES "Qt5::Core")


    add_library(Qt5::Coap SHARED IMPORTED)


    set_property(TARGET Qt5::Coap PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES ${_Qt5Coap_OWN_INCLUDE_DIRS})
    set_property(TARGET Qt5::Coap PROPERTY
      INTERFACE_COMPILE_DEFINITIONS QT_COAP_LIB)

    set_property(TARGET Qt5::Coap PROPERTY INTERFACE_QT_ENABLED_FEATURES )
    set_property(TARGET Qt5::Coap PROPERTY INTERFACE_QT_DISABLED_FEATURES )

    # Qt 6 forward compatible properties.
    set_property(TARGET Qt5::Coap
                 PROPERTY QT_ENABLED_PUBLIC_FEATURES
                 )
    set_property(TARGET Qt5::Coap
                 PROPERTY QT_DISABLED_PUBLIC_FEATURES
                 )
    set_property(TARGET Qt5::Coap
                 PROPERTY QT_ENABLED_PRIVATE_FEATURES
                 )
    set_property(TARGET Qt5::Coap
                 PROPERTY QT_DISABLED_PRIVATE_FEATURES
                 )

    set_property(TARGET Qt5::Coap PROPERTY INTERFACE_QT_PLUGIN_TYPES "")

    set(_Qt5Coap_PRIVATE_DIRS_EXIST TRUE)
    foreach (_Qt5Coap_PRIVATE_DIR ${Qt5Coap_OWN_PRIVATE_INCLUDE_DIRS})
        if (NOT EXISTS ${_Qt5Coap_PRIVATE_DIR})
            set(_Qt5Coap_PRIVATE_DIRS_EXIST FALSE)
        endif()
    endforeach()

    if (_Qt5Coap_PRIVATE_DIRS_EXIST)
        add_library(Qt5::CoapPrivate INTERFACE IMPORTED)
        set_property(TARGET Qt5::CoapPrivate PROPERTY
            INTERFACE_INCLUDE_DIRECTORIES ${Qt5Coap_OWN_PRIVATE_INCLUDE_DIRS}
        )
        set(_Qt5Coap_PRIVATEDEPS)
        foreach(dep ${_Qt5Coap_LIB_DEPENDENCIES})
            if (TARGET ${dep}Private)
                list(APPEND _Qt5Coap_PRIVATEDEPS ${dep}Private)
            endif()
        endforeach()
        set_property(TARGET Qt5::CoapPrivate PROPERTY
            INTERFACE_LINK_LIBRARIES Qt5::Coap ${_Qt5Coap_PRIVATEDEPS}
        )

        # Add a versionless target, for compatibility with Qt6.
        if(NOT "${QT_NO_CREATE_VERSIONLESS_TARGETS}" AND NOT TARGET Qt::CoapPrivate)
            add_library(Qt::CoapPrivate INTERFACE IMPORTED)
            set_target_properties(Qt::CoapPrivate PROPERTIES
                INTERFACE_LINK_LIBRARIES "Qt5::CoapPrivate"
            )
        endif()
    endif()

    _populate_Coap_target_properties(RELEASE "libQt5Coap.so.5.15.2" "" FALSE)




    # In Qt 5.15 the glob pattern was relaxed to also catch plugins not literally named Plugin.
    # Define QT5_STRICT_PLUGIN_GLOB or ModuleName_STRICT_PLUGIN_GLOB to revert to old behavior.
    if (QT5_STRICT_PLUGIN_GLOB OR Qt5Coap_STRICT_PLUGIN_GLOB)
        file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5Coap_*Plugin.cmake")
    else()
        file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5Coap_*.cmake")
    endif()

    macro(_populate_Coap_plugin_properties Plugin Configuration PLUGIN_LOCATION
          IsDebugAndRelease)
        set_property(TARGET Qt5::${Plugin} APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

        set(imported_location "${_qt5Coap_install_prefix}/lib/qt/plugins/${PLUGIN_LOCATION}")
        _qt5_Coap_check_file_exists(${imported_location})
        set_target_properties(Qt5::${Plugin} PROPERTIES
            "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        )

    endmacro()

    if (pluginTargets)
        foreach(pluginTarget ${pluginTargets})
            include(${pluginTarget})
        endforeach()
    endif()



    _qt5_Coap_check_file_exists("${CMAKE_CURRENT_LIST_DIR}/Qt5CoapConfigVersion.cmake")
endif()

# Add a versionless target, for compatibility with Qt6.
if(NOT "${QT_NO_CREATE_VERSIONLESS_TARGETS}" AND TARGET Qt5::Coap AND NOT TARGET Qt::Coap)
    add_library(Qt::Coap INTERFACE IMPORTED)
    set_target_properties(Qt::Coap PROPERTIES
        INTERFACE_LINK_LIBRARIES "Qt5::Coap"
    )
endif()
