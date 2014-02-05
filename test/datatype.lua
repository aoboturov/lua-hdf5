------------------------------------------------------------------------------
-- Test datatypes.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi  = require("ffi")

local path = "test_datatype.h5"

do
  local dtype = hdf5.c_s1:copy()
  assert(dtype:get_class() == "string")
  assert(dtype:get_size() == 1)
  dtype:set_size(101)
  assert(dtype:get_size() == 101)
end
collectgarbage()

do
  local dtype = hdf5.c_s1:copy()
  assert(dtype:is_variable_str() == false)
  dtype:set_size("variable")
  assert(dtype:is_variable_str() == true)
end
collectgarbage()

do
  local dtype = hdf5.c_s1:copy()
  assert(dtype:get_cset() == "ascii")
  dtype:set_cset("utf8")
  assert(dtype:get_cset() == "utf8")
  dtype:set_cset("ascii")
  assert(dtype:get_cset() == "ascii")
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.double:copy()
  assert(dtype:committed() == false)
  dtype:commit(file, "datatype")
  assert(dtype:committed() == true)
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.double:copy()
  assert(dtype:committed() == false)
  dtype:commit_anon(file)
  assert(dtype:committed() == true)
end
collectgarbage()

do
  local species = {H = 1, Li = 3, Na = 11, K = 19}
  local dtype = hdf5.int8:enum_create()
  assert(dtype:get_class() == "enum")
  dtype:enum_insert("H", ffi.new("int8_t[1]", species.H))
  dtype:enum_insert("Li", ffi.new("int8_t[1]", species.Li))
  dtype:enum_insert("Na", ffi.new("int8_t[1]", species.Na))
  dtype:enum_insert("K", ffi.new("int8_t[1]", species.K))
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.H)) == "H")
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.Li)) == "Li")
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.Na)) == "Na")
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.K)) == "K")
  local value = ffi.new("int8_t[1]")
  dtype:enum_valueof("H", value)
  assert(value[0] == 1)
  dtype:enum_valueof("Li", value)
  assert(value[0] == 3)
  dtype:enum_valueof("Na", value)
  assert(value[0] == 11)
  dtype:enum_valueof("K", value)
  assert(value[0] == 19)
end
collectgarbage()

do
  local species = {H = 1, Li = 3, Na = 11, K = 19}
  local file = hdf5.create_file(path)
  local dtype = hdf5.int8:enum_create()
  dtype:enum_insert("H", ffi.new("int8_t[1]", species.H))
  dtype:enum_insert("Li", ffi.new("int8_t[1]", species.Li))
  dtype:enum_insert("Na", ffi.new("int8_t[1]", species.Na))
  dtype:enum_insert("K", ffi.new("int8_t[1]", species.K))
  local space = hdf5.create_simple_space({3, 2})
  local dset = file:create_dataset("species", dtype, space)
  local buf = ffi.new("int8_t[3][2]", {{11, 1}, {19, 1}, {19, 3}})
  dset:write(buf, dtype)
end
collectgarbage()

do
  local species = {H = 0, Li = 1, Na = 2, K = 3}
  local file = hdf5.open_file(path)
  local dset = file:open_dataset("species")
  local memtype = hdf5.int:enum_create()
  memtype:enum_insert("H", ffi.new("int[1]", species.H))
  memtype:enum_insert("Li", ffi.new("int[1]", species.Li))
  memtype:enum_insert("Na", ffi.new("int[1]", species.Na))
  memtype:enum_insert("K", ffi.new("int[1]", species.K))
  local dspace = hdf5.create_simple_space({3, 2})
  local buf = ffi.new("int[3][2]")
  dset:read(buf, memtype, dspace)
  assert(buf[0][0] == species.Na)
  assert(buf[0][1] == species.H)
  assert(buf[1][0] == species.K)
  assert(buf[1][1] == species.H)
  assert(buf[2][0] == species.K)
  assert(buf[2][1] == species.Li)
end
collectgarbage()

os.remove(path)
