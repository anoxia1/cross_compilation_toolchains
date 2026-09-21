# RV1126B portable toolchain note:
# The SDK exported LibVNCServer targets without shipping matching development
# libraries. The product uses Xvfb/x11vnc at runtime and does not link this
# package, so fail explicitly instead of referring to SDK-only absolute paths.
message(FATAL_ERROR
        "LibVNCServer development targets are not included in the RV1126B "
        "portable toolchain")
