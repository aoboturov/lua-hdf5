CC = gcc
CPPFLAGS =
CFLAGS = -Wall -pedantic -O2
GCCLUA = $(CURDIR)/../../gcc-lua/gcc/gcclua.so

ifdef LUA_PATH
LUA_PATH := $(CURDIR)/?.lua;$(CURDIR)/../?.lua;$(LUA_PATH)
else
LUA_PATH := $(CURDIR)/?.lua;$(CURDIR)/../?.lua;;
endif

all: C.lua

%.lua: %.c %.lua.in
	$(CC) -S $< $(CPPFLAGS) $(CFLAGS) -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$@.in -fplugin-arg-gcclua-output=$@

clean:
	$(RM) C.lua

.PHONY: clean
