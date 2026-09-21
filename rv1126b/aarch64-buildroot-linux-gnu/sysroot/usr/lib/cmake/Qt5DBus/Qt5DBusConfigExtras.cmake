# RV1126B portable toolchain note:
# Qt DBus runtime libraries are available, but the host-side DBus code generators
# are intentionally not shipped. Projects requiring qdbuscpp2xml/qdbusxml2cpp
# must provide those tools separately instead of relying on the old SDK path.
