if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sogou/workflow
        REF ba8585c8f462fde44c92170d1e29d6cb46880136
        SHA512 3d7989e3a4ffdae868c2592884253b1a5905618141a81fba20f21d4e438ad14af1e5bd671f399468a558d36027f279cd7303fdf0dce75b4ba43ed4aaa7ed2d9e
        HEAD_REF windows
    )
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO sogou/workflow
        REF v0.9.7
        SHA512 4866d9cfe2d9ba30f2f7866819ee8f425b91082d7f86994c1194a6b4406e8ee99e22ce6b0bafeb22c5f098f7da30029fb6b12895c2ac45810d33c28d4bfad006
        HEAD_REF master
    )
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    DISABLE_PARALLEL_CONFIGURE
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
