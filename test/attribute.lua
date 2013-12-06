------------------------------------------------------------------------------
-- Test attributes.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi  = require("ffi")

local path = "test_attribute.h5"

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.uint64
  local space = hdf5.create_space("scalar")
  local attr = file:create_attribute("particles", dtype, space)
  assert(attr:get_object_name() == "/")
  assert(attr:get_object_type() == "attr")
end
collectgarbage()

do
  local file = hdf5.open_file(path)
  local attr = file:open_attribute("particles")
  assert(attr:get_name() == "particles")
  local dtype = hdf5.uint64
  assert(attr:get_type():equal(dtype))
  local space = hdf5.create_space("scalar")
  assert(attr:get_space():extent_equal(space))
end
collectgarbage()

do
  local file = hdf5.open_file(path, "rdwr")
  assert(file:exists_attribute("particles") == true)
  file:rename_attribute("particles", "molecules")
  assert(file:exists_attribute("particles") == false)
  assert(file:exists_attribute("molecules") == true)
  file:delete_attribute("molecules")
  assert(file:exists_attribute("molecules") == false)
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.uint64
  local space = hdf5.create_space("scalar")
  local attr = file:create_attribute("particles", dtype, space)
  attr:write(ffi.new("uint64_t[1]", 50000), dtype)
end
collectgarbage()

do
  local file = hdf5.open_file(path)
  local attr = file:open_attribute("particles")
  local dtype = hdf5.int
  local buf = ffi.new("int[1]")
  attr:read(buf, dtype)
  assert(buf[0] == 50000)
end
collectgarbage()

os.remove(path)
