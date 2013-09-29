#
# C declaration composer for GCC Lua plugin.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

PREFIX = /usr/local

INSTALL_LMOD     = $(PREFIX)/share/lua/5.1/gcc
INSTALL_FFICDECL = $(PREFIX)/share/ffi-cdecl
INSTALL_DOC      = $(PREFIX)/share/doc/gcc-lua-cdecl
INSTALL_DOC_HTML = $(INSTALL_DOC)/html

INSTALL_D = install -d
INSTALL_F = install -m 644

FILES_LMOD     = cdecl.lua
FILES_FFICDECL = ffi-cdecl.lua ffi-cdecl.h ffi-cdecl-luajit.h ffi-cdecl-python.h
FILES_DOC      = index.mdwn INSTALL.mdwn README.mdwn ffi-cdecl.mdwn reference.mdwn
FILES_DOC_HTML = index.html INSTALL.html README.html ffi-cdecl.html reference.html pandoc.css gcc-lua-cdecl.png

test:
	@$(MAKE) -C test

install: doc
	$(INSTALL_D) $(DESTDIR)$(INSTALL_LMOD)
	cd gcc && $(INSTALL_F) $(FILES_LMOD) $(DESTDIR)$(INSTALL_LMOD)
	$(INSTALL_D) $(DESTDIR)$(INSTALL_FFICDECL)
	cd ffi-cdecl && $(INSTALL_F) $(FILES_FFICDECL) $(DESTDIR)$(INSTALL_FFICDECL)
	$(INSTALL_D) $(DESTDIR)$(INSTALL_DOC)
	cd doc && $(INSTALL_F) $(FILES_DOC) $(DESTDIR)$(INSTALL_DOC)
	$(INSTALL_D) $(DESTDIR)$(INSTALL_DOC_HTML)
	cd doc && $(INSTALL_F) $(FILES_DOC_HTML) $(DESTDIR)$(INSTALL_DOC_HTML)

doc:
	@$(MAKE) -C doc

clean:
	@$(MAKE) -C doc clean

.PHONY: test install doc clean
