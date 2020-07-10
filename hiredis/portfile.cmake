if (VCPKG_TARGET_IS_WINDOWS)
    #vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO redis/hiredis
    REF 392de5d7f97353485df1237872cb682842e8d83f
    SHA512 3c9c0c3e6a1a5a6d230130f0fadfdea866e39fcadbd4adccf56ca63f42da933861b0368d6badc35338970329d451a93778b69ac65b2189cfde847f561a4a20b9
    HEAD_REF master
    PATCHES
        fix-feature-example.patch
        #support-static-in-win.patch
        fix-timeval.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    ssl     ENABLE_SSL 
    example ENABLE_EXAMPLES
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${FEATURE_OPTIONS}
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
	file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
