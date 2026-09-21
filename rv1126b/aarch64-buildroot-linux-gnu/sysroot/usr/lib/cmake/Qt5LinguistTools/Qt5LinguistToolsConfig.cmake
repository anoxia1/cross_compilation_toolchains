# RV1126B portable toolchain note:
# Qt Linguist host tools are not part of the supported target toolchain package.
# Keep this failure explicit; never refer to the SDK build machine.
message(FATAL_ERROR
        "Qt5 LinguistTools is not included in the portable RV1126B toolchain; "
        "provide host Qt Linguist tools explicitly before using this package.")
