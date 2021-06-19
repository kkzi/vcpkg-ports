include(vcpkg_execute_in_download_mode)
function(vcpkg_from_gitee)
  set(oneValueArgs OUT_SOURCE_PATH URL REF TAG X_OUT_REF)
  set(multipleValuesArgs PATCHES)
  # parse parameters such that semicolons in options arguments to COMMAND don't get erased
  cmake_parse_arguments(PARSE_ARGV 0 _vdud "" "${oneValueArgs}" "${multipleValuesArgs}")

  if(NOT DEFINED _vdud_OUT_SOURCE_PATH)
    message(FATAL_ERROR "OUT_SOURCE_PATH must be specified.")
  endif()

  if(NOT DEFINED _vdud_URL)
    message(FATAL_ERROR "The git url must be specified")
  endif()

  if(NOT DEFINED _vdud_REF)
    message(FATAL_ERROR "The git ref must be specified.")
  endif()

  if(NOT DEFINED _vdud_TAG)
    set(_vdud_TAG ${_vdud_REF})
  endif()
  
  # using .tar.gz instead of .zip because the hash of the latter is affected by timezone.
  string(REPLACE "/" "-" SANITIZED_REF "${_vdud_TAG}")
  set(TEMP_ARCHIVE "${DOWNLOADS}/temp/${PORT}-${SANITIZED_REF}.tar.gz")
  set(ARCHIVE "${DOWNLOADS}/${PORT}-${SANITIZED_REF}.tar.gz")
  set(TEMP_SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/src/${SANITIZED_REF}")

  if(NOT EXISTS "${ARCHIVE}")
    if(_VCPKG_NO_DOWNLOADS)
        message(FATAL_ERROR "Downloads are disabled, but '${ARCHIVE}' does not exist.")
    endif()
    message(STATUS "Fetching ${_vdud_URL}...")
    find_program(GIT NAMES git git.cmd)
    find_program(TAR NAMES tar)
    # Note: git init is safe to run multiple times
    vcpkg_execute_required_process(
      ALLOW_IN_DOWNLOAD_MODE
      COMMAND ${GIT} clone --recursive ${_vdud_URL} ${PORT}-${_vdud_TAG} 
      WORKING_DIRECTORY ${DOWNLOADS}/git-tmp
      LOGNAME git-fetch-${TARGET_TRIPLET}
    )

    file(MAKE_DIRECTORY "${DOWNLOADS}/temp")
    vcpkg_execute_required_process(
      ALLOW_IN_DOWNLOAD_MODE
      COMMAND ${TAR} --exclude .git -czvf ${TEMP_ARCHIVE} .
      WORKING_DIRECTORY ${DOWNLOADS}/git-tmp/${PORT}-${_vdud_TAG}
      LOGNAME archive
    )

    get_filename_component(downloaded_file_dir "${ARCHIVE}" DIRECTORY)
    file(MAKE_DIRECTORY "${downloaded_file_dir}")
    file(RENAME "${TEMP_ARCHIVE}" "${ARCHIVE}")
  else()
    message(STATUS "Using cached ${ARCHIVE}")
  endif()

  vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF "${SANITIZED_REF}"
    PATCHES ${_vdud_PATCHES}
    NO_REMOVE_ONE_LEVEL
  )

  set(${_vdud_OUT_SOURCE_PATH} "${SOURCE_PATH}" PARENT_SCOPE)
endfunction()

vcpkg_from_gitee(
    OUT_SOURCE_PATH SOURCE_PATH
    URL git@gitee.com:dataps/data_process_core.git
    REF develop
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
       -DBOOST_ROOT=D:/Local/boost_1_73_0
)

vcpkg_install_cmake()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/${PORT}")
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/${PORT})
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/lib/${PORT}/cmake")
    vcpkg_fixup_cmake_targets(CONFIG_PATH lib/${PORT}/cmake)
endif()

vcpkg_copy_pdbs()


#file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)


