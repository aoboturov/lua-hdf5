------------------------------------------------------------------------------
-- HDF5 for Lua.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

local C   = require("hdf5.C")
local ffi = require("ffi")

-- Cache library functions.
local min = math.min

local _M = {}

-- C types.
local H5D_fill_value_t_1 = ffi.typeof("H5D_fill_value_t[1]")
local H5E_walk_t         = ffi.typeof("H5E_walk_t")
local H5F_libver_t_1     = ffi.typeof("H5F_libver_t[1]")
local H5O_info_t         = ffi.typeof("H5O_info_t")
local H5O_info_t_1       = ffi.typeof("H5O_info_t[1]")
local H5O_type_t_1       = ffi.typeof("H5O_type_t[1]")
local char_n             = ffi.typeof("char[?]")
local hsize_t_n          = ffi.typeof("hsize_t[?]")
local hssize_t_n         = ffi.typeof("hssize_t[?]")
local unsigned_1         = ffi.typeof("unsigned[1]")

-- Object identifiers.
local attribute_id = ffi.typeof("struct { hid_t id; }")
local dataset_id   = ffi.typeof("struct { hid_t id; }")
local dataspace_id = ffi.typeof("struct { hid_t id; }")
local datatype_id  = ffi.typeof("struct { hid_t id; }")
local file_id      = ffi.typeof("struct { hid_t id; }")
local group_id     = ffi.typeof("struct { hid_t id; }")
local plist_id     = ffi.typeof("struct { hid_t id; }")

-- Object methods.
local attribute = {}
local dataset   = {}
local dataspace = {}
local datatype  = {}
local file      = {}
local group     = {}
local location  = {}
local object    = {}
local plist     = {}

-- Initialise HDF5 constants.
assert(C.H5open() == 0)

-- Returns error message on top of error stack.
local function get_error()
  local desc
  local cb = H5E_walk_t(function(n, err_desc)
    if n == 0 then desc = ffi.string(err_desc[0].desc) end
    return 0
  end)
  assert(C.H5Ewalk(C.H5E_DEFAULT, C.H5E_WALK_DOWNWARD, cb, nil) == 0)
  cb:free()
  return desc
end

function _M.get_libversion()
  local maj, min, rel = unsigned_1(), unsigned_1(), unsigned_1()
  local err = C.H5get_libversion(maj, min, rel)
  if err < 0 then return error(get_error()) end
  return maj[0], min[0], rel[0]
end

do
  local flags = {
    trunc = C.H5F_ACC_TRUNC,
    excl  = C.H5F_ACC_EXCL,
  }

  function _M.create_file(name, flag, fcpl, fapl)
    if flag ~= nil then flag = flags[flag] else flag = C.H5F_ACC_TRUNC end
    if fcpl ~= nil then fcpl = fcpl.id else fcpl = C.H5P_DEFAULT end
    if fapl ~= nil then fapl = fapl.id else fapl = C.H5P_DEFAULT end
    local id = C.H5Fcreate(name, flag, fcpl, fapl)
    if id < 0 then return error(get_error()) end
    return file_id(id)
  end
end

do
  local flags = {
    rdonly = C.H5F_ACC_RDONLY,
    rdwr   = C.H5F_ACC_RDWR,
  }

  function _M.open_file(name, flag, fapl)
    if flag ~= nil then flag = flags[flag] else flag = C.H5F_ACC_RDONLY end
    if fapl ~= nil then fapl = fapl.id else fapl = C.H5P_DEFAULT end
    local id = C.H5Fopen(name, flag, fapl)
    if id < 0 then return error(get_error()) end
    return file_id(id)
  end
end

function _M.is_hdf5(name)
  local ret = C.H5Fis_hdf5(name)
  if ret < 0 then return error(get_error()) end
  return ret ~= 0
end

function file.get_file_create_plist(file)
  local id = C.H5Fget_create_plist(file.id)
  if id < 0 then return error(get_error()) end
  return plist_id(id)
end

function file.get_file_access_plist(file)
  local id = C.H5Fget_access_plist(file.id)
  if id < 0 then return error(get_error()) end
  return plist_id(id)
end

do
  function file.get_name(file)
    local ret = C.H5Fget_name(file.id, nil, 0)
    if ret < 0 then return error(get_error()) end
    if ret == 0 then return end
    local size = tonumber(ret)
    local name = char_n(size + 1)
    local ret = C.H5Fget_name(file.id, name, size + 1)
    if ret < 0 then return error(get_error()) end
    return ffi.string(name, size)
  end
end

do
  local flags = {
    [C.H5F_ACC_RDWR]   = "rdwr",
    [C.H5F_ACC_RDONLY] = "rdonly",
  }

  function file.get_intent(file)
    local flag = unsigned_1()
    local err = C.H5Fget_intent(file.id, flag)
    if err < 0 then return error(get_error()) end
    return flags[flag[0]]
  end
end

do
  local flags = {
    ["local"]  = C.H5F_SCOPE_LOCAL,
    ["global"] = C.H5F_SCOPE_GLOBAL,
  }

  function file.flush(file, scope)
    if scope ~= nil then scope = flags[scope] else scope = C.H5F_SCOPE_LOCAL end
    local err = C.H5Fflush(file.id, scope)
    if err < 0 then return error(get_error()) end
  end
end

