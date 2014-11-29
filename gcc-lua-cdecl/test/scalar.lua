--
-- C declaration composer for the GCC Lua plugin.
-- Copyright © 2013 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
--

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

-- scalar type
function test.int_scalar(decl)
  assert(cdecl.declare(decl:type()) == "int")
  assert(cdecl.declare(decl) == "int int_scalar")
end

function test.const_int_scalar(decl)
  assert(cdecl.declare(decl:type()) == "const int")
  assert(cdecl.declare(decl) == "const int const_int_scalar")
end

function test.volatile_int_scalar(decl)
  assert(cdecl.declare(decl:type()) == "volatile int")
  assert(cdecl.declare(decl) == "volatile int volatile_int_scalar")
end

function test.const_volatile_int_scalar(decl)
  assert(cdecl.declare(decl:type()) == "const volatile int")
  assert(cdecl.declare(decl) == "const volatile int const_volatile_int_scalar")
end

function test.short_scalar(decl)
  assert(cdecl.declare(decl:type()) == "short int")
  assert(cdecl.declare(decl) == "short int short_scalar")
end

function test.const_short_scalar(decl)
  assert(cdecl.declare(decl:type()) == "const short int")
  assert(cdecl.declare(decl) == "const short int const_short_scalar")
end

function test.volatile_short_scalar(decl)
  assert(cdecl.declare(decl:type()) == "volatile short int")
  assert(cdecl.declare(decl) == "volatile short int volatile_short_scalar")
end

function test.const_volatile_short_scalar(decl)
  assert(cdecl.declare(decl:type()) == "const volatile short int")
  assert(cdecl.declare(decl) == "const volatile short int const_volatile_short_scalar")
end

-- scalar type declaration
function test.int_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef int int_type")
  assert(cdecl.declare(decl:type()) == "int")
  assert(cdecl.declare(decl) == "int int_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef int int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "int_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "int_type int_type_scalar")
end

function test.const_int_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef int int_type")
  assert(cdecl.declare(decl:type()) == "const int")
  assert(cdecl.declare(decl) == "const int const_int_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef int int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const int_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const int_type const_int_type_scalar")
end

function test.volatile_int_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef int int_type")
  assert(cdecl.declare(decl:type()) == "volatile int")
  assert(cdecl.declare(decl) == "volatile int volatile_int_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef int int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "volatile int_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "volatile int_type volatile_int_type_scalar")
end

function test.volatile_const_int_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef int int_type")
  assert(cdecl.declare(decl:type()) == "const volatile int")
  assert(cdecl.declare(decl) == "const volatile int volatile_const_int_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef int int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const volatile int_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const volatile int_type volatile_const_int_type_scalar")
end

function test.unsigned_long_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type()) == "long unsigned int")
  assert(cdecl.declare(decl) == "long unsigned int unsigned_long_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "unsigned_long_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "unsigned_long_type unsigned_long_type_scalar")
end

function test.const_unsigned_long_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type()) == "const long unsigned int")
  assert(cdecl.declare(decl) == "const long unsigned int const_unsigned_long_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const unsigned_long_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const unsigned_long_type const_unsigned_long_type_scalar")
end

function test.volatile_unsigned_long_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type()) == "volatile long unsigned int")
  assert(cdecl.declare(decl) == "volatile long unsigned int volatile_unsigned_long_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "volatile unsigned_long_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "volatile unsigned_long_type volatile_unsigned_long_type_scalar")
end

function test.volatile_const_unsigned_long_type_scalar(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type()) == "const volatile long unsigned int")
  assert(cdecl.declare(decl) == "const volatile long unsigned int volatile_const_unsigned_long_type_scalar")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef long unsigned int unsigned_long_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const volatile unsigned_long_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const volatile unsigned_long_type volatile_const_unsigned_long_type_scalar")
end
