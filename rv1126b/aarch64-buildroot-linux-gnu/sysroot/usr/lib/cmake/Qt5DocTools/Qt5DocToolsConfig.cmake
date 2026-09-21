# RV1126B portable toolchain note:
# Qt qdoc/DocTools host binaries are not part of the supported toolchain package.
message(FATAL_ERROR
        "Qt5 DocTools is not included in the portable RV1126B toolchain; "
        "provide a host Qt qdoc installation explicitly before using this package.")