do
  function object.get_file(object)
    local id = C.H5Iget_file_id(object.id)
    if id < 0 then return error(get_error()) end
    return file_id(id)
  end
end

function group.create_group(group, name, lcpl, gcpl, gapl)
  if lcpl ~= nil then lcpl = lcpl.id else lcpl = C.H5P_DEFAULT end
  if gcpl ~= nil then gcpl = gcpl.id else gcpl = C.H5P_DEFAULT end
  if gapl ~= nil then gapl = gapl.id else gapl = C.H5P_DEFAULT end
  local id = C.H5Gcreate(group.id, name, lcpl, gcpl, gapl)
  if id < 0 then return error(get_error()) end
  return group_id(id)
end

function group.create_anon_group(group, gcpl, gapl)
  if gcpl ~= nil then gcpl = gcpl.id else gcpl = C.H5P_DEFAULT end
  if gapl ~= nil then gapl = gapl.id else gapl = C.H5P_DEFAULT end
  local id = C.H5Gcreate_anon(group.id, gcpl, gapl)
  if id < 0 then return error(get_error()) end
  return group_id(id)
end

function group.open_group(group, name, gapl)
  if gapl ~= nil then gapl = gapl.id else gapl = C.H5P_DEFAULT end
  local id = C.H5Gopen(group.id, name, gapl)
  if id < 0 then return error(get_error()) end
  return group_id(id)
end

function group.create_dataset(group, name, dtype, space, lcpl, dcpl, dapl)
  if lcpl ~= nil then lcpl = lcpl.id else lcpl = C.H5P_DEFAULT end
  if dcpl ~= nil then dcpl = dcpl.id else dcpl = C.H5P_DEFAULT end
  if dapl ~= nil then dapl = dapl.id else dapl = C.H5P_DEFAULT end
  local id = C.H5Dcreate(group.id, name, dtype.id, space.id, lcpl, dcpl, dapl)
  if id < 0 then return error(get_error()) end
  return dataset_id(id)
end

function group.create_anon_dataset(group, dtype, space, dcpl, dapl)
  if dcpl ~= nil then dcpl = dcpl.id else dcpl = C.H5P_DEFAULT end
  if dapl ~= nil then dapl = dapl.id else dapl = C.H5P_DEFAULT end
  local id = C.H5Dcreate_anon(group.id, dtype.id, space.id, dcpl, dapl)
  if id < 0 then return error(get_error()) end
  return dataset_id(id)
end

function group.open_dataset(group, name, dapl)
  if dapl ~= nil then dapl = dapl.id else dapl = C.H5P_DEFAULT end
  local id = C.H5Dopen(group.id, name, dapl)
  if id < 0 then return error(get_error()) end
  return dataset_id(id)
end

function dataset.get_dataset_create_plist(dataset)
  local id = C.H5Dget_create_plist(dataset.id)
  if id < 0 then return error(get_error()) end
  return plist_id(id)
end

if pcall(function() return C.H5Dget_access_plist end) then
  function dataset.get_dataset_access_plist(dataset)
    local id = C.H5Dget_access_plist(dataset.id)
    if id < 0 then return error(get_error()) end
    return plist_id(id)
  end
end

function dataset.get_type(dataset)
  local id = C.H5Dget_type(dataset.id)
  if id < 0 then return error(get_error()) end
  return datatype_id(id)
end

function dataset.get_space(dataset)
  local id = C.H5Dget_space(dataset.id)
  if id < 0 then return error(get_error()) end
  return dataspace_id(id)
end

do
  local dims_buf = hsize_t_n(C.H5S_MAX_RANK)
  function dataset.set_extent(dataset, dims)
    local rank = #dims
    for i = 0, min(rank, C.H5S_MAX_RANK) - 1 do dims_buf[i] = dims[i + 1] end
    local err = C.H5Dset_extent(dataset.id, dims_buf)
    if err < 0 then return error(get_error()) end
  end
end

function dataset.write(dataset, buf, mem_type, mem_space, file_space, dxpl)
  if mem_space ~= nil then mem_space = mem_space.id else mem_space = C.H5S_ALL end
  if file_space ~= nil then file_space = file_space.id else file_space = C.H5S_ALL end
  if dxpl ~= nil then dxpl = dxpl.id else dxpl = C.H5P_DEFAULT end
  local err = C.H5Dwrite(dataset.id, mem_type.id, mem_space, file_space, dxpl, buf)
  if err < 0 then return error(get_error()) end
end

function dataset.read(dataset, buf, mem_type, mem_space, file_space, dxpl)
  if mem_space ~= nil then mem_space = mem_space.id else mem_space = C.H5S_ALL end
  if file_space ~= nil then file_space = file_space.id else file_space = C.H5S_ALL end
  if dxpl ~= nil then dxpl = dxpl.id else dxpl = C.H5P_DEFAULT end
  local err = C.H5Dread(dataset.id, mem_type.id, mem_space, file_space, dxpl, buf)
  if err < 0 then return error(get_error()) end
end

function _M.vlen_reclaim(buf, mem_type, mem_space, dxpl)
  if dxpl ~= nil then dxpl = dxpl.id else dxpl = C.H5P_DEFAULT end
  local err = C.H5Dvlen_reclaim(mem_type.id, mem_space.id, dxpl, buf)
  if err < 0 then return error(get_error()) end
