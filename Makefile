#
# HDF5 for Lua.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

hdf5:
	@$(MAKE) -C hdf5

clean:
	@$(MAKE) -C hdf5 clean
	@$(MAKE) -C doc clean

.PHONY: hdf5 clean
