#
# C declaration composer for GCC Lua plugin.
# Copyright © 2013 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

test:
	@$(MAKE) -C test

clean:
	@$(MAKE) -C doc clean

.PHONY: test clean