end

function location.create_attribute(loc, name, dtype, space, acpl, aapl)
  if acpl ~= nil then acpl = acpl.id else acpl = C.H5P_DEFAULT end
  if aapl ~= nil then aapl = aapl.id else aapl = C.H5P_DEFAULT end
  local id = C.H5Acreate(loc.id, name, dtype.id, space.id, acpl, aapl)
  if id < 0 then return error(get_error()) end
  return attribute_id(id)
end

function location.open_attribute(loc, name, aapl)
  if aapl ~= nil then aapl = aapl.id else aapl = C.H5P_DEFAULT end
  local id = C.H5Aopen(loc.id, name, aapl)
  if id < 0 then return error(get_error()) end
  return attribute_id(id)
end

function location.exists_attribute(loc, name)
  local flag = C.H5Aexists(loc.id, name)
  if flag < 0 then return error(get_error()) end
  return flag ~= 0
end

function location.rename_attribute(loc, old_name, new_name)
  local err = C.H5Arename(loc.id, old_name, new_name)
  if err < 0 then return error(get_error()) end
end

function location.delete_attribute(loc, name)
  local err = C.H5Adelete(loc.id, name)
  if err < 0 then return error(get_error()) end
end

function attribute.get_name(attr)
  local ret = C.H5Aget_name(attr.id, 0, nil)
  if ret < 0 then return error(get_error()) end
  if ret == 0 then return end
  local size = tonumber(ret)
  local name = char_n(size + 1)
  local ret = C.H5Aget_name(attr.id, size + 1, name)
  if ret < 0 then return error(get_error()) end
  return ffi.string(name, size)
end

function attribute.get_type(attr)
  local id = C.H5Aget_type(attr.id)
  if id < 0 then return error(get_error()) end
  return datatype_id(id)
end

function attribute.get_space(attr)
  local id = C.H5Aget_space(attr.id)
  if id < 0 then return error(get_error()) end
  return dataspace_id(id)
end

function attribute.write(attr, buf, mem_type)
  local mem_type_id = mem_type.id
  local err = C.H5Awrite(attr.id, mem_type_id, buf)
  if err < 0 then return error(get_error()) end
end

function attribute.read(attr, buf, mem_type)
  local mem_type_id = mem_type.id
  local err = C.H5Aread(attr.id, mem_type_id, buf)
  if err < 0 then return error(get_error()) end
end

do
  local classes = {
    scalar = C.H5S_SCALAR,
    simple = C.H5S_SIMPLE,
    null   = C.H5S_NULL,
  }

  function _M.create_space(class)
    class = classes[class]
    local id = C.H5Screate(class)
    if id < 0 then return error(get_error()) end
    return dataspace_id(id)
  end
end

do
  local classes = {
    [C.H5S_SCALAR] = "scalar",
    [C.H5S_SIMPLE] = "simple",
    [C.H5S_NULL]   = "null",
  }

  function dataspace.get_simple_extent_type(space)
    local class = C.H5Sget_simple_extent_type(space.id)
    if class == C.H5S_NO_CLASS then return error(get_error()) end
    return classes[tonumber(class)]
  end
end

do
  local dims_buf = hsize_t_n(C.H5S_MAX_RANK)
  local maxdims_buf = hsize_t_n(C.H5S_MAX_RANK)
  function _M.create_simple_space(dims, maxdims)
    local rank = #dims
    for i = 0, min(rank, C.H5S_MAX_RANK) - 1 do
      dims_buf[i] = dims[i + 1]
      if maxdims ~= nil then maxdims_buf[i] = maxdims[i + 1] == nil and C.H5S_UNLIMITED or maxdims[i + 1] end
    end
    dims = dims_buf
    if maxdims ~= nil then maxdims = maxdims_buf end
    local id = C.H5Screate_simple(rank, dims, maxdims)
    if id < 0 then return error(get_error()) end
    return dataspace_id(id)
  end
end

do
  local dims_buf = hsize_t_n(C.H5S_MAX_RANK)
  local maxdims_buf = hsize_t_n(C.H5S_MAX_RANK)
  function dataspace.set_extent_simple(space, dims, maxdims)
    local rank = #dims
    for i = 0, min(rank, C.H5S_MAX_RANK) - 1 do
      dims_buf[i] = dims[i + 1]
      if maxdims ~= nil then maxdims_buf[i] = maxdims[i + 1] == nil and C.H5S_UNLIMITED or maxdims[i + 1] end
    end
    dims = dims_buf
    if maxdims ~= nil then maxdims = maxdims_buf end
    local err = C.H5Sset_extent_simple(space.id, rank, dims, maxdims)
    if err < 0 then return error(get_error()) end
  end
end

do
  local dims_buf = hsize_t_n(C.H5S_MAX_RANK)
  local maxdims_buf = hsize_t_n(C.H5S_MAX_RANK)
  function dataspace.get_simple_extent_dims(space)
    local rank = C.H5Sget_simple_extent_dims(space.id, dims_buf, maxdims_buf)
    if rank < 0 then return error(get_error()) end
    local dims, maxdims = {}, {}
    for i = 0, rank - 1 do
      dims[i + 1] = tonumber(dims_buf[i])
      if maxdims_buf[i] ~= C.H5S_UNLIMITED then maxdims[i + 1] = tonumber(maxdims_buf[i]) end
    end
    return dims, maxdims
  end
