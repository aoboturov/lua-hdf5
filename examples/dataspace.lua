#!/usr/bin/env luajit
------------------------------------------------------------------------------
-- Write and read dataset using hyperslab selection.
-- Copyright © 2014 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

local hdf5 = require("hdf5")
local ffi = require("ffi")

do
  local N = 4200
  local nstep = 100
  local file = hdf5.create_file("dataspace.h5")
  local dcpl = hdf5.create_plist("dataset_create")
  dcpl:set_chunk({1, 1000, 3})
  dcpl:set_deflate(6)
  local dataspace = hdf5.create_simple_space({0, N, 3}, {nil, N, 3})
  local dataset = file:create_dataset("particles/solvent/position/value", hdf5.double, dataspace, nil, dcpl)
  local filespace = hdf5.create_simple_space({nstep, N, 3})
  filespace:select_hyperslab("set", {0, 0, 0}, nil, {1, N, 3})
  local pos = ffi.new("struct { double x, y, z, w; }[?]", N)
  local memspace = hdf5.create_simple_space({N, 4})
  memspace:select_hyperslab("set", {0, 0}, nil, {N, 3})
  math.randomseed(42)
  for step = 1, nstep do
    dataset:set_extent({step, N, 3})
    for i = 0, N - 1 do
      pos[i].x = math.random()
      pos[i].y = math.random()
      pos[i].z = math.random()
    end
    dataset:write(pos, hdf5.double, memspace, filespace)
    filespace:offset_simple({step, 0, 0})
  end
  dataset:close()
  file:close()
end

do
  local file = hdf5.open_file("dataspace.h5")
  local dataset = file:open_dataset("particles/solvent/position/value")
  local filespace = dataset:get_space()
  local dims = filespace:get_simple_extent_dims()
  local nstep, N, D = dims[1], dims[2], dims[3]
  assert(nstep == 100)
  assert(N == 4200)
  assert(D == 3)
  filespace:select_hyperslab("set", {0, 0, 0}, nil, {1, N, 3})
  local pos = ffi.new("struct { double x, y, z, w; }[?]", N)
  local memspace = hdf5.create_simple_space({N, 4})
  memspace:select_hyperslab("set", {0, 0}, nil, {N, 3})
  math.randomseed(42)
  for step = 1, nstep do
    dataset:read(pos, hdf5.double, memspace, filespace)
    for i = 0, N - 1 do
      assert(pos[i].x == math.random())
      assert(pos[i].y == math.random())
      assert(pos[i].z == math.random())
    end
    filespace:offset_simple({step, 0, 0})
  end
  dataset:close()
  file:close()
end
