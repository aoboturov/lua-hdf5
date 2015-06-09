------------------------------------------------------------------------------
-- Test references.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi  = require("ffi")

local path = "test_reference.h5"

do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  group:close()
  local ref = ffi.new("hobj_ref_t[1]")
  file:create_reference("particles", ref, "object")
  assert(file:get_reference_name(ref, "object") == "/particles")
  assert(file:get_reference_type(ref, "object") == "group")
  local dtype = hdf5.ref_obj
  local space = hdf5.create_space("scalar")
  local dset = file:create_dataset("particles_ref", dtype, space)
  space:close()
  dset:write(ref, dtype)
  local ref = ffi.new("hobj_ref_t[1]")
  dset:create_reference(".", ref, "object")
  dset:close()
  assert(file:get_reference_name(ref, "object") == "/particles_ref")
  assert(file:get_reference_type(ref, "object") == "dataset")
  local dtype = dtype:copy()
  dtype:commit(file, "unit")
  local ref = ffi.new("hobj_ref_t[1]")
  dtype:create_reference(".", ref, "object")
  dtype:close()
  assert(file:get_reference_name(ref, "object") == "/unit")
  assert(file:get_reference_type(ref, "object") == "named_datatype")
  file:close()
end

do
  local file = hdf5.open_file(path)
  local dset = file:open_dataset("particles_ref")
  local dtype = hdf5.ref_obj
  local ref = ffi.new("hobj_ref_t[1]")
  dset:read(ref, dtype)
  dset:close()
  assert(file:get_reference_name(ref, "object") == "/particles")
  assert(file:get_reference_type(ref, "object") == "group")
  local group = file:dereference(ref, "object")
  assert(group:get_object_name() == "/particles")
  group:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  local ref = ffi.new("hdset_reg_ref_t[1]")
  do
    local dtype = hdf5.double
    local file_space = hdf5.create_simple_space({2, 10, 3})
    local dset = group:create_dataset("position", dtype, file_space)
    file_space:select_hyperslab("set", {1, 5, 0}, nil, {1, 1, 3})
    local mem_space = hdf5.create_simple_space({3})
    local buf = ffi.new("double[3]", 42, 43, 44)
    dset:write(buf, dtype, mem_space, file_space)
    mem_space:close()
    dset:close()
    group:create_reference("position", ref, "dataset_region", file_space)
    assert(group:get_reference_name(ref, "dataset_region") == "/particles/position")
    assert(group:get_reference_type(ref, "dataset_region") == "dataset")
    file_space:close()
  end
  do
    local dtype = hdf5.ref_dsetreg
    local space = hdf5.create_space("scalar")
    local dset = group:create_dataset("position_ref", dtype, space)
    space:close()
    dset:write(ref, dtype)
    dset:close()
  end
  group:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local ref = ffi.new("hdset_reg_ref_t[1]")
  do
    local dset = file:open_dataset("particles/position_ref")
    local dtype = hdf5.ref_dsetreg
    local mem_space = hdf5.create_space("scalar")
    dset:read(ref, dtype, mem_space)
    mem_space:close()
    dset:close()
    assert(file:get_reference_name(ref, "dataset_region") == "/particles/position")
    assert(file:get_reference_type(ref, "dataset_region") == "dataset")
  end
  do
    local dset = file:dereference(ref, "dataset_region")
    assert(dset:get_object_name() == "/particles/position")
    local file_space = dset:get_reference_region(ref, "dataset_region")
    local dtype = hdf5.double
    local mem_space = hdf5.create_simple_space({3})
    local buf = ffi.new("double[3]")
    dset:read(buf, dtype, mem_space, file_space)
    mem_space:close()
    file_space:close()
    dset:close()
    assert(buf[0] == 42)
    assert(buf[1] == 43)
    assert(buf[2] == 44)
  end
  file:close()
end

os.remove(path)
