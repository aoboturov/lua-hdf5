CC        = gcc
CPPFLAGS  =
CPPOPT    = -I$(FFI_CDECL_DIR)
CFLAGS    = -Wall -pedantic -O2
CCOPT     = -std=c99
GCCLUA    = $(CURDIR)/../../gcc-lua/gcc/gcclua.so
FFI_CDECL = $(FFI_CDECL_DIR)/ffi-cdecl.lua

ifndef FFI_CDECL_DIR
  GCC_CDECL_DIR = $(CURDIR)/..
  FFI_CDECL_DIR = $(GCC_CDECL_DIR)/ffi-cdecl
  ifdef LUA_PATH
    LUA_PATH := $(GCC_CDECL_DIR)/?.lua;$(GCC_CDECL_DIR)/?/init.lua;$(LUA_PATH)
  else
    LUA_PATH := $(GCC_CDECL_DIR)/?.lua;$(GCC_CDECL_DIR)/?/init.lua;;
  endif
  export LUA_PATH
endif

all: C.lua

%.lua: %.c %.lua.in
	$(CC) -S $(CPPOPT) $(CCOPT) $(CPPFLAGS) $(CFLAGS) -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$(FFI_CDECL) -fplugin-arg-gcclua-input=$*.lua.in -fplugin-arg-gcclua-output=$@ $<

clean:
	$(RM) C.lua

.PHONY: clean
