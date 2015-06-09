------------------------------------------------------------------------------
-- Test groups.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")

local path = "test_group.h5"

for i = 1, 3 do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  assert(group:get_object_type() == "group")
  assert(group:get_object_name() == "/particles")
  local subgroup = group:create_group("solvent")
  group:close()
  assert(subgroup:get_object_type() == "group")
  assert(subgroup:get_object_name() == "/particles/solvent")
  subgroup:close()
  file:close()
end

for i = 1, 3 do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  assert(file:get_object_type() == "file")
  assert(group:get_object_type() == "group")
  group:close()
  local group2 = file:create_group("observables")
  assert(file:get_object_type() == "file")
  assert(group:get_object_type() == nil)
  assert(group2:get_object_type() == "group")
  group2:close()
  assert(file:get_object_type() == "file")
  assert(group:get_object_type() == nil)
  assert(group2:get_object_type() == nil)
  file:close()
  assert(file:get_object_type() == nil)
  assert(group:get_object_type() == nil)
  assert(group2:get_object_type() == nil)
end

do
  local file = hdf5.create_file(path)
  local group = file:create_anon_group()
  local subgroup = group:create_group("solvent")
  assert(group:get_object_name() == nil)
  assert(subgroup:get_object_name() == nil)
  file:link_object(group, "particles")
  assert(group:get_object_name() == "/particles")
  assert(subgroup:get_object_name() == "/particles/solvent")
  subgroup:close()
  group:close()
  file:close()
end

do
  local file = hdf5.open_file(path)
  local subgroup = file:open_group("particles/solvent")
  assert(subgroup:get_object_name() == "/particles/solvent")
  subgroup:close()
  file:close()
end

do
  local gcpl = hdf5.create_plist("group_create")
  local flags = gcpl:get_link_creation_order()
  gcpl:close()
  assert(flags.tracked == nil)
  assert(flags.indexed == nil)
end

do
  local gcpl = hdf5.create_plist("group_create")
  gcpl:set_link_creation_order("tracked")
  local flags = gcpl:get_link_creation_order()
  gcpl:close()
  assert(flags.tracked == true)
  assert(flags.indexed == nil)
end

do
  local gcpl = hdf5.create_plist("group_create")
  gcpl:set_link_creation_order({"tracked", "indexed"})
  local flags = gcpl:get_link_creation_order()
  gcpl:close()
  assert(flags.tracked == true)
  assert(flags.indexed == true)
end

do
  local gcpl = hdf5.create_plist("group_create")
  local flags = gcpl:get_attr_creation_order()
  gcpl:close()
  assert(flags.tracked == nil)
  assert(flags.indexed == nil)
end

do
  local gcpl = hdf5.create_plist("group_create")
  gcpl:set_attr_creation_order("tracked")
  local flags = gcpl:get_attr_creation_order()
  gcpl:close()
  assert(flags.tracked == true)
  assert(flags.indexed == nil)
end

do
  local gcpl = hdf5.create_plist("group_create")
  gcpl:set_attr_creation_order({"tracked", "indexed"})
  local flags = gcpl:get_attr_creation_order()
  gcpl:close()
  assert(flags.tracked == true)
  assert(flags.indexed == true)
end

do
  local file = hdf5.create_file(path)

  local info1 = file:get_group_info()
  local group1 = file:create_group("particles")
  group1:close()
  local info2 = file:get_group_info()
  local group2 = file:create_group("observables")
  group2:close()
  local info3 = file:get_group_info()
  file:close()

  assert(info1:get_num_links() == 0)
  assert(info2:get_num_links() == 1)
  assert(info3:get_num_links() == 2)
end

do
  local fcpl = hdf5.create_plist("file_create")
  fcpl:set_link_creation_order("tracked")
  local file = hdf5.create_file(path, nil, fcpl)
  fcpl:close()

  local info1 = file:get_group_info()
  local group1 = file:create_group("particles")
  group1:close()
  local info2 = file:get_group_info()
  local group2 = file:create_group("observables")
  group2:close()
  local info3 = file:get_group_info()
  file:close()

  assert(info1:get_max_corder() == 0)
  assert(info2:get_max_corder() == 1)
  assert(info3:get_max_corder() == 2)
end

do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  local info = group:get_group_info()
  group:close()
  assert(info:get_mounted() == false)
  assert(info:get_storage_type() == "compact")
  file:close()
end

os.remove(path)
