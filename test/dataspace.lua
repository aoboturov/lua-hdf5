------------------------------------------------------------------------------
-- Test dataspaces.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi  = require("ffi")

do
  local space = hdf5.create_space("scalar")
  assert(space:get_simple_extent_type() == "scalar")
  local space = hdf5.create_space("simple")
  assert(space:get_simple_extent_type() == "simple")
  local space = hdf5.create_space("null")
  assert(space:get_simple_extent_type() == "null")
end
collectgarbage()

do
  local space = hdf5.create_simple_space({})
  assert(space:get_simple_extent_type() == "scalar")
  local dims, maxdims = space:get_simple_extent_dims()
  assert(#dims == 0)
  assert(#maxdims == 0)
end
collectgarbage()

do
  local space = hdf5.create_simple_space({2, 3, 4})
  assert(space:get_simple_extent_type() == "simple")
  local dims, maxdims = space:get_simple_extent_dims()
  assert(#dims == 3)
  assert(dims[1] == 2)
  assert(dims[2] == 3)
  assert(dims[3] == 4)
  assert(maxdims[1] == 2)
  assert(maxdims[2] == 3)
  assert(maxdims[3] == 4)
  space:set_extent_simple({5, 6})
  local dims, maxdims = space:get_simple_extent_dims()
  assert(#dims == 2)
  assert(dims[1] == 5)
  assert(dims[2] == 6)
  assert(maxdims[1] == 5)
  assert(maxdims[2] == 6)
end
collectgarbage()

do
  local space = hdf5.create_simple_space({2, 3}, {nil, 5})
  local dims, maxdims = space:get_simple_extent_dims()
  assert(#dims == 2)
  assert(dims[1] == 2)
  assert(dims[2] == 3)
  assert(maxdims[1] == nil)
  assert(maxdims[2] == 5)
  space:set_extent_simple({1, 4, 2}, {nil, nil, 2})
  local dims, maxdims = space:get_simple_extent_dims()
  assert(#dims == 3)
  assert(dims[1] == 1)
  assert(dims[2] == 4)
  assert(dims[3] == 2)
  assert(maxdims[1] == nil)
  assert(maxdims[2] == nil)
  assert(maxdims[3] == 2)
end
collectgarbage()

do
 local space = hdf5.create_simple_space({2, 3, 4})
 space:select_hyperslab("set", {0, 0, 0}, nil, {2, 3, 4})
 assert(space:select_valid() == true)
 space:select_hyperslab("set", {0, 0, 0}, nil, {2, 3, 5})
 assert(space:select_valid() == false)
end
collectgarbage()

do
  local space = hdf5.create_simple_space({10})
  space:select_hyperslab("set", {9}, nil, {1})
  assert(space:select_valid() == true)
  space:offset_simple({1})
  assert(space:select_valid() == false)
  space:offset_simple({0})
  assert(space:select_valid() == true)
  space:offset_simple({-10})
  assert(space:select_valid() == false)
  space:offset_simple({-9})
  assert(space:select_valid() == true)
end
collectgarbage()
