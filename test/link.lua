------------------------------------------------------------------------------
-- Test links.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi  = require("ffi")

local path = "test_link.h5"

do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  assert(file:exists_link("particles") == true)
  assert(file:exists_link("molecules") == false)
  assert(group:get_object_info():get_num_links() == 1)
  file:create_hard_link(nil, "particles", "molecules")
  assert(file:exists_link("particles") == true)
  assert(file:exists_link("molecules") == true)
  assert(group:get_object_info():get_num_links() == 2)
  file:delete_link("particles")
  assert(file:exists_link("particles") == false)
  assert(file:exists_link("molecules") == true)
  assert(group:get_object_info():get_num_links() == 1)
  group:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  assert(file:exists_link("particles") == true)
  assert(file:exists_link("molecules") == false)
  assert(group:get_object_info():get_num_links() == 1)
  file:create_soft_link("particles", "molecules")
  assert(file:exists_link("particles") == true)
  assert(file:exists_link("molecules") == true)
  assert(group:get_object_info():get_num_links() == 1)
  file:delete_link("particles")
  assert(file:exists_link("particles") == false)
  assert(file:exists_link("molecules") == true)
  assert(group:get_object_info():get_num_links() == 0)
  group:close()
  file:close()
end

do
  local lcpl = hdf5.create_plist("link_create")
  assert(lcpl:get_create_intermediate_group() == true)
  lcpl:set_create_intermediate_group(false)
  assert(lcpl:get_create_intermediate_group() == false)
  lcpl:close()
end

do
  local file = hdf5.create_file(path)
  local group = file:create_group("particles/dimer/position")
  group:close()
  file:close()
end

do
  local file = hdf5.create_file(path)
  local group1 = file:create_group("B")
  group1:close()
  local group2 = file:create_group("A")
  group2:close()
  local group3 = file:create_group("C")
  group3:close()

  local link_name = {}
  for i = 0, 2 do link_name[i + 1] = file:get_link_name_by_idx(".", i) end
  table.sort(link_name)
  assert(link_name[1] == "A")
  assert(link_name[2] == "B")
  assert(link_name[3] == "C")

  file:close()
end

do
  local file = hdf5.create_file(path)
  local group1 = file:create_group("B")
  group1:close()
  local group2 = file:create_group("A")
  group2:close()
  local group3 = file:create_group("C")
  group3:close()

  assert(file:get_link_name_by_idx(".", 0, "name", "inc") == "A")
  assert(file:get_link_name_by_idx(".", 1, "name", "inc") == "B")
  assert(file:get_link_name_by_idx(".", 2, "name", "inc") == "C")

  assert(file:get_link_name_by_idx(".", 0, "name", "dec") == "C")
  assert(file:get_link_name_by_idx(".", 1, "name", "dec") == "B")
  assert(file:get_link_name_by_idx(".", 2, "name", "dec") == "A")

  file:close()
end

do
  local fcpl = hdf5.create_plist("file_create")
  fcpl:set_link_creation_order("tracked")
  local file = hdf5.create_file(path, nil, fcpl)
  fcpl:close()
  local group1 = file:create_group("B")
  group1:close()
  local group2 = file:create_group("A")
  group2:close()
  local group3 = file:create_group("C")
  group3:close()

  assert(file:get_link_name_by_idx(".", 0, "crt_order", "inc") == "B")
  assert(file:get_link_name_by_idx(".", 1, "crt_order", "inc") == "A")
  assert(file:get_link_name_by_idx(".", 2, "crt_order", "inc") == "C")

  assert(file:get_link_name_by_idx(".", 0, "crt_order", "dec") == "C")
  assert(file:get_link_name_by_idx(".", 1, "crt_order", "dec") == "A")
  assert(file:get_link_name_by_idx(".", 2, "crt_order", "dec") == "B")

  file:close()
end

os.remove(path)