end

function dataspace.extent_equal(space, space2)
  local flag = C.H5Sextent_equal(space.id, space2.id)
  if flag < 0 then return error(get_error()) end
  return flag ~= 0
end

do
  local ops = {
    ["set"]  = C.H5S_SELECT_SET,
    ["or"]   = C.H5S_SELECT_OR,
    ["and"]  = C.H5S_SELECT_AND,
    ["xor"]  = C.H5S_SELECT_XOR,
    ["notb"] = C.H5S_SELECT_NOTB,
    ["nota"] = C.H5S_SELECT_NOTA,
  }

  local start_buf = hsize_t_n(C.H5S_MAX_RANK)
  local stride_buf = hsize_t_n(C.H5S_MAX_RANK)
  local count_buf = hsize_t_n(C.H5S_MAX_RANK)
  local block_buf = hsize_t_n(C.H5S_MAX_RANK)
  function dataspace.select_hyperslab(space, op, start, stride, count, block)
    op = ops[op]
    local rank = #start
    for i = 0, min(rank, C.H5S_MAX_RANK) - 1 do
      start_buf[i] = start[i + 1]
      if stride ~= nil then stride_buf[i] = stride[i + 1] end
      count_buf[i] = count[i + 1]
      if block ~= nil then block_buf[i] = block[i + 1] end
    end
    start = start_buf
    if stride ~= nil then stride = stride_buf end
    count = count_buf
    if block ~= nil then block = block_buf end
    local err = C.H5Sselect_hyperslab(space.id, op, start, stride, count, block)
    if err < 0 then return error(get_error()) end
  end
end

function dataspace.select_valid(space)
  local flag = C.H5Sselect_valid(space.id)
  if flag < 0 then return error(get_error()) end
  return flag ~= 0
end

do
  local offset_buf = hssize_t_n(C.H5S_MAX_RANK)
  function dataspace.offset_simple(space, offset)
    local rank = #offset
    for i = 0, min(rank, C.H5S_MAX_RANK) - 1 do offset_buf[i] = offset[i + 1] end
    offset = offset_buf
    local err = C.H5Soffset_simple(space.id, offset)
    if err < 0 then return error(get_error()) end
  end
end

function datatype.commit(dtype, group, name, lcpl, tcpl, tapl)
  if lcpl ~= nil then lcpl = lcpl.id else lcpl = C.H5P_DEFAULT end
  if tcpl ~= nil then tcpl = tcpl.id else tcpl = C.H5P_DEFAULT end
  if tapl ~= nil then tapl = tapl.id else tapl = C.H5P_DEFAULT end
  local err = C.H5Tcommit(group.id, name, dtype.id, lcpl, tcpl, tapl)
  if err < 0 then return error(get_error()) end
end

function datatype.commit_anon(dtype, group, tcpl, tapl)
  if tcpl ~= nil then tcpl = tcpl.id else tcpl = C.H5P_DEFAULT end
  if tapl ~= nil then tapl = tapl.id else tapl = C.H5P_DEFAULT end
  local err = C.H5Tcommit_anon(group.id, dtype.id, tcpl, tapl)
  if err < 0 then return error(get_error()) end
end

function datatype.committed(dtype)
  local flag = C.H5Tcommitted(dtype.id)
  if flag < 0 then return error(get_error()) end
  return flag ~= 0
end

function datatype.copy(dtype)
  local id = C.H5Tcopy(dtype.id)
  if id < 0 then return error(get_error()) end
  return datatype_id(id)
end

function datatype.equal(dtype, dtype2)
  local flag = C.H5Tequal(dtype.id, dtype2.id)
  if flag < 0 then return error(get_error()) end
  return flag ~= 0
end

do
  local classes = {
    [C.H5T_INTEGER]   = "integer",
    [C.H5T_FLOAT]     = "float",
    [C.H5T_STRING]    = "string",
    [C.H5T_BITFIELD]  = "bitfield",
    [C.H5T_OPAQUE]    = "opaque",
    [C.H5T_COMPOUND]  = "compound",
    [C.H5T_REFERENCE] = "reference",
    [C.H5T_ENUM]      = "enum",
    [C.H5T_VLEN]      = "vlen",
    [C.H5T_ARRAY]     = "array",
  }

  function datatype.get_class(dtype)
    local class = C.H5Tget_class(dtype.id)
    if class < 0 then return error(get_error()) end
    return classes[tonumber(class)]
  end
end

function datatype.get_size(dtype)
  local size = C.H5Tget_size(dtype.id)
  if size < 0 then return error(get_error()) end
  return tonumber(size)
end

function datatype.set_size(dtype, size)
  if size == "variable" then size = C.H5T_VARIABLE end
  local err = C.H5Tset_size(dtype.id, size)
  if err < 0 then return error(get_error()) end
end

do
  local csets = {
    ascii = C.H5T_CSET_ASCII,
    utf8  = C.H5T_CSET_UTF8,
  }

  function datatype.set_cset(dtype, cset)
    cset = csets[cset]
    local err = C.H5Tset_cset(dtype.id, cset)
    if err < 0 then return error(get_error()) end
  end
end

