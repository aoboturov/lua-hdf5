CC       = gcc
CPPFLAGS = -I$(CDECL)/ffi-cdecl
CFLAGS   = -std=c99 -Wall -pedantic
GCCLUA   = -fplugin=$(CURDIR)/../../gcc-lua/gcc/gcclua.so
CDECL    = $(CURDIR)/..
FFICDECL = $(CDECL)/ffi-cdecl/ffi-cdecl.lua

ifdef LUA_PATH
LUA_PATH := $(CDECL)/?.lua;$(CDECL)/?/init.lua;$(LUA_PATH)
else
LUA_PATH := $(CDECL)/?.lua;$(CDECL)/?/init.lua;;
endif
export LUA_PATH

all: C.lua

%.lua: %.c %.lua.in
	$(CC) -S $< $(GCCLUA) -fplugin-arg-gcclua-script=$(FFICDECL) -fplugin-arg-gcclua-input=$*.lua.in -fplugin-arg-gcclua-output=$@ $(CPPFLAGS) $(CFLAGS)

clean:
	$(RM) C.lua

.PHONY: clean
