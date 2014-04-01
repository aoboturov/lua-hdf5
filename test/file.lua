------------------------------------------------------------------------------
-- Test files.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")

local path = "test_file.h5"

for i = 1, 3 do
  local file = hdf5.create_file(path, "trunc")
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdwr")
  assert(file:get_object_name() == "/")
  assert(file:get_object_type() == "file")
  file:close()
end
collectgarbage()

do
  local C = require("hdf5.C")
  assert(C.H5Eset_auto(C.H5E_DEFAULT, nil, nil) == 0)
  local status, err = pcall(hdf5.create_file, path, "excl")
  assert(C.H5Eset_auto(C.H5E_DEFAULT, C.H5Eprint, io.stderr) == 0)
  assert(status == false)
  assert(err == "unable to create file")
end

do
  os.remove(path)
  local file = hdf5.create_file(path, "excl")
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdwr")
end
collectgarbage()

do
  assert(hdf5.is_hdf5(path) == true)
  assert(hdf5.is_hdf5(arg[0]) == false)
end

do
  local file = hdf5.create_file(path)
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdwr")
end
collectgarbage()

do
  local file = hdf5.open_file(path)
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdonly")
end
collectgarbage()

do
  local file = hdf5.open_file(path, "rdonly")
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdonly")
end
collectgarbage()

do
  local file = hdf5.open_file(path, "rdwr")
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdwr")
  file:flush()
  file:flush("local")
  file:flush("global")
end
collectgarbage()

do
  local file = hdf5.open_file(path)
  local fapl = file:get_file_access_plist()
  local low, high = fapl:get_libver_bounds()
  assert(low == "latest")
  assert(high == "latest")
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  local low, high = fapl:get_libver_bounds()
  assert(low == "latest")
  assert(high == "latest")
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_libver_bounds("earliest", "18")
  local file = hdf5.create_file(path, nil, nil, fapl)
  local fapl = file:get_file_access_plist()
  local low, high = fapl:get_libver_bounds()
  assert(low == "earliest")
  assert(high == "latest")
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_libver_bounds("18", "latest")
  local file = hdf5.create_file(path, nil, nil, fapl)
  local fapl = file:get_file_access_plist()
  local low, high = fapl:get_libver_bounds()
  assert(low == "latest")
  assert(high == "latest")
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_libver_bounds("earliest", "latest")
  local file = hdf5.create_file(path, nil, nil, fapl)
  local fcpl = file:get_file_create_plist()
  local super, freelist, stab, shhdr = fcpl:get_version()
  assert(super == 0)
  assert(freelist == 0)
  assert(stab == 0)
  assert(shhdr == 0)
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_libver_bounds("18", "latest")
  local file = hdf5.create_file(path, nil, nil, fapl)
  local fcpl = file:get_file_create_plist()
  local super, freelist, stab, shhdr = fcpl:get_version()
  assert(super == 2)
  assert(freelist == 0)
  assert(stab == 0)
  assert(shhdr == 0)
end
collectgarbage()

os.remove(path)
