------------------------------------------------------------------------------
-- Test files.
-- Copyright © 2013–2014 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

require("strict")

pcall(require, "luacov")

local hdf5 = require("hdf5")
local ffi = require("ffi")

local path = "test_file.h5"

for i = 1, 3 do
  local file = hdf5.create_file(path, "trunc")
  collectgarbage()
  assert(file:get_object_type() == "file")
  assert(file:get_object_name() == "/")
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdwr")
  assert(file:get_vfd_handle() ~= nil)
  file:close()
  assert(file:get_object_type() == nil)
end

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
  assert(file:get_vfd_handle() ~= nil)
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
  assert(file:get_vfd_handle() ~= nil)
end
collectgarbage()

do
  local file = hdf5.open_file(path)
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdonly")
  assert(file:get_vfd_handle() ~= nil)
end
collectgarbage()

do
  local file = hdf5.open_file(path, "rdonly")
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdonly")
  assert(file:get_vfd_handle() ~= nil)
end
collectgarbage()

do
  local file = hdf5.open_file(path, "rdwr")
  assert(file:get_name() == path)
  assert(file:get_intent() == "rdwr")
  assert(file:get_vfd_handle() ~= nil)
  file:flush()
end
collectgarbage()

do
  local file = hdf5.open_file(path)
  local fapl = file:get_file_access_plist()
  file:close()
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
  file:close()
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
  file:close()
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
  file:close()
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
  file:close()
  local super, freelist, stab, shhdr = fcpl:get_version()
  assert(super == 2)
  assert(freelist == 0)
  assert(stab == 0)
  assert(shhdr == 0)
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_core(2 ^ 20, true)
  local file = hdf5.create_file(path, "trunc", nil, fapl)
  do
    local fapl = file:get_file_access_plist()
    local increment, backing_store = fapl:get_fapl_core()
    assert(increment == 1048576)
    assert(backing_store == true)
  end
  file:flush()
  do
    local N = 10000
    local dataspace = hdf5.create_simple_space({N})
    local dataset = file:create_dataset("position", hdf5.double, dataspace)
    local buf = ffi.new("double[?]", N)
    for i = 0, N - 1 do buf[i] = math.random() end
    dataset:write(buf, hdf5.double, dataspace)
  end
  file:close()
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_core(2 ^ 21, true)
  local file = hdf5.open_file(path, "rdwr", fapl)
  do
    local fapl = file:get_file_access_plist()
    local increment, backing_store = fapl:get_fapl_core()
    assert(increment == 2097152)
    assert(backing_store == true)
  end
  file:copy_object("position", file, "velocity")
  file:close()
end
collectgarbage()

do
  local fapl = hdf5.create_plist("file_access")
  fapl:set_fapl_core(2 ^ 19, false)
  local file = hdf5.create_file(path, "trunc", nil, fapl)
  do
    local fapl = file:get_file_access_plist()
    local increment, backing_store = fapl:get_fapl_core()
    assert(increment == 524288)
    assert(backing_store == false)
  end
  file:close()
end
collectgarbage()

os.remove(path)
