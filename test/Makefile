#
# C declaration composer for the GCC Lua plugin.
# Copyright © 2013–2015 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

CC = gcc
CFLAGS = -Wall
CCOPT = -std=gnu99
GCCLUA = $(CURDIR)/../../gcc-lua/gcc/gcclua.so

ifdef LUA_PATH
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;$(LUA_PATH)
else
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;;
endif
export LUA_PATH

all: array composite enum function pointer scalar variable vector

%: %.c %.lua
	$(CC) -S $(CCOPT) $(CFLAGS) -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$*.lua $<
