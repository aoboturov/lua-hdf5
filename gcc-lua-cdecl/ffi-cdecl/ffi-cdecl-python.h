#ifndef FFI_CDECL_PYTHON_H
#define FFI_CDECL_PYTHON_H

/* http://cffi.readthedocs.org/en/latest/#declaring-types-and-functions */

#include <stddef.h>
cdecl_typename(ptrdiff_t)
cdecl_typename(size_t)
cdecl_typename(wchar_t)

#include <stdint.h>
cdecl_typename(int8_t)
cdecl_typename(int16_t)
cdecl_typename(int32_t)
cdecl_typename(int64_t)
cdecl_typename(uint8_t)
cdecl_typename(uint16_t)
cdecl_typename(uint32_t)
cdecl_typename(uint64_t)
cdecl_typename(intptr_t)
cdecl_typename(uintptr_t)

#if __STDC_VERSION__ >= 199901L
#include <stdbool.h>
cdecl_typename(bool)
#endif

#include <sys/types.h>
cdecl_typename(ssize_t)

#include <stdio.h>
cdecl_typename(FILE)

#endif
