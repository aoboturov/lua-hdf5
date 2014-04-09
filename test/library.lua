------------------------------------------------------------------------------
-- Test library functions.
-- Copyright © 2013 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")

do
  local maj, min, rel = hdf5.get_libversion()
  assert(type(maj) == "number")
  assert(type(min) == "number")
  assert(type(rel) == "number")
end
collectgarbage()
