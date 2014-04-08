------------------------------------------------------------------------------
-- Test MPI-IO.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

require("strict")

local mpi = require("mpi")

local comm = assert(mpi.comm_world)

if comm:rank() == 0 then pcall(require, "luacov") end

local hdf5 = require("hdf5")
local ffi  = require("ffi")

local path = "test_mpi.h5"

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_mpio(mpi.comm_world)
  local info = mpi.create_info()
  fapl:set_fapl_mpio(mpi.comm_world, info)
end

do
  local dxpl = hdf5.create_plist("dataset_xfer")
  dxpl:set_dxpl_mpio("independent")
  assert(dxpl:get_dxpl_mpio() == "independent")
  dxpl:set_dxpl_mpio("collective")
  assert(dxpl:get_dxpl_mpio() == "collective")
end

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_mpio(comm)
  local file = hdf5.create_file(path, nil, nil, fapl)
  local filespace = hdf5.create_simple_space({comm:size()})
  local dtype = hdf5.double
  local dset = file:create_dataset("rank", dtype, filespace)
  local memspace = hdf5.create_simple_space({1})
  filespace:select_hyperslab("set", {comm:rank()}, nil, {1})
  local dxpl = hdf5.create_plist("dataset_xfer")
  dxpl:set_dxpl_mpio("collective")
  local buf = ffi.new("double[1]", comm:rank())
  dset:write(buf, dtype, memspace, filespace, dxpl)
  file:close()
end

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_mpio(comm)
  local file = hdf5.open_file(path, nil, fapl)
  local dset = file:open_dataset("rank")
  local dtype = hdf5.double
  local memspace = hdf5.create_simple_space({1})
  local filespace = dset:get_space()
  filespace:select_hyperslab("set", {comm:rank()}, nil, {1})
  local dxpl = hdf5.create_plist("dataset_xfer")
  dxpl:set_dxpl_mpio("collective")
  local buf = ffi.new("double[1]")
  dset:read(buf, dtype, memspace, filespace, dxpl)
  assert(buf[0] == comm:rank())
  file:close()
end


do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_mpio(comm)
  local file = hdf5.create_file(path, nil, nil, fapl)
  local dtype = hdf5.c_s1:copy()
  dtype:set_size("variable")
  local space = hdf5.create_simple_space({3})
  local attr = file:create_attribute("boundary", dtype, space)
  local boundary = {"periodic", "periodic", "none"}
  attr:write(ffi.new("const char *[3]", boundary), dtype)
  file:close()
end

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_mpio(comm)
  local file = hdf5.open_file(path, nil, fapl)
  local attr = file:open_attribute("boundary")
  local dtype = hdf5.c_s1:copy()
  dtype:set_size("variable")
  local buf = ffi.new("const char *[3]")
  attr:read(buf, dtype)
  assert(ffi.string(buf[0]) == "periodic")
  assert(ffi.string(buf[1]) == "periodic")
  assert(ffi.string(buf[2]) == "none")
  local space = attr:get_space()
  hdf5.vlen_reclaim(buf, dtype, space)
  file:close()
end

collectgarbage()

os.remove(path)
