--
-- C declaration composer for the GCC Lua plugin.
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
--

package.path = "../?.lua;" .. package.path

local gcc   = require("gcc")
local cdecl = require("gcc.cdecl")

gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

local test = {}

gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
  local vars = gcc.get_variables()
  for i = #vars, 1, -1 do
    local decl = assert(vars[i])
    local name = assert(decl:name():value())
    test[name](decl)
  end
end)

-- array type
function test.array_3_of_array_4_of_int(decl)
  assert(cdecl.declare(decl:type()) == "int[3][4]")
  assert(cdecl.declare(decl) == "int array_3_of_array_4_of_int[3][4]")
end

function test.array_5_of_ptr_to_int(decl)
  assert(cdecl.declare(decl:type()) == "int *[5]")
  assert(cdecl.declare(decl) == "int *array_5_of_ptr_to_int[5]")
end

function test.ptr_to_array_of_int(decl)
  assert(cdecl.declare(decl:type()) == "int (*)[]")
  assert(cdecl.declare(decl) == "int (*ptr_to_array_of_int)[]")
end

function test.ptr_to_array_4_of_const_restrict_ptr_to_array_5_of_int(decl)
  assert(cdecl.declare(decl:type()) == "int (*const restrict (*)[4])[5]")
  assert(cdecl.declare(decl) == "int (*const restrict (*ptr_to_array_4_of_const_restrict_ptr_to_array_5_of_int)[4])[5]")
end

function test.array_2_of_const_ptr_to_array_3_of_restrict_ptr_to_volatile_bool(decl)
  assert(cdecl.declare(decl:type()) == "volatile _Bool *restrict (*const[2])[3]")
  assert(cdecl.declare(decl) == "volatile _Bool *restrict (*const array_2_of_const_ptr_to_array_3_of_restrict_ptr_to_volatile_bool[2])[3]")
end

-- array type declaration
function test.array_3_of_int(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef int array_3_of_int_type[3]")
  assert(cdecl.declare(decl:type()) == "int[3]")
  assert(cdecl.declare(decl) == "int array_3_of_int[3]")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef int array_3_of_int_type[3]")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "array_3_of_int_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "array_3_of_int_type array_3_of_int")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value():upper()
  end) == "typedef INT ARRAY_3_OF_INT_TYPE[3]")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value():upper()
  end) == "ARRAY_3_OF_INT_TYPE")
  assert(cdecl.declare(decl, function(node)
    return node:name():value():upper()
  end) == [[ARRAY_3_OF_INT_TYPE ARRAY_3_OF_INT __asm__("array_3_of_int")]])
end

-- C99: flexible array member
function test.struct_int_array_of_char(decl)
  assert(cdecl.declare(decl:type()) == [[
struct {
  int i;
  char c[];
}]])
end

-- GCC C extension: zero-length array member
function test.struct_long_array_of_short(decl)
  assert(cdecl.declare(decl:type()) == [[
struct {
  long int l;
  short int s[];
}]])
end
