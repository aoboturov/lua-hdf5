------------------------------------------------------------------------------
-- Test attributes.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi  = require("ffi")

local path = "test_attribute.h5"

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.uint64
  local space = hdf5.create_space("scalar")
  local attr = file:create_attribute("particles", dtype, space)
  space:close()
  assert(attr:get_object_name() == "/")
  assert(attr:get_object_type() == "attr")
  attr:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local attr = file:open_attribute("particles")
  assert(attr:get_name() == "particles")
  local dtype = attr:get_type()
  assert(dtype:equal(hdf5.uint64))
  dtype:close()
  local scalar = hdf5.create_space("scalar")
  local space = attr:get_space()
  assert(space:extent_equal(scalar))
  space:close()
  scalar:close()
  attr:close()
  file:close()
end

do
  local file = hdf5.open_file(path, "rdwr")
  assert(file:exists_attribute("particles") == true)
  file:rename_attribute("particles", "molecules")
  assert(file:exists_attribute("particles") == false)
  assert(file:exists_attribute("molecules") == true)
  file:delete_attribute("molecules")
  assert(file:exists_attribute("molecules") == false)
  file:close()
end

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.uint64
  local space = hdf5.create_space("scalar")
  local attr = file:create_attribute("particles", dtype, space)
  space:close()
  attr:write(ffi.new("uint64_t[1]", 50000), dtype)
  attr:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local attr = file:open_attribute("particles")
  local dtype = hdf5.int
  local buf = ffi.new("int[1]")
  attr:read(buf, dtype)
  assert(buf[0] == 50000)
  attr:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local space = hdf5.create_space("scalar")
  local attr1 = file:create_attribute("B", hdf5.double, space)
  attr1:close()
  local attr2 = file:create_attribute("A", hdf5.double, space)
  attr2:close()
  local attr3 = file:create_attribute("C", hdf5.double, space)
  attr3:close()
  space:close()

  assert(file:get_attr_name_by_idx(".", 0, "name", "inc") == "A")
  assert(file:get_attr_name_by_idx(".", 1, "name", "inc") == "B")
  assert(file:get_attr_name_by_idx(".", 2, "name", "inc") == "C")

  assert(file:get_attr_name_by_idx(".", 0, "name", "dec") == "C")
  assert(file:get_attr_name_by_idx(".", 1, "name", "dec") == "B")
  assert(file:get_attr_name_by_idx(".", 2, "name", "dec") == "A")

  file:close()
end

do
  local fcpl = hdf5.create_plist("file_create")
  fcpl:set_attr_creation_order("tracked")
  local file = hdf5.create_file(path, nil, fcpl)
  fcpl:close()
  local space = hdf5.create_space("scalar")
  local attr1 = file:create_attribute("B", hdf5.double, space)
  attr1:close()
  local attr2 = file:create_attribute("A", hdf5.double, space)
  attr2:close()
  local attr3 = file:create_attribute("C", hdf5.double, space)
  attr3:close()
  space:close()

  assert(file:get_attr_name_by_idx(".", 0, "crt_order", "inc") == "B")
  assert(file:get_attr_name_by_idx(".", 1, "crt_order", "inc") == "A")
  assert(file:get_attr_name_by_idx(".", 2, "crt_order", "inc") == "C")

  assert(file:get_attr_name_by_idx(".", 0, "crt_order", "dec") == "C")
  assert(file:get_attr_name_by_idx(".", 1, "crt_order", "dec") == "A")
  assert(file:get_attr_name_by_idx(".", 2, "crt_order", "dec") == "B")

  file:close()
end

os.remove(path)
