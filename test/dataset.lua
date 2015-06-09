------------------------------------------------------------------------------
-- Test datasets.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi  = require("ffi")
local test = require("test")

local path = "test_dataset.h5"

do
  local file = hdf5.create_file(path)
  local file_type = hdf5.float
  local file_space = hdf5.create_simple_space({2, 4, 3})
  local dset = file:create_dataset("position", file_type, file_space)
  local dtype = dset:get_type()
  assert(dtype:equal(file_type))
  dtype:close()
  local space = dset:get_space()
  assert(space:extent_equal(file_space))
  space:close()
  file_space:close()
  local dcpl = dset:get_dataset_create_plist()
  assert(dcpl:get_layout() == "contiguous")
  dcpl:close()
  if test.require_version(1, 8, 3) then
    local dapl = dset:get_dataset_access_plist()
    dapl:close()
  end
  dset:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local file_type = hdf5.float
  local file_space = hdf5.create_simple_space({2, 4, 3})
  local dcpl = hdf5.create_plist("dataset_create")
  dcpl:set_layout("compact")
  assert(dcpl:get_layout() == "compact")
  local dset = file:create_anon_dataset(file_type, file_space, dcpl)
  file_space:close()
  dcpl:close()
  local dcpl = dset:get_dataset_create_plist()
  assert(dcpl:get_layout() == "compact")
  dcpl:close()
  assert(dset:get_object_name() == nil)
  file:link_object(dset, "position")
  assert(dset:get_object_name() == "/position")
  dset:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local dset = file:open_dataset("position")
  local file_type = hdf5.float
  local file_space = hdf5.create_simple_space({2, 4, 3})
  local dtype = dset:get_type()
  assert(dtype:equal(file_type))
  dtype:close()
  local space = dset:get_space()
  assert(space:extent_equal(file_space))
  space:close()
  file_space:close()
  dset:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local file_type = hdf5.float
  local file_space = hdf5.create_simple_space({100, 0}, {100, nil})
  local dcpl = hdf5.create_plist("dataset_create")
  dcpl:set_chunk({100, 10})
  assert(dcpl:get_layout() == "chunked")
  local chunk = dcpl:get_chunk()
  assert(#chunk == 2)
  assert(chunk[1] == 100)
  assert(chunk[2] == 10)
  local dset = file:create_dataset("position", file_type, file_space, nil, dcpl)
  file_space:close()
  dcpl:close()
  dset:set_extent({100, 3})
  local file_space = hdf5.create_simple_space({100, 3}, {100, nil})
  local space = dset:get_space()
  assert(space:extent_equal(file_space))
  space:close()
  file_space:close()
  dset:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local file_type = hdf5.float
  local file_space = hdf5.create_simple_space({5, 0}, {5, nil})
  local dcpl = hdf5.create_plist("dataset_create")
  dcpl:set_chunk({5, 10})
  dcpl:set_shuffle()
  dcpl:set_deflate(6)
  local dset = file:create_dataset("position", file_type, file_space, nil, dcpl)
  file_space:close()
  dcpl:close()
  dset:set_extent({5, 123})
  local file_space = hdf5.create_simple_space({5, 123}, {5, nil})
  local space = dset:get_space()
  assert(space:extent_equal(file_space))
  space:close()
  file_space:close()
  dset:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local file_type = hdf5.int64
  local file_space = hdf5.create_space("scalar")
  local dset = file:create_dataset("id", file_type, file_space)
  file_space:close()
  dset:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local dset = file:open_dataset("id")
  local dcpl = dset:get_dataset_create_plist()
  assert(dcpl:fill_value_defined() == "default")
  do
    local buf = ffi.new("int[1]")
    dcpl:get_fill_value(buf, hdf5.int)
    assert(buf[0] == 0)
  end
  dcpl:close()
  do
    local buf = ffi.new("int[1]")
    dset:read(buf, hdf5.int)
    assert(buf[0] == 0)
  end
  dset:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local file_type = hdf5.int64
  local file_space = hdf5.create_space("scalar")
  local dcpl = hdf5.create_plist("dataset_create")
  assert(dcpl:fill_value_defined() == "default")
  dcpl:set_fill_value(nil)
  assert(dcpl:fill_value_defined() == "undefined")
  dcpl:set_fill_value(ffi.new("short[1]", -1), hdf5.short)
  assert(dcpl:fill_value_defined() == "user_defined")
  local dset = file:create_dataset("id", file_type, file_space, nil, dcpl)
  file_space:close()
  dcpl:close()
  dset:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local dset = file:open_dataset("id")
  local dcpl = dset:get_dataset_create_plist()
  assert(dcpl:fill_value_defined() == "user_defined")
  do
    local buf = ffi.new("int[1]")
    dcpl:get_fill_value(buf, hdf5.int)
    assert(buf[0] == -1)
  end
  dcpl:close()
  do
    local buf = ffi.new("int[1]")
    dset:read(buf, hdf5.int)
    assert(buf[0] == -1)
  end
  dset:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local file_type = hdf5.float
  local file_space = hdf5.create_simple_space({2, 2})
  local dset = file:create_dataset("position", file_type, file_space)
  do
    local buf = ffi.new("float[4]", 42, 43, 44, 45)
    local mem_type = hdf5.float
    dset:write(buf, mem_type)
  end
  do
    local buf = ffi.new("float[4]")
    local mem_type = hdf5.float
    dset:read(buf, mem_type)
    assert(buf[0] == 42)
    assert(buf[1] == 43)
    assert(buf[2] == 44)
    assert(buf[3] == 45)
  end
  do
    local buf = ffi.new("double[4]", 2, 3, 4, 5)
    local mem_type = hdf5.double
    dset:write(buf, mem_type)
  end
  do
    local buf = ffi.new("double[4]")
    local mem_type = hdf5.double
    dset:read(buf, mem_type)
    assert(buf[0] == 2)
    assert(buf[1] == 3)
    assert(buf[2] == 4)
    assert(buf[3] == 5)
  end
  do
    local buf = ffi.new("double[4]", 2, 3, 4, 5)
    local mem_type = hdf5.double
    local mem_space = hdf5.create_simple_space({4})
    dset:write(buf, mem_type, mem_space)
    mem_space:close()
  end
  do
    local buf = ffi.new("double[4]")
    local mem_type = hdf5.double
    local mem_space = hdf5.create_simple_space({4})
    dset:read(buf, mem_type, mem_space)
    mem_space:close()
    assert(buf[0] == 2)
    assert(buf[1] == 3)
    assert(buf[2] == 4)
    assert(buf[3] == 5)
  end
  do
    local buf = ffi.new("float[2]", 98, 99)
    local mem_type = hdf5.float
    local mem_space = hdf5.create_simple_space({2})
    file_space:select_hyperslab("set", {0, 0}, {1, 1}, {2, 1}, {1, 1})
    dset:write(buf, mem_type, mem_space, file_space)
    mem_space:close()
  end
  do
    local buf = ffi.new("float[2]")
    local mem_type = hdf5.float
    local mem_space = hdf5.create_simple_space({2})
    file_space:select_hyperslab("set", {0, 0}, nil, {1, 2})
    dset:read(buf, mem_type, mem_space, file_space)
    assert(buf[0] == 98)
    assert(buf[1] == 3)
    file_space:offset_simple({1, 0})
    dset:read(buf, mem_type, mem_space, file_space)
    assert(buf[0] == 99)
    assert(buf[1] == 5)
    mem_space:close()
  end
  file_space:close()
  dset:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local dtype = hdf5.c_s1:copy()
  local space = hdf5.create_simple_space({3})
  dtype:set_size("variable")
  local dset = file:create_dataset("boundary", dtype, space)
  local buf = ffi.new("const char *[3]", {"periodic", "none", "periodic"})
  dset:write(buf, dtype, space)
  dtype:close()
  space:close()
  dset:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local dset = file:open_dataset("boundary")
  local buf = ffi.new("const char *[3]")
  local dtype = hdf5.c_s1:copy()
  dtype:set_size("variable")
  local space = hdf5.create_simple_space({3})
  dset:read(buf, dtype, space)
  dset:close()
  assert(ffi.string(buf[0]) == "periodic")
  assert(ffi.string(buf[1]) == "none")
  assert(ffi.string(buf[2]) == "periodic")
  hdf5.vlen_reclaim(buf, dtype, space)
  dtype:close()
  space:close()
  file:close()
end

os.remove(path)
