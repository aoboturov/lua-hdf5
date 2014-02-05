#
# HDF5 for Lua.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

CPP      := $(CC)
ifneq (,$(findstring H5_HAVE_PARALLEL,$(shell $(CC) -E -dM -include H5pubconf.h -x c /dev/null)))
  CPP     = mpicc
endif
CC        = gcc
CPPFLAGS  = -I$(FFI_CDECL_DIR)
CFLAGS    = -Wall -pedantic
GCCLUA    = $(CURDIR)/../../gcc-lua/gcc/gcclua.so
FFI_CDECL = $(FFI_CDECL_DIR)/ffi-cdecl.lua
LIBNAME   = hdf5

ifndef FFI_CDECL_DIR
  GCC_CDECL_DIR = $(CURDIR)/../../gcc-lua-cdecl
  FFI_CDECL_DIR = $(GCC_CDECL_DIR)/ffi-cdecl
  ifdef LUA_PATH
    LUA_PATH := $(GCC_CDECL_DIR)/?.lua;$(GCC_CDECL_DIR)/?/init.lua;$(LUA_PATH)
  else
    LUA_PATH := $(GCC_CDECL_DIR)/?.lua;$(GCC_CDECL_DIR)/?/init.lua;;
  endif
  export LUA_PATH
endif

all: C.lua

%.i: %.c
	$(CPP) -E -o $@ $(CPPFLAGS) $<

%.lua: %.i %.lua.tmp
	$(CC) -S -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$(FFI_CDECL) -fplugin-arg-gcclua-input=$*.lua.tmp -fplugin-arg-gcclua-output=$@ $(CFLAGS) $<

%.lua.tmp: %.lua.in
	sed 's#@LIBNAME@#$(LIBNAME)#' $< > $@

clean:
	$(RM) C.lua

.PHONY: clean
