#
# HDF5 for Lua.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

CPP     := $(CC)
CC       = gcc
CPPFLAGS = -I$(CDECL)/ffi-cdecl
CFLAGS   = -std=c99 -Wall -pedantic
GCCLUA   = -fplugin=$(CURDIR)/../../gcc-lua/gcc/gcclua.so
CDECL    = $(CURDIR)/../../gcc-lua-cdecl
FFICDECL = $(CDECL)/ffi-cdecl/ffi-cdecl.lua
LIBNAME  = hdf5

ifdef LUA_PATH
LUA_PATH := $(CDECL)/?.lua;$(CDECL)/?/init.lua;$(LUA_PATH)
else
LUA_PATH := $(CDECL)/?.lua;$(CDECL)/?/init.lua;;
endif
export LUA_PATH

all: C.lua

%.i: %.c
	$(CPP) -E -o $@ $(CPPFLAGS) $<

%.lua: %.i %.lua.tmp
	$(CC) -S $(GCCLUA) -fplugin-arg-gcclua-script=$(FFICDECL) -fplugin-arg-gcclua-input=$*.lua.tmp -fplugin-arg-gcclua-output=$@ $(CFLAGS) $<

%.lua.tmp: %.lua.in
	sed 's#@LIBNAME@#$(LIBNAME)#' $< > $@

clean:
	$(RM) C.lua

.PHONY: clean
