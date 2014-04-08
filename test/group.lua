------------------------------------------------------------------------------
-- Test groups.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")

local path = "test_group.h5"

for i = 1, 3 do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  collectgarbage()
  assert(group:get_object_type() == "group")
  assert(group:get_object_name() == "/particles")
  local subgroup = group:create_group("solvent")
  collectgarbage()
  assert(subgroup:get_object_type() == "group")
  assert(subgroup:get_object_name() == "/particles/solvent")
  file:close()
end

for i = 1, 3 do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  file:close()
  local file = hdf5.create_file(path)
  local subgroup = file:create_group("particles/solvent")
  assert(group:get_object_type() == nil)
  assert(subgroup:get_object_type() == "group")
  file:close()
end

do
  local group
  do
    local file = hdf5.create_file(path)
    group = file:create_group("particles")
  end
  collectgarbage()
  assert(group:get_object_type() == "group")
  assert(group:get_object_name() == "/particles")
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  local group = file:create_anon_group()
  local subgroup = group:create_group("solvent")
  assert(group:get_object_name() == nil)
  assert(subgroup:get_object_name() == nil)
  file:link_object(group, "particles")
  assert(group:get_object_name() == "/particles")
  assert(subgroup:get_object_name() == "/particles/solvent")
end
collectgarbage()

do
  local file = hdf5.open_file(path)
  local subgroup = file:open_group("particles/solvent")
  assert(subgroup:get_object_name() == "/particles/solvent")
end
collectgarbage()

os.remove(path)
