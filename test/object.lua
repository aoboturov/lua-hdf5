------------------------------------------------------------------------------
-- Test objects.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local test = require("test")

local path = "test_object.h5"

do
  local file = hdf5.create_file(path)
  local group = file:open_object("/")
  assert(group:get_object_name() == "/")
  assert(group:get_object_type() == "group")
  group:close()
  local info = file:get_object_info()
  assert(info:get_type() == "group")
  file:close()
end

do
  local file = hdf5.create_file(path)
  assert(file:get_object_name() == "/")
  assert(file:get_object_type() == "file")
  local info = file:get_object_info()
  assert(info:get_type() == "group")
  file:close()
end

if test.require_version(1, 8, 5) then
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  group:close()
  assert(file:exists_object("particles") == true)
  file:create_soft_link("particles", "molecules")
  assert(file:exists_object("molecules") == true)
  file:delete_link("particles")
  assert(file:exists_object("molecules") == false)
  file:close()
end

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_libver_bounds("18", "latest")
  local file = hdf5.create_file(path, nil, nil, fapl)
  fapl:close()
  local info = file:get_object_info()
  assert(info:get_atime() > 0)
  assert(info:get_btime() > 0)
  assert(info:get_ctime() > 0)
  assert(info:get_mtime() > 0)
  file:close()
end

do
  local file = hdf5.create_file(path)
  local info1 = file:get_object_info()
  file:link_object(file, "root")
  local info2 = file:get_object_info()
  assert(info1:get_num_links() == 1)
  assert(info2:get_num_links() == 2)
  file:close()
end

do
  local file = hdf5.create_file(path)
  local info1 = file:get_object_info()
  local space = hdf5.create_space("null")
  local attr = file:create_attribute("unit", hdf5.int, space)
  local info2 = attr:get_object_info()
  assert(info1:get_num_attrs() == 0)
  assert(info2:get_num_attrs() == 1)
  attr:close()
  space:close()
  file:close()
end

do
  local ocpypl = hdf5.create_plist("object_copy")
  local flags = ocpypl:get_copy_object()
  ocpypl:close()
  assert(flags.shallow_hierarchy == nil)
  assert(flags.expand_soft_link == nil)
  assert(flags.expand_ext_link == nil)
  assert(flags.expand_reference == nil)
  assert(flags.without_attr == nil)
  assert(flags.merge_committed_dtype == nil)
end

do
  local ocpypl = hdf5.create_plist("object_copy")
  ocpypl:set_copy_object("shallow_hierarchy")
  local flags = ocpypl:get_copy_object()
  ocpypl:close()
  assert(flags.shallow_hierarchy == true)
  assert(flags.expand_soft_link == nil)
  assert(flags.expand_ext_link == nil)
  assert(flags.expand_reference == nil)
  assert(flags.without_attr == nil)
  assert(flags.merge_committed_dtype == nil)
end

do
  local ocpypl = hdf5.create_plist("object_copy")
  ocpypl:set_copy_object({"expand_soft_link", "expand_ext_link"})
  local flags = ocpypl:get_copy_object()
  ocpypl:close()
  assert(flags.shallow_hierarchy == nil)
  assert(flags.expand_soft_link == true)
  assert(flags.expand_ext_link == true)
  assert(flags.expand_reference == nil)
  assert(flags.without_attr == nil)
  assert(flags.merge_committed_dtype == nil)
end

do
  local ocpypl = hdf5.create_plist("object_copy")
  ocpypl:set_copy_object({"shallow_hierarchy", "expand_soft_link", "expand_ext_link", "expand_reference", "without_attr"})
  local flags = ocpypl:get_copy_object()
  ocpypl:close()
  assert(flags.shallow_hierarchy == true)
  assert(flags.expand_soft_link == true)
  assert(flags.expand_ext_link == true)
  assert(flags.expand_reference == true)
  assert(flags.without_attr == true)
  assert(flags.merge_committed_dtype == nil)
end


if test.require_version(1, 8, 9) then
  local ocpypl = hdf5.create_plist("object_copy")
  ocpypl:set_copy_object({"merge_committed_dtype"})
  local flags = ocpypl:get_copy_object()
  ocpypl:close()
  assert(flags.shallow_hierarchy == nil)
  assert(flags.expand_soft_link == nil)
  assert(flags.expand_ext_link == nil)
  assert(flags.expand_reference == nil)
  assert(flags.without_attr == nil)
  assert(flags.merge_committed_dtype == true)
end

do
  local file = hdf5.create_file(path)
  local group1 = file:create_group("particles/dimer/position")
  group1:close()
  local group2 = file:create_group("particles/solvent/position")
  group2:close()
  file:copy_object("particles", file, "molecules")
  assert(file:exists_link("molecules") == true)
  assert(file:exists_link("molecules/dimer") == true)
  assert(file:exists_link("molecules/dimer/position") == true)
  assert(file:exists_link("molecules/solvent/position") == true)
  file:close()
end

do
  local file = hdf5.create_file(path)
  local group1 = file:create_group("particles/dimer/position")
  group1:close()
  local group2 = file:create_group("particles/solvent/position")
  group2:close()
  local ocpypl = hdf5.create_plist("object_copy")
  ocpypl:set_copy_object("shallow_hierarchy")
  file:copy_object("particles", file, "molecules", ocpypl)
  ocpypl:close()
  assert(file:exists_link("molecules") == true)
  assert(file:exists_link("molecules/dimer") == true)
  assert(file:exists_link("molecules/dimer/position") == false)
  assert(file:exists_link("molecules/solvent/position") == false)
  file:close()
end

os.remove(path)
