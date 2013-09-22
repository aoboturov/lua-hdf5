--
-- C declaration composer for the GCC Lua plugin.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
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

-- vector type
function test.int2_vector(decl)
  assert(cdecl.declare(decl:type()) == "int __attribute__((vector_size(8)))")
  assert(cdecl.declare(decl) == "int __attribute__((vector_size(8))) int2_vector")
end

function test.double4_vector(decl)
  assert(cdecl.declare(decl:type()) == "double __attribute__((vector_size(32)))")
  assert(cdecl.declare(decl) == "double __attribute__((vector_size(32))) double4_vector")
end

-- vector type declaration
function test.const_int2_type_vector(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef int __attribute__((vector_size(8))) int2_type")
  assert(cdecl.declare(decl:type()) == "const int __attribute__((vector_size(8)))")
  assert(cdecl.declare(decl) == "const int __attribute__((vector_size(8))) const_int2_type_vector")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef int __attribute__((vector_size(8))) int2_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const int2_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const int2_type const_int2_type_vector")
end

function test.const_volatile_unsigned_short8_type_vector(decl)
  assert(cdecl.declare(decl:type():name()) == "typedef volatile short unsigned int __attribute__((vector_size(16))) volatile_unsigned_short8_type")
  assert(cdecl.declare(decl:type()) == "const volatile short unsigned int __attribute__((vector_size(16)))")
  assert(cdecl.declare(decl) == "const volatile short unsigned int __attribute__((vector_size(16))) const_volatile_unsigned_short8_type_vector")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef volatile short unsigned int __attribute__((vector_size(16))) volatile_unsigned_short8_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const volatile_unsigned_short8_type")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const volatile_unsigned_short8_type const_volatile_unsigned_short8_type_vector")
end
