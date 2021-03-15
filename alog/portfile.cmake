vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kkzi/alog
    REF c639b77d80f8c0d04d246caf720dd37bc8638fc1 #v1.0.0
    SHA512 e7821b6864a4df270f417aa2064194e69c93b64744adf6f8147fc0d2e02a7f096ba431bbbdc06c8927cb4db2e594909e66598dd50ebcc1c07f82443f50f81dbf
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)
vcpkg_install_cmake()

vcpkg_copy_pdbs()


file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)


