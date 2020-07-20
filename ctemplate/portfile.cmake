include(vcpkg_common_functions)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO OlafvdSpek/ctemplate
  REF 25c570cdb50e11c19aac5f2398e845b570eca76b
  SHA512 d51f73077982cfe7ec698090ce3527c47ff503a51b3204846c1009ce88dc9424f0a71d9af4e8fb48579c53290b8d9eed7a41d884dbb7936b319975ec5e89e977
  HEAD_REF master
)

if (VCPKG_TARGET_IS_WINDOWS)
  vcpkg_apply_patchs(fix-msvc.patch)
endif()


file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_find_acquire_program(PYTHON3)

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS -DPYTHON_EXECUTABLE=${PYTHON3}
  OPTIONS_DEBUG -DDISABLE_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/ctemplate RENAME copyright)

vcpkg_copy_pdbs()