do
  local csets = {
    [C.H5T_CSET_ASCII] = "ascii",
    [C.H5T_CSET_UTF8]  = "utf8",
  }

  function datatype.get_cset(dtype)
    local cset = C.H5Tget_cset(dtype.id)
    if cset < 0 then return error(get_error()) end
    return csets[tonumber(cset)]
  end
end

function datatype.is_variable_str(dtype)
  local flag = C.H5Tis_variable_str(dtype.id)
  if flag < 0 then return error(get_error()) end
  return flag ~= 0
end

function datatype.enum_create(dtype)
  local id = C.H5Tenum_create(dtype.id)
  if id < 0 then return error(get_error()) end
  return datatype_id(id)
end

function datatype.enum_insert(dtype, name, value)
  local err = C.H5Tenum_insert(dtype.id, name, value)
  if err < 0 then return error(get_error()) end
end

function datatype.enum_nameof(dtype, value)
  local name = char_n(1024)
  local err = C.H5Tenum_nameof(dtype.id, value, name, 1024)
  if err < 0 then return error(get_error()) end
  return ffi.string(name)
end

function datatype.enum_valueof(dtype, name, value)
  local err = C.H5Tenum_valueof(dtype.id, name, value)
  if err < 0 then return error(get_error()) end
end

_M.char        = datatype_id(C.H5T_NATIVE_CHAR)
_M.schar       = datatype_id(C.H5T_NATIVE_SCHAR)
_M.uchar       = datatype_id(C.H5T_NATIVE_UCHAR)
_M.short       = datatype_id(C.H5T_NATIVE_SHORT)
_M.ushort      = datatype_id(C.H5T_NATIVE_USHORT)
_M.int         = datatype_id(C.H5T_NATIVE_INT)
_M.uint        = datatype_id(C.H5T_NATIVE_UINT)
_M.long        = datatype_id(C.H5T_NATIVE_LONG)
_M.ulong       = datatype_id(C.H5T_NATIVE_ULONG)
_M.llong       = datatype_id(C.H5T_NATIVE_LLONG)
_M.ullong      = datatype_id(C.H5T_NATIVE_ULLONG)
_M.int8        = datatype_id(C.H5T_NATIVE_INT8)
_M.uint8       = datatype_id(C.H5T_NATIVE_UINT8)
_M.int16       = datatype_id(C.H5T_NATIVE_INT16)
_M.uint16      = datatype_id(C.H5T_NATIVE_UINT16)
_M.int32       = datatype_id(C.H5T_NATIVE_INT32)
_M.uint32      = datatype_id(C.H5T_NATIVE_UINT32)
_M.int64       = datatype_id(C.H5T_NATIVE_INT64)
_M.uint64      = datatype_id(C.H5T_NATIVE_UINT64)
_M.i8be        = datatype_id(C.H5T_STD_I8BE)
_M.u8be        = datatype_id(C.H5T_STD_U8BE)
_M.i8le        = datatype_id(C.H5T_STD_I8LE)
_M.u8le        = datatype_id(C.H5T_STD_U8LE)
_M.i16be       = datatype_id(C.H5T_STD_I16BE)
_M.u16be       = datatype_id(C.H5T_STD_U16BE)
_M.i16le       = datatype_id(C.H5T_STD_I16LE)
_M.u16le       = datatype_id(C.H5T_STD_U16LE)
_M.i32be       = datatype_id(C.H5T_STD_I32BE)
_M.u32be       = datatype_id(C.H5T_STD_U32BE)
_M.i32le       = datatype_id(C.H5T_STD_I32LE)
_M.u32le       = datatype_id(C.H5T_STD_U32LE)
_M.i64be       = datatype_id(C.H5T_STD_I64BE)
_M.u64be       = datatype_id(C.H5T_STD_U64BE)
_M.i64le       = datatype_id(C.H5T_STD_I64LE)
_M.u64le       = datatype_id(C.H5T_STD_U64LE)
_M.b8          = datatype_id(C.H5T_NATIVE_B8)
_M.b16         = datatype_id(C.H5T_NATIVE_B16)
_M.b32         = datatype_id(C.H5T_NATIVE_B32)
_M.b64         = datatype_id(C.H5T_NATIVE_B64)
_M.b8be        = datatype_id(C.H5T_STD_B8BE)
_M.b8le        = datatype_id(C.H5T_STD_B8LE)
_M.b16be       = datatype_id(C.H5T_STD_B16BE)
_M.b16le       = datatype_id(C.H5T_STD_B16LE)
_M.b32be       = datatype_id(C.H5T_STD_B32BE)
_M.b32le       = datatype_id(C.H5T_STD_B32LE)
_M.b64be       = datatype_id(C.H5T_STD_B64BE)
_M.b64le       = datatype_id(C.H5T_STD_B64LE)
_M.float       = datatype_id(C.H5T_NATIVE_FLOAT)
_M.double      = datatype_id(C.H5T_NATIVE_DOUBLE)
_M.f32be       = datatype_id(C.H5T_IEEE_F32BE)
_M.f32le       = datatype_id(C.H5T_IEEE_F32LE)
_M.f64be       = datatype_id(C.H5T_IEEE_F64BE)
_M.f64le       = datatype_id(C.H5T_IEEE_F64LE)
_M.ref_obj     = datatype_id(C.H5T_STD_REF_OBJ)
_M.ref_dsetreg = datatype_id(C.H5T_STD_REF_DSETREG)
_M.c_s1        = datatype_id(C.H5T_C_S1)
_M.fortran_s1  = datatype_id(C.H5T_FORTRAN_S1)
_M.opaque      = datatype_id(C.H5T_NATIVE_OPAQUE)

