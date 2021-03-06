------------------------------------------------------------------------------
-- Test datatypes.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
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
  dtype:close()
end

do
  local dtype = hdf5.c_s1:copy()
  assert(dtype:is_variable_str() == false)
  dtype:set_size("variable")
  assert(dtype:is_variable_str() == true)
  dtype:close()
end

do
  local dtype = hdf5.c_s1:copy()
  assert(dtype:get_cset() == "ascii")
  dtype:set_cset("utf8")
  assert(dtype:get_cset() == "utf8")
  dtype:set_cset("ascii")
  assert(dtype:get_cset() == "ascii")
  dtype:close()
end

do
  local dtype = hdf5.uint32:copy()
  assert(dtype:get_precision() == 32)
  assert(dtype:get_offset() == 0)
  dtype:set_precision(16)
  assert(dtype:get_precision() == 16)
  assert(dtype:get_offset() == 0)
  dtype:set_offset(16)
  assert(dtype:get_precision() == 16)
  assert(dtype:get_offset() == 16)
  dtype:set_precision(32)
  assert(dtype:get_precision() == 32)
  assert(dtype:get_offset() == 0)
  dtype:close()
end

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.double:copy()
  assert(dtype:committed() == false)
  dtype:commit(file, "datatype")
  assert(dtype:committed() == true)
  dtype:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.double:copy()
  assert(dtype:committed() == false)
  dtype:commit_anon(file)
  assert(dtype:committed() == true)
  dtype:close()
  file:close()
end

do
  local species = {H = 1, Li = 3, Na = 11, K = 19}
  local value = ffi.new("int8_t[1]")
  local dtype = hdf5.int8:enum_create()
  assert(dtype:get_class() == "enum")
  assert(dtype:get_nmembers() == 0)
  dtype:enum_insert("H", ffi.new("int8_t[1]", species.H))
  dtype:enum_insert("Li", ffi.new("int8_t[1]", species.Li))
  dtype:enum_insert("Na", ffi.new("int8_t[1]", species.Na))
  dtype:enum_insert("K", ffi.new("int8_t[1]", species.K))
  assert(dtype:get_nmembers() == 4)
  assert(dtype:get_member_name(0) == "H")
  assert(dtype:get_member_name(1) == "Li")
  assert(dtype:get_member_name(2) == "Na")
  assert(dtype:get_member_name(3) == "K")
  assert(dtype:get_member_index("H") == 0)
  assert(dtype:get_member_index("Li") == 1)
  assert(dtype:get_member_index("Na") == 2)
  assert(dtype:get_member_index("K") == 3)
  dtype:get_member_value(0, value)
  assert(value[0] == 1)
  dtype:get_member_value(1, value)
  assert(value[0] == 3)
  dtype:get_member_value(2, value)
  assert(value[0] == 11)
  dtype:get_member_value(3, value)
  assert(value[0] == 19)
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.H)) == "H")
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.Li)) == "Li")
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.Na)) == "Na")
  assert(dtype:enum_nameof(ffi.new("int8_t[1]", species.K)) == "K")
  dtype:enum_valueof("H", value)
  assert(value[0] == 1)
  dtype:enum_valueof("Li", value)
  assert(value[0] == 3)
  dtype:enum_valueof("Na", value)
  assert(value[0] == 11)
  dtype:enum_valueof("K", value)
  assert(value[0] == 19)
  dtype:close()
end

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
  space:close()
  local buf = ffi.new("int8_t[3][2]", {{11, 1}, {19, 1}, {19, 3}})
  dset:write(buf, dtype)
  dtype:close()
  dset:close()
  file:close()
end

