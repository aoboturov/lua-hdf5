#
# HDF5 for Lua.
# Copyright © 2013–2015 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

LUA     = luajit
MPIEXEC =

ifdef LUA_PATH
  LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;$(LUA_PATH)
else
  LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;;
endif
export LUA_PATH

TESTS = library file group dataset attribute dataspace datatype link object reference

ifdef MPIEXEC
  TESTS += mpio
endif

all: $(TESTS)

%: %.lua
	$(LUA) $<

mpio: mpio.lua
	$(MPIEXEC) $(LUA) $<

clean:
	$(RM) *.h5 *.out

.PHONY: clean