function group.create_hard_link(group, obj_group, obj_name, link_name, lcpl, lapl)
  if obj_group ~= nil then obj_group = obj_group.id else obj_group = C.H5L_SAME_LOC end
  if lcpl ~= nil then lcpl = lcpl.id else lcpl = C.H5P_DEFAULT end
  if lapl ~= nil then lapl = lapl.id else lapl = C.H5P_DEFAULT end
  local err = C.H5Lcreate_hard(obj_group, obj_name, group.id, link_name, lcpl, lapl)
  if err < 0 then return error(get_error()) end
end

function group.create_soft_link(group, target_path, link_name, lcpl, lapl)
  if lcpl ~= nil then lcpl = lcpl.id else lcpl = C.H5P_DEFAULT end
  if lapl ~= nil then lapl = lapl.id else lapl = C.H5P_DEFAULT end
  local err = C.H5Lcreate_soft(target_path, group.id, link_name, lcpl, lapl)
  if err < 0 then return error(get_error()) end
end

function group.exists_link(group, name, lapl)
  if lapl ~= nil then lapl = lapl.id else lapl = C.H5P_DEFAULT end
  local flag = C.H5Lexists(group.id, name, lapl)
  if flag < 0 then return error(get_error()) end
  return flag ~= 0
end

function group.delete_link(group, name, lapl)
  if lapl ~= nil then lapl = lapl.id else lapl = C.H5P_DEFAULT end
  local err = C.H5Ldelete(group.id, name, lapl)
  if err < 0 then return error(get_error()) end
end

do
  local types = {
    [C.H5I_DATASET]  = dataset_id,
    [C.H5I_DATATYPE] = datatype_id,
    [C.H5I_GROUP]    = group_id,
  }

  function group.open_object(group, name, lapl)
    if lapl ~= nil then lapl = lapl.id else lapl = C.H5P_DEFAULT end
    local id = C.H5Oopen(group.id, name, lapl)
    if id < 0 then return error(get_error()) end
    local ret = C.H5Iget_type(id)
    if ret < 0 then return error(get_error()) end
    return types[tonumber(ret)](id)
  end
end

if pcall(function() return C.H5Oexists_by_name end) then
  function group.exists_object(group, name, lapl)
    if lapl ~= nil then lapl = lapl.id else lapl = C.H5P_DEFAULT end
    local flag = C.H5Oexists_by_name(group.id, name, lapl)
    if flag < 0 then return error(get_error()) end
    return flag ~= 0
  end
end

function group.link_object(group, object, link_name, lcpl, lapl)
  if lcpl ~= nil then lcpl = lcpl.id else lcpl = C.H5P_DEFAULT end
  if lapl ~= nil then lapl = lapl.id else lapl = C.H5P_DEFAULT end
  local err = C.H5Olink(object.id, group.id, link_name, lcpl, lapl)
  if err < 0 then return error(get_error()) end
end

do
  local types = {
    [C.H5I_ATTR]      = "attr",
    [C.H5I_DATASET]   = "dataset",
    [C.H5I_DATATYPE]  = "datatype",
    [C.H5I_GROUP]     = "group",
    [C.H5I_FILE]      = "file",
  }

  function object.get_object_type(object)
    local ret = C.H5Iget_type(object.id)
    if ret < 0 then return error(get_error()) end
    return types[tonumber(ret)]
  end
end

function object.get_object_name(object)
  local ret = C.H5Iget_name(object.id, nil, 0)
  if ret < 0 then return error(get_error()) end
  if ret == 0 then return end
  local size = tonumber(ret)
  local name = char_n(size + 1)
  local ret = C.H5Iget_name(object.id, name, size + 1)
  if ret < 0 then return error(get_error()) end
  return ffi.string(name, size)
end

function object.get_object_info(object)
  local info = H5O_info_t_1()
  local err = C.H5Oget_info(object.id, info)
  if err < 0 then return error(get_error()) end
  return H5O_info_t(info[0])
end

do
  local types = {
    [C.H5O_TYPE_GROUP]          = "group",
    [C.H5O_TYPE_DATASET]        = "dataset",
    [C.H5O_TYPE_NAMED_DATATYPE] = "named_datatype",
  }

  ffi.metatype(H5O_info_t, {
    __index = {
      get_atime     = function(info) return tonumber(info.atime) end,
      get_mtime     = function(info) return tonumber(info.mtime) end,
      get_ctime     = function(info) return tonumber(info.ctime) end,
      get_btime     = function(info) return tonumber(info.btime) end,
      get_num_links = function(info) return tonumber(info.rc) end,
      get_num_attrs = function(info) return tonumber(info.num_attrs) end,
      get_type      = function(info) return types[tonumber(info.type)] end,
    },
  })
end

