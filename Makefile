#
# HDF5 for Lua.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

PREFIX = /usr/local

INSTALL_LMOD = $(PREFIX)/share/lua/5.1/hdf5
INSTALL_DIR = mkdir -p
INSTALL_DATA = install -m 644

FILES_LMOD = C.lua init.lua

hdf5:
	@$(MAKE) -C hdf5

test: hdf5
	@$(MAKE) -C test

install: hdf5
	$(INSTALL_DIR) $(DESTDIR)$(INSTALL_LMOD)
	cd hdf5 && $(INSTALL_DATA) $(FILES_LMOD) $(DESTDIR)$(INSTALL_LMOD)

clean:
	@$(MAKE) -C hdf5 clean
	@$(MAKE) -C test clean
	@$(MAKE) -C doc clean

.PHONY: hdf5 test install clean
