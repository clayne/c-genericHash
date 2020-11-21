MACRO (MYPACKAGEREPAIR)
  #
  # We optionaly create a __fixme__.cmake
  #
  IF (NOT FIXME_CMAKE_SINGLETON)
    IF ((NOT HAVE_STDINT_H) OR (NOT HAVE_INTTYPES_H))
      GET_PROPERTY(source_dir GLOBAL PROPERTY MYPACKAGE_SOURCE_DIR)
      MESSAGE(STATUS "Generating a __fixme__.cmake")
      SET (FIXME_CMAKE "__fixme__.cmake")
      GET_FILENAME_COMPONENT(FIXME_CMAKE_ABSOLUTE ${FIXME_CMAKE} ABSOLUTE)
      FILE(WRITE ${FIXME_CMAKE_ABSOLUTE} "# CMake settings to be propagated whenever you want - typically used for ExternalProject_Add\n")
      MARK_AS_ADVANCED (FIXME_CMAKE_ABSOLUTE)

      GET_PROPERTY(source_dir_set GLOBAL PROPERTY MYPACKAGE_SOURCE_DIR SET)
      IF (NOT ${source_dir_set})
        MESSAGE (WARNING "Cannot repair anything if any, property MYPACKAGE_SOURCE_DIR is not set")
      ELSE ()
        GET_PROPERTY(source_dir GLOBAL PROPERTY MYPACKAGE_SOURCE_DIR)
        SET(MYPACKAGE_GENERATED_INCLUDE_DIR "__generated_include_dir__")
        FILE(MAKE_DIRECTORY ${MYPACKAGE_GENERATED_INCLUDE_DIR})
        GET_FILENAME_COMPONENT(_MYPACKAGE_GENERATED_INCLUDE_DIR_ABSOLUTE ${MYPACKAGE_GENERATED_INCLUDE_DIR} ABSOLUTE)
        INCLUDE_DIRECTORIES(${_MYPACKAGE_GENERATED_INCLUDE_DIR_ABSOLUTE})
        MESSAGE(STATUS "Appending in ${FIXME_CMAKE}: INCLUDE_DIRECTORIES(${_MYPACKAGE_GENERATED_INCLUDE_DIR_ABSOLUTE})")
        FILE(APPEND ${FIXME_CMAKE_ABSOLUTE} "MESSAGE(STATUS \"Append to INCLUDE_DIRECTORIES: ${_MYPACKAGE_GENERATED_INCLUDE_DIR_ABSOLUTE}\")\n")
        FILE(APPEND ${FIXME_CMAKE_ABSOLUTE} "INCLUDE_DIRECTORIES(${_MYPACKAGE_GENERATED_INCLUDE_DIR_ABSOLUTE})\n")

        IF (NOT HAVE_STDINT_H)
          SET (STDINT_REPAIR_H ${MYPACKAGE_GENERATED_INCLUDE_DIR}/stdint.h)
          MESSAGE(STATUS "Generating a minimal stdint.h in ${STDINT_REPAIR_H}")
          CONFIGURE_FILE(${source_dir}/stdint.h.in ${STDINT_REPAIR_H})
          SET (HAVE_STDINT_H TRUE CACHE BOOL "C stdint.h generated file")
          MARK_AS_ADVANCED (HAVE_STDINT_H)
        ENDIF ()

        IF (NOT HAVE_INTTYPES_H)
          SET (INTTYPES_REPAIR_H ${MYPACKAGE_GENERATED_INCLUDE_DIR}/inttypes.h)
          MESSAGE(STATUS "Generating a minimal inttypes.h in ${INTTYPES_REPAIR_H}")
          CONFIGURE_FILE(${source_dir}/inttypes.h.in ${INTTYPES_REPAIR_H})
          SET (HAVE_INTTYPES_H TRUE CACHE BOOL "C inttypes.h generated file")
          MARK_AS_ADVANCED (HAVE_INTTYPES_H)
        ENDIF ()

      ENDIF ()
    ENDIF ()

    SET (FIXME_CMAKE_SINGLETON TRUE CACHE BOOL "__fixme__.cmake singleton")
    MARK_AS_ADVANCED (FIXME_CMAKE_SINGLETON)
  ENDIF ()
ENDMACRO()