do
  local ref_types = {
    object         = C.H5R_OBJECT,
    dataset_region = C.H5R_DATASET_REGION,
  }

  function location.create_reference(loc, name, ref, ref_type, space)
    ref_type = ref_types[ref_type]
    if space ~= nil then space = space.id else space = C.H5I_INVALID_HID end
    local err = C.H5Rcreate(ref, loc.id, name, ref_type, space)
    if err < 0 then return error(get_error()) end
  end

  do
    local obj_types = {
      [C.H5I_GROUP]    = group_id,
      [C.H5I_DATATYPE] = datatype_id,
      [C.H5I_DATASET]  = dataset_id,
    }

    function object.dereference(object, ref, ref_type)
      ref_type = ref_types[ref_type]
      local id = C.H5Rdereference(object.id, ref_type, ref)
      if id < 0 then return error(get_error()) end
      local ret = C.H5Iget_type(id)
      if ret < 0 then return error(get_error()) end
      return obj_types[tonumber(ret)](id)
    end
  end

  function object.get_reference_name(object, ref, ref_type)
    ref_type = ref_types[ref_type]
    local ret = C.H5Rget_name(object.id, ref_type, ref, nil, 0)
    if ret < 0 then return error(get_error()) end
    if ret == 0 then return end
    local size = tonumber(ret)
    local name = char_n(size + 1)
    local ret = C.H5Rget_name(object.id, ref_type, ref, name, size + 1)
    if ret < 0 then return error(get_error()) end
    return ffi.string(name, size)
  end

  local obj_types = {
    [C.H5O_TYPE_GROUP]          = "group",
    [C.H5O_TYPE_DATASET]        = "dataset",
    [C.H5O_TYPE_NAMED_DATATYPE] = "named_datatype",
  }

  function object.get_reference_type(object, ref, ref_type)
    ref_type = ref_types[ref_type]
    local obj_type = H5O_type_t_1()
    local err = C.H5Rget_obj_type(object.id, ref_type, ref, obj_type)
    if err < 0 then return error(get_error()) end
    return obj_types[tonumber(obj_type[0])]
  end

  function object.get_reference_region(object, ref, ref_type)
    ref_type = ref_types[ref_type]
    local id = C.H5Rget_region(object.id, ref_type, ref)
    if id < 0 then return error(get_error()) end
    return dataspace_id(id)
  end
end

do
  local classes = {
    file_create      = C.H5P_FILE_CREATE,
    file_access      = C.H5P_FILE_ACCESS,
    file_mount       = C.H5P_FILE_MOUNT,
    group_create     = C.H5P_GROUP_CREATE,
    group_access     = C.H5P_GROUP_ACCESS,
    dataset_create   = C.H5P_DATASET_CREATE,
    dataset_access   = C.H5P_DATASET_ACCESS,
    dataset_xfer     = C.H5P_DATASET_XFER,
    attribute_create = C.H5P_ATTRIBUTE_CREATE,
    datatype_create  = C.H5P_DATATYPE_CREATE,
    datatype_access  = C.H5P_DATATYPE_ACCESS,
    object_create    = C.H5P_OBJECT_CREATE,
    object_copy      = C.H5P_OBJECT_COPY,
    link_create      = C.H5P_LINK_CREATE,
    link_access      = C.H5P_LINK_ACCESS,
    string_create    = C.H5P_STRING_CREATE,
  }

  function _M.create_plist(class)
    class = classes[class]
    local id = C.H5Pcreate(class)
    if id < 0 then return error(get_error()) end
    return plist_id(id)
  end
end

function plist.get_version(fcpl)
  local super = unsigned_1()
  local freelist = unsigned_1()
  local stab = unsigned_1()
  local shhdr = unsigned_1()
  local err = C.H5Pget_version(fcpl.id, super, freelist, stab, shhdr)
  if err < 0 then return error(get_error()) end
  return super[0], freelist[0], stab[0], shhdr[0]
end

do
  local flags = {
    ["earliest"] = C.H5F_LIBVER_EARLIEST,
    ["18"]       = C.H5F_LIBVER_18,
    ["latest"]   = C.H5F_LIBVER_LATEST,
  }

  function plist.set_libver_bounds(fapl, low, high)
    low, high = flags[low], flags[high]
    local err = C.H5Pset_libver_bounds(fapl.id, low, high)
    if err < 0 then return error(get_error()) end
  end
end

do
  local flags = {
    [C.H5F_LIBVER_EARLIEST] = "earliest",
    [C.H5F_LIBVER_LATEST]   = "latest",
  }

  function plist.get_libver_bounds(fapl)
    local low, high = H5F_libver_t_1(), H5F_libver_t_1()
    local err = C.H5Pget_libver_bounds(fapl.id, low, high)
    if err < 0 then return error(get_error()) end
    return flags[tonumber(low[0])], flags[tonumber(high[0])]
  end
end

if pcall(function() return C.H5Pset_fapl_mpio end) then
  function plist.set_fapl_mpio(fapl, comm, info)
    if info ~= nil then info = info.id else info = ffi.cast("MPI_Info", C.MPI_INFO_NULL) end
    local err = C.H5Pset_fapl_mpio(fapl.id, comm.id, info)
    if err < 0 then return error(get_error()) end
  end
end

do
  local layouts = {
    contiguous = C.H5D_CONTIGUOUS,
    chunked    = C.H5D_CHUNKED,
    compact    = C.H5D_COMPACT,
  }

  function plist.set_layout(plist, layout)
    layout = layouts[layout]
    local err = C.H5Pset_layout(plist.id, layout)
    if err < 0 then return error(get_error()) end
  end
