#
# HDF5 for Lua.
# Copyright © 2013–2014 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

CPP      := $(CC)
CPPFLAGS  = -I$(CURDIR)/../gcc-lua-cdecl/ffi-cdecl
ifneq (,$(findstring H5_HAVE_PARALLEL,$(shell $(CC) $(CPPFLAGS) -E -dM -include H5pubconf.h -x c /dev/null)))
  CPP     = mpicc
endif
CC        = gcc
CFLAGS    = -Wall
LDFLAGS   = -ldl -lhdf5
GCCLUA    = $(CURDIR)/../gcc-lua/gcc/gcclua.so
LIBNAME   = $(firstword $(shell $(CURDIR)/hdf5) hdf5)

ifdef LUA_PATH
LUA_PATH := $(CURDIR)/../gcc-lua-cdecl/ffi-cdecl/?.lua;$(CURDIR)/../gcc-lua-cdecl/?.lua;$(LUA_PATH)
else
LUA_PATH := $(CURDIR)/../gcc-lua-cdecl/ffi-cdecl/?.lua;$(CURDIR)/../gcc-lua-cdecl/?.lua;;
endif

all: C.lua

C.i: C.c
	$(CPP) -E -o $@ $(CPPFLAGS) $<

C.lua: C.i C.lua.in hdf5
	$(CC) -S -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$@.in -fplugin-arg-gcclua-output=$@ -fplugin-arg-gcclua-libname=$(LIBNAME) $(CFLAGS) $<

hdf5: hdf5.c
	$(CPP) -fPIE -o $@ $(CFLAGS) $< $(LDFLAGS)

clean:
	$(RM) C.lua

.INTERMEDIATE: C.i hdf5
