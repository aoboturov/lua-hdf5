#
# C declaration composer for GCC Lua plugin.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

CC     = gcc
CFLAGS = -std=c99 -Wall
GCCLUA = $(CURDIR)/../../gcc-lua/gcc/gcclua.so

ifdef LUA_PATH
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;$(LUA_PATH)
else
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;;
endif
export LUA_PATH

all: array composite enum function pointer scalar variable vector

%: %.lua %.c
	$(CC) -S $(CFLAGS) -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$^