end

do
  local layouts = {
    [C.H5D_CONTIGUOUS] = "contiguous",
    [C.H5D_CHUNKED]    = "chunked",
    [C.H5D_COMPACT]    = "compact",
  }

  function plist.get_layout(plist)
    local ret = C.H5Pget_layout(plist.id)
    if ret < 0 then return error(get_error()) end
    return layouts[tonumber(ret)]
  end
end

do
  local dims_buf = hsize_t_n(C.H5S_MAX_RANK)
  function plist.set_chunk(plist, dims)
    local rank = #dims
    for i = 0, min(rank, C.H5S_MAX_RANK) - 1 do dims_buf[i] = dims[i + 1] end
    local err = C.H5Pset_chunk(plist.id, rank, dims_buf)
    if err < 0 then return error(get_error()) end
  end
end

do
  local dims_buf = hsize_t_n(C.H5S_MAX_RANK)
  function plist.get_chunk(plist)
    local rank = C.H5Pget_chunk(plist.id, C.H5S_MAX_RANK, dims_buf)
    if rank < 0 then return error(get_error()) end
    local dims = {}
    for i = 0, rank - 1 do dims[i + 1] = tonumber(dims_buf[i]) end
    return dims
  end
end

function plist.set_deflate(plist, level)
  local err = C.H5Pset_deflate(plist.id, level)
  if err < 0 then return error(get_error()) end
end

function plist.set_fill_value(plist, buf, buf_type)
  if buf_type ~= nil then buf_type = buf_type.id else buf_type = C.H5I_INVALID_HID end
  local err = C.H5Pset_fill_value(plist.id, buf_type, buf)
  if err < 0 then return error(get_error()) end
end

function plist.get_fill_value(plist, buf, buf_type)
  local err = C.H5Pget_fill_value(plist.id, buf_type.id, buf)
  if err < 0 then return error(get_error()) end
end

do
  local values = {
    [C.H5D_FILL_VALUE_UNDEFINED]    = "undefined",
    [C.H5D_FILL_VALUE_DEFAULT]      = "default",
    [C.H5D_FILL_VALUE_USER_DEFINED] = "user_defined",
  }

  function plist.fill_value_defined(plist)
    local status = H5D_fill_value_t_1()
    local err = C.H5Pfill_value_defined(plist.id, status)
    if err < 0 then return error(get_error()) end
    return values[tonumber(status[0])]
  end
end

if pcall(function() return C.H5Pset_dxpl_mpio end) then
  do
    local xfer_modes = {
      independent = C.H5FD_MPIO_INDEPENDENT,
      collective  = C.H5FD_MPIO_COLLECTIVE,
    }

    function plist.set_dxpl_mpio(dxpl, xfer_mode)
      xfer_mode = xfer_modes[xfer_mode]
      local err = C.H5Pset_dxpl_mpio(dxpl.id, xfer_mode)
      if err < 0 then return error(get_error()) end
    end
  end

  do
    local xfer_modes = {
      [C.H5FD_MPIO_INDEPENDENT] = "independent",
      [C.H5FD_MPIO_COLLECTIVE]  = "collective",
    }

    function plist.get_dxpl_mpio(dxpl, xfer_mode)
      local xfer_mode = ffi.new("H5FD_mpio_xfer_t[1]")
      local err = C.H5Pget_dxpl_mpio(dxpl.id, xfer_mode)
      if err < 0 then return error(get_error()) end
      return xfer_modes[tonumber(xfer_mode[0])]
    end
  end
end

function plist.set_create_intermediate_group(lcpl, flag)
  local err = C.H5Pset_create_intermediate_group(lcpl.id, flag)
  if err < 0 then return error(get_error()) end
end

function plist.get_create_intermediate_group(lcpl)
  local flag = unsigned_1()
  local err = C.H5Pget_create_intermediate_group(lcpl.id, flag)
  if err < 0 then return error(get_error()) end
  return flag[0] ~= 0
end

-- Inherit object methods.
for name, f in pairs(object)   do attribute[name] = f end
for name, f in pairs(object)   do location[name]  = f end
for name, f in pairs(location) do dataset[name]   = f end
for name, f in pairs(location) do group[name]     = f end
for name, f in pairs(location) do datatype[name]  = f end
for name, f in pairs(group)    do file[name]      = f end

-- Compare object identifiers for equality.
local function equal_id(object, object2)
  return ffi.istype(object, object2) and object.id == object2.id
end

-- Close object identifier.
local function close_id(object)
  local err = C.H5Idec_ref(object.id)
  if err < 0 then return error(get_error()) end
end

ffi.metatype(attribute_id, {__index = attribute, __eq = equal_id, __gc = close_id})
ffi.metatype(dataset_id,   {__index = dataset,   __eq = equal_id, __gc = close_id})
ffi.metatype(dataspace_id, {__index = dataspace, __eq = equal_id, __gc = close_id})
ffi.metatype(datatype_id,  {__index = datatype,  __eq = equal_id, __gc = close_id})
ffi.metatype(file_id,      {__index = file,      __eq = equal_id, __gc = close_id})
ffi.metatype(group_id,     {__index = group,     __eq = equal_id, __gc = close_id})
ffi.metatype(plist_id,     {__index = plist,     __eq = equal_id, __gc = close_id})

return _M
