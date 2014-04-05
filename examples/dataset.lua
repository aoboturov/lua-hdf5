#!/usr/bin/env luajit
------------------------------------------------------------------------------
-- Write and read dataset.
-- Copyright © 2014 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

local hdf5 = require("hdf5")
local ffi = require("ffi")

do
  local N = 1000
  local pos = ffi.new("struct { double x, y, z; }[?]", N)
  math.randomseed(42)
  for i = 0, N - 1 do
    pos[i].x = math.random()
    pos[i].y = math.random()
    pos[i].z = math.random()
  end
  local f = hdf5.create_file("dataset.h5")
  local datatype = hdf5.double
  local dataspace = hdf5.create_simple_space({N, 3})
  local dataset = f:create_dataset("particles/solvent/position", datatype, dataspace)
  dataset:write(pos, datatype, dataspace)
  f:close()
end

do
  local f = hdf5.open_file("dataset.h5")
  local dataset = f:open_dataset("particles/solvent/position")
  local filespace = dataset:get_space()
  local dims = filespace:get_simple_extent_dims()
  local N, D = dims[1], dims[2]
  assert(N == 1000)
  assert(D == 3)
  local pos = ffi.new("struct { float x, y, z; }[?]", N)
  local memtype = hdf5.float
  local memspace = hdf5.create_simple_space({N, 3})
  dataset:read(pos, memtype, memspace)
  f:close()
  math.randomseed(42)
  for i = 0, N - 1 do
    assert(math.abs(pos[i].x - math.random()) < 1e-7)
    assert(math.abs(pos[i].y - math.random()) < 1e-7)
    assert(math.abs(pos[i].z - math.random()) < 1e-7)
  end
end
