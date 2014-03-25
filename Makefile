#
# HDF5 for Lua.
# Copyright © 2013–2014 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

PREFIX = /usr/local
LUADIR = $(PREFIX)/share/lua/5.1

INSTALL_D = mkdir -p
INSTALL_F = install -m 644

FILES_LUA = C.lua init.lua

all: hdf5

hdf5:
	@$(MAKE) -C hdf5

test:
	@$(MAKE) -C test

install:
	$(INSTALL_D) $(DESTDIR)$(LUADIR)/hdf5
	cd hdf5 && $(INSTALL_F) $(FILES_LUA) $(DESTDIR)$(LUADIR)/hdf5

clean:
	@$(MAKE) -C hdf5 clean
	@$(MAKE) -C test clean
	@$(MAKE) -C doc clean

.PHONY: hdf5 test install clean