do
  local species = {H = 0, Li = 1, Na = 2, K = 3}
  local file = hdf5.open_file(path)
  local dset = file:open_dataset("species")
  local dtype = hdf5.int:enum_create()
  dtype:enum_insert("H", ffi.new("int[1]", species.H))
  dtype:enum_insert("Li", ffi.new("int[1]", species.Li))
  dtype:enum_insert("Na", ffi.new("int[1]", species.Na))
  dtype:enum_insert("K", ffi.new("int[1]", species.K))
  local space = hdf5.create_simple_space({3, 2})
  local buf = ffi.new("int[3][2]")
  dset:read(buf, dtype, space)
  assert(buf[0][0] == species.Na)
  assert(buf[0][1] == species.H)
  assert(buf[1][0] == species.K)
  assert(buf[1][1] == species.H)
  assert(buf[2][0] == species.K)
  assert(buf[2][1] == species.Li)
  dtype:close()
  space:close()
  dset:close()
  file:close()
end

do
  local ctype = ffi.typeof[[struct {
    int count;
    double mean;
  }]]
  local memtype = hdf5.create_type("compound", ffi.sizeof(ctype))
  assert(memtype:get_class() == "compound")
  assert(memtype:get_size() == ffi.sizeof(ctype))
  assert(memtype:get_nmembers() == 0)
  memtype:insert("mean", ffi.offsetof(ctype, "mean"), hdf5.double)
  memtype:insert("count", ffi.offsetof(ctype, "count"), hdf5.int)
  assert(memtype:get_size() == ffi.sizeof(ctype))
  assert(memtype:get_nmembers() == 2)
  assert(memtype:get_member_class(0) == "float")
  assert(memtype:get_member_class(1) == "integer")
  assert(memtype:get_member_name(0) == "mean")
  assert(memtype:get_member_name(1) == "count")
  assert(memtype:get_member_index("mean") == 0)
  assert(memtype:get_member_index("count") == 1)
  assert(memtype:get_member_offset(0) == ffi.offsetof(ctype, "mean"), hdf5.double)
  assert(memtype:get_member_offset(1) == ffi.offsetof(ctype, "count"), hdf5.int)
  local dtype = memtype:get_member_type(0)
  assert(dtype:equal(hdf5.double))
  dtype:close()
  local dtype = memtype:get_member_type(1)
  assert(dtype:equal(hdf5.int))
  dtype:close()
  local filetype = memtype:copy()
  filetype:pack()
  assert(filetype:get_size() == ffi.sizeof[[struct {
    int count;
    double mean;
  } __attribute__((packed))]])
  local space = hdf5.create_space("scalar")
  do
    local file = hdf5.create_file(path)
    local dset = file:create_dataset("accum", filetype, space)
    local buf = ctype(123456789, math.pi)
    dset:write(buf, memtype, space)
    dset:close()
    file:close()
  end
  do
    local file = hdf5.open_file(path)
    local dset = file:open_dataset("accum")
    local buf = ctype()
    dset:read(buf, memtype)
    dset:close()
    file:close()
    assert(buf.count == 123456789)
    assert(buf.mean == math.pi)
  end
  space:close()
  memtype:close()
  filetype:close()
end

do
  local N = 100
  local dtype = hdf5.double:array_create({N, 3})
  assert(dtype:get_size() == N * 3 * ffi.sizeof("double"))
  assert(dtype:get_array_ndims() == 2)
  local dims = dtype:get_array_dims()
  assert(#dims == 2)
  assert(dims[1] == N)
  assert(dims[2] == 3)
  local space = hdf5.create_space("scalar")
  do
    local points = ffi.new("struct { double x, y, z; }[?]", N)
    math.randomseed(42)
    for i = 0, N - 1 do
      points[i].x = math.random()
      points[i].y = math.random()
      points[i].z = math.random()
    end
    local file = hdf5.create_file(path)
    local dset = file:create_dataset("points", dtype, space)
    dset:write(points, dtype, space)
    dset:close()
    file:close()
  end
  do
    local file = hdf5.open_file(path)
    local dset = file:open_dataset("points")
    local points = ffi.new("struct { double x, y, z; }[?]", N)
    dset:read(points, dtype, space)
    dset:close()
    file:close()
    math.randomseed(42)
    for i = 0, N - 1 do
      assert(points[i].x == math.random())
      assert(points[i].y == math.random())
      assert(points[i].z == math.random())
    end
  end
  space:close()
  dtype:close()
end

os.remove(path)
