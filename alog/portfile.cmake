vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kkzi/alog
    REF 2416d4b9de30bdee023e739c37b6d696b11a2779 # v1.0
    SHA512 d143b01d418e8fa214da2bf0c29c66cee23fd7440ad0d3944b4cd6b9df28685579ad0502b3e6f25c7870cd9116d752e50de23d7bfc452af11294f660f2514cd5
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)
vcpkg_install_cmake()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/${PORT}")
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/${PORT})
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/lib/${PORT}/cmake")
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/${PORT}/cmake)
endif()

vcpkg_copy_pdbs()


file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)


