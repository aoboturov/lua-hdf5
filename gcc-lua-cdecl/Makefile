#
# C declaration composer for GCC Lua plugin.
# Copyright © 2013 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

PREFIX = /usr/local
LUADIR = $(PREFIX)/share/lua/5.1
INCDIR = $(PREFIX)/include
DOCDIR = $(PREFIX)/share/doc/gcc-lua-cdecl

INSTALL_D = install -d
INSTALL_F = install -m 644

FILES_LUA = cdecl.lua
FILES_DOC = index.mdwn INSTALL.mdwn README.mdwn ffi-cdecl.mdwn reference.mdwn CHANGES.mdwn
FILES_DOC_HTML = index.html INSTALL.html README.html ffi-cdecl.html reference.html CHANGES.html pandoc.css gcc-lua-cdecl.png
FILES_FFICDECL_LUA = ffi-cdecl.lua
FILES_FFICDECL_INC = ffi-cdecl.h ffi-cdecl-luajit.h ffi-cdecl-python.h
FILES_FFICDECL_DOC = C.c C.lua.in Makefile

all: test

install:
	$(INSTALL_D) $(DESTDIR)$(LUADIR)/gcc
	cd gcc && $(INSTALL_F) $(FILES_LUA) $(DESTDIR)$(LUADIR)/gcc
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)
	cd doc && $(INSTALL_F) $(FILES_DOC) $(FILES_DOC_HTML) $(DESTDIR)$(DOCDIR)
	$(INSTALL_D) $(DESTDIR)$(LUADIR)
	cd ffi-cdecl && $(INSTALL_F) $(FILES_FFICDECL_LUA) $(DESTDIR)$(LUADIR)
	$(INSTALL_D) $(DESTDIR)$(INCDIR)
	cd ffi-cdecl && $(INSTALL_F) $(FILES_FFICDECL_INC) $(DESTDIR)$(INCDIR)
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)/examples/ffi-cdecl
	cd ffi-cdecl && $(INSTALL_F) $(FILES_FFICDECL_DOC) $(DESTDIR)$(DOCDIR)/examples/ffi-cdecl

clean:

SUBDIRS = test doc

.PHONY: $(SUBDIRS)

$(SUBDIRS):
	@$(MAKE) -C $@
