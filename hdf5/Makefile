#
# HDF5 for Lua.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

CPP      := $(CC)
CPPFLAGS  =
ifneq (,$(findstring H5_HAVE_PARALLEL,$(shell $(CC) $(CPPFLAGS) -E -dM -include H5pubconf.h -x c /dev/null)))
  CPP     = mpicc
endif
CC        = gcc
CFLAGS    = -Wall -pedantic -Wno-long-long
GCCLUA    = gcclua
LIBNAME   = hdf5

all: C.lua

%.i: %.c
	$(CPP) -E -o $@ $(CPPFLAGS) $<

%.lua: %.i %.lua.in
	$(CC) -S -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$@.in -fplugin-arg-gcclua-output=$@ -fplugin-arg-gcclua-libname=$(LIBNAME) $(CFLAGS) $<

clean:
	$(RM) C.lua

.PHONY: clean
