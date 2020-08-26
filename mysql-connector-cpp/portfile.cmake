vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mysql/mysql-connector-cpp
    REF 6b2fc1020534b908f90610f5ebdcf36a7df67cfd # 8.0.21
    SHA512 addd1f2eda2b60aeca70c72b43d67fc3db13dadd3f2ccff0327433f75a70ccf82676f08960753db88a9f8ad23a47052f2e6a9b4e78ef45fa1d64ee1d39ee9ca7
    HEAD_REF master
    PATCHES

)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DWITH_SSL=system
)

vcpkg_install_cmake()

# delete debug headers
file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include)

# switch mysql into /mysql
file(RENAME ${CURRENT_PACKAGES_DIR}/include ${CURRENT_PACKAGES_DIR}/include2)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/include)
file(RENAME ${CURRENT_PACKAGES_DIR}/include2 ${CURRENT_PACKAGES_DIR}/include/mysql)

## delete useless vcruntime/scripts/bin/msg file
file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/share
    ${CURRENT_PACKAGES_DIR}/debug/share
    ${CURRENT_PACKAGES_DIR}/bin
    ${CURRENT_PACKAGES_DIR}/debug/bin
    ${CURRENT_PACKAGES_DIR}/docs
    ${CURRENT_PACKAGES_DIR}/debug/docs
    ${CURRENT_PACKAGES_DIR}/lib/debug
    ${CURRENT_PACKAGES_DIR}/lib/plugin/debug)

## remove misc files
file(REMOVE
    ${CURRENT_PACKAGES_DIR}/LICENSE
    ${CURRENT_PACKAGES_DIR}/README
    ${CURRENT_PACKAGES_DIR}/debug/LICENSE
    ${CURRENT_PACKAGES_DIR}/debug/README)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE
        ${CURRENT_PACKAGES_DIR}/lib/libmysql.lib
        ${CURRENT_PACKAGES_DIR}/lib/libmysql.dll
        ${CURRENT_PACKAGES_DIR}/lib/libmysql.pdb
        ${CURRENT_PACKAGES_DIR}/debug/lib/libmysql.lib
        ${CURRENT_PACKAGES_DIR}/debug/lib/libmysql.dll
        ${CURRENT_PACKAGES_DIR}/debug/lib/libmysql.pdb)
else()
    file(REMOVE
        ${CURRENT_PACKAGES_DIR}/lib/mysqlclient.lib
        ${CURRENT_PACKAGES_DIR}/debug/lib/mysqlclient.lib)

    # correct the dll directory
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin)
        file (RENAME ${CURRENT_PACKAGES_DIR}/lib/libmysql.dll ${CURRENT_PACKAGES_DIR}/bin/libmysql.dll)
        file (RENAME ${CURRENT_PACKAGES_DIR}/lib/libmysql.pdb ${CURRENT_PACKAGES_DIR}/bin/libmysql.pdb)
    endif()

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/bin)
        file (RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/libmysql.dll ${CURRENT_PACKAGES_DIR}/debug/bin/libmysql.dll)
        file (RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/libmysql.pdb ${CURRENT_PACKAGES_DIR}/debug/bin/libmysql.pdb)
    endif()
endif()

file(READ ${CURRENT_PACKAGES_DIR}/include/mysql/mysql_com.h _contents)
string(REPLACE "#include <mysql/udf_registration_types.h>" "#include \"mysql/udf_registration_types.h\"" _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/include/mysql/mysql_com.h "${_contents}")

# copy license
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
