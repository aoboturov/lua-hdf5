------------------------------------------------------------------------------
-- Test MPI-IO.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

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
collectgarbage()

do
  local dxpl = hdf5.create_plist("dataset_xfer")
  dxpl:set_dxpl_mpio("independent")
  assert(dxpl:get_dxpl_mpio() == "independent")
  dxpl:set_dxpl_mpio("collective")
  assert(dxpl:get_dxpl_mpio() == "collective")
end
collectgarbage()

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
end
collectgarbage()

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
end
collectgarbage()

os.remove(path)
