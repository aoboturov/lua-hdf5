------------------------------------------------------------------------------
-- Test links.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
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
end
collectgarbage()

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
end
collectgarbage()

do
  local lcpl = hdf5.create_plist("link_create")
  assert(lcpl:get_create_intermediate_group() == true)
  lcpl:set_create_intermediate_group(false)
  assert(lcpl:get_create_intermediate_group() == false)
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  file:create_group("particles/dimer/position")
end
collectgarbage()

os.remove(path)
