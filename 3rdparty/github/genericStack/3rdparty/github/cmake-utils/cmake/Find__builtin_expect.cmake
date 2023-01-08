MACRO (FIND__BUILTIN_EXPECT)
  GET_PROPERTY(source_dir_set GLOBAL PROPERTY MYPACKAGE_SOURCE_DIR SET)
  IF (NOT ${source_dir_set})
    MESSAGE (WARNING "Cannot check __builtin_expect, property MYPACKAGE_SOURCE_DIR is not set")
  ELSE ()
    IF (NOT C___BUILTIN_EXPECT_SINGLETON)
      GET_PROPERTY(source_dir GLOBAL PROPERTY MYPACKAGE_SOURCE_DIR)
      SET (_C___BUILTIN_EXPECT_FOUND FALSE)
      #
      # Test
      #
      FOREACH (KEYWORD "__builtin_expect")
        MESSAGE(STATUS "Looking for ${KEYWORD}")
        TRY_COMPILE (C_HAS_${KEYWORD} ${CMAKE_CURRENT_BINARY_DIR}
          ${source_dir}/__builtin_expect.c
          COMPILE_DEFINITIONS -DC__BUILTIN_EXPECT=${KEYWORD})
        IF (C_HAS_${KEYWORD})
          MESSAGE(STATUS "Looking for ${KEYWORD} - found")
          SET (_C___BUILTIN_EXPECT ${KEYWORD})
          SET (_C___BUILTIN_EXPECT_FOUND TRUE)
          BREAK ()
        ENDIF ()
      ENDFOREACH ()
    ENDIF ()
    IF (_C___BUILTIN_EXPECT_FOUND)
      SET (C___BUILTIN_EXPECT "${_C___BUILTIN_EXPECT}" CACHE STRING "C __builtin_expect implementation")
      MARK_AS_ADVANCED (C___BUILTIN_EXPECT)
    ENDIF ()
    SET (C___BUILTIN_EXPECT_SINGLETON TRUE CACHE BOOL "C __builtin_expect check singleton")
    MARK_AS_ADVANCED (C___BUILTIN_EXPECT_SINGLETON)
  ENDIF ()
ENDMACRO()