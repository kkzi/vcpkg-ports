vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kkzi/alog
    REF 4a2b6eabb8f5eeca6a9ecc10b2eb3dbcff5251f3 # v1.0
    SHA512 33e5f8e8e24711e7e62d7e576db3271e0aca89f058d8c5fb507b94787a476aa0914279bb17d318bb548681481f4f235b6c25215005175bd91a0a48d371f7ada4
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


