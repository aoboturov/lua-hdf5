#
# HDF5 for Lua.
# Copyright © 2013–2014 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

PREFIX = /usr/local
LUADIR = $(PREFIX)/share/lua/5.1
DOCDIR = $(PREFIX)/share/doc/lua-hdf5

INSTALL_D = mkdir -p
INSTALL_F = install -m 644

FILES_LUA = C.lua init.lua
FILES_DOC = index.mdwn INSTALL.mdwn reference.mdwn
FILES_DOC_HTML = index.html INSTALL.html reference.html pandoc.css lua-hdf5.png

all: hdf5 doc

hdf5:
	@$(MAKE) -C hdf5

test:
	@$(MAKE) -C test

doc:
	@$(MAKE) -C doc

install:
	$(INSTALL_D) $(DESTDIR)$(LUADIR)/hdf5
	cd hdf5 && $(INSTALL_F) $(FILES_LUA) $(DESTDIR)$(LUADIR)/hdf5
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)
	cd doc && $(INSTALL_F) $(FILES_DOC) $(FILES_DOC_HTML) $(DESTDIR)$(DOCDIR)

clean:
	@$(MAKE) -C hdf5 clean
	@$(MAKE) -C test clean
	@$(MAKE) -C doc clean

.PHONY: hdf5 test doc install clean
