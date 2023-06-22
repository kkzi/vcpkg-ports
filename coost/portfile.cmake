if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO idealvin/coost
    REF "65a1aa450298a937818aaabcff22d49d6aac2670"
    SHA512 68b531e76564f08ddf3dc5db28c20d6f84c25e6504ef1b47bea64f89bbcc525f02064efdc6545b085b64ddda38d312f156a91d9d9cecb6c66fbbce1ba1bf9287
    HEAD_REF master
)

if(VCPKG_CRT_LINKAGE STREQUAL static)
    set(STATIC_VS_CRT ON)
else()
    set(STATIC_VS_CRT OFF)
endif()


vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_ALL=OFF
)
vcpkg_cmake_install()

file(INSTALL ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${CURRENT_PACKAGES_DIR}/lib/cmake/ DESTINATION ${CURRENT_PACKAGES_DIR}/share)
file(INSTALL "${SOURCE_PATH}/LICENSE.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake")
