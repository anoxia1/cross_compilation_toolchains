
add_library(Qt5::QOpen62541Plugin MODULE IMPORTED)


_populate_OpcUa_plugin_properties(QOpen62541Plugin RELEASE "opcua/libopen62541_backend.so" FALSE)

list(APPEND Qt5OpcUa_PLUGINS Qt5::QOpen62541Plugin)
set_property(TARGET Qt5::OpcUa APPEND PROPERTY QT_ALL_PLUGINS_opcua Qt5::QOpen62541Plugin)
set_property(TARGET Qt5::QOpen62541Plugin PROPERTY QT_PLUGIN_TYPE "opcua")
set_property(TARGET Qt5::QOpen62541Plugin PROPERTY QT_PLUGIN_EXTENDS "")
set_property(TARGET Qt5::QOpen62541Plugin PROPERTY QT_PLUGIN_CLASS_NAME "QOpen62541Plugin")
