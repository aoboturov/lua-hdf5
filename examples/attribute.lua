#!/usr/bin/env luajit
------------------------------------------------------------------------------
-- Write and read string attribute.
-- Copyright © 2014 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

local hdf5 = require("hdf5")
local ffi = require("ffi")

local species = {"H2O", "C8H10N4O2", "C6H12O6"}

do
  local f = hdf5.create_file("attribute.h5")
  local group = f:create_group("molecules")
  local dataspace = hdf5.create_simple_space({#species})
  local datatype = hdf5.c_s1:copy()
  datatype:set_size(100)
  local attr = group:create_attribute("species", datatype, dataspace)
  attr:write(ffi.new("char[?][100]", #species, species), datatype)
  f:close()
end

do
  local f = hdf5.open_file("attribute.h5")
  local group = f:open_group("molecules")
  local attr = group:open_attribute("species")
  local filespace = attr:get_space()
  local dims = filespace:get_simple_extent_dims()
  local N = dims[1]
  assert(N == #species)
  local buf = ffi.new("char[?][50]", N)
  local memspace = hdf5.create_simple_space({N})
  local memtype = hdf5.c_s1:copy()
  memtype:set_size(50)
  attr:read(buf, memtype, memspace)
  f:close()
  for i = 0, N - 1 do
    assert(ffi.string(buf[i]) == species[i + 1])
  end
end
