vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mfontanini/cppkafka
    REF 76d175e35431bfd82ae5b5a133565044c56c7a4f
    SHA512 6b205dfdd755efd1d97eb0b131ef3295d61278abb966d4c924df84c4ec5928b172e8c106f43eeece40c091edef21a542d1ba712ac1b943045276a9cdab5229fa
    HEAD_REF master
    PATCHES fix-msvc.patch
)

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(CPPKAFKA_BUILD_SHARED OFF)
else()
    set(CPPKAFKA_BUILD_SHARED ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
       -DCPPKAFKA_BUILD_SHARED=ON
       -DCPPKAFKA_DISABLE_TESTS=ON
       -DCPPKAFKA_DISABLE_EXAMPLES=ON
       -DBOOST_ROOT=D:/local/boost_1_73_0
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
