------------------------------------------------------------------------------
-- Test objects.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")

local function require_version(maj, min, rel)
  local maj_ver, min_ver, rel_ver = hdf5.get_libversion()
  return maj_ver > maj or maj_ver == maj and (min_ver > min or min_ver == min and rel_ver >= rel)
end

local path = "test_object.h5"

do
  local file = hdf5.create_file(path)
  local group = file:open_object("/")
  assert(group:get_object_name() == "/")
  assert(group:get_object_type() == "group")
  local info = file:get_object_info()
  assert(info:get_type() == "group")
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  assert(file:get_object_name() == "/")
  assert(file:get_object_type() == "file")
  local info = file:get_object_info()
  assert(info:get_type() == "group")
end
collectgarbage()

if require_version(1, 8, 5) then
  local file = hdf5.create_file(path)
  local group = file:create_group("particles")
  assert(file:exists_object("particles") == true)
  file:create_soft_link("particles", "molecules")
  assert(file:exists_object("molecules") == true)
  file:delete_link("particles")
  assert(file:exists_object("molecules") == false)
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_libver_bounds("18", "latest")
  local file = hdf5.create_file(path, nil, nil, fapl)
  local info = file:get_object_info()
  assert(info:get_atime() > 0)
  assert(info:get_btime() > 0)
  assert(info:get_ctime() > 0)
  assert(info:get_mtime() > 0)
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  local info1 = file:get_object_info()
  file:link_object(file, "root")
  local info2 = file:get_object_info()
  assert(info1:get_num_links() == 1)
  assert(info2:get_num_links() == 2)
end
collectgarbage()

do
  local file = hdf5.create_file(path)
  local info1 = file:get_object_info()
  local space = hdf5.create_space("null")
  local attr = file:create_attribute("unit", hdf5.int, space)
  local info2 = attr:get_object_info()
  assert(info1:get_num_attrs() == 0)
  assert(info2:get_num_attrs() == 1)
end
collectgarbage()

os.remove(path)
