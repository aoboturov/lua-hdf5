--
-- C declaration composer for GCC Lua plugin.
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

-- pointer type
function test.ptr_to_const_int(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef const int const_int_type")
  assert(cdecl.declare(decl:type():type()) == "const int")
  assert(cdecl.declare(decl:type()) == "const int *")
  assert(cdecl.declare(decl) == "const int *ptr_to_const_int")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value()
  end) == "typedef const int const_int_type")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value()
  end) == "const_int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const_int_type *")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const_int_type *ptr_to_const_int")
end

function test.restrict_ptr_to_const_int(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef const int const_int_type")
  assert(cdecl.declare(decl:type():type()) == "const int")
  assert(cdecl.declare(decl:type()) == "const int *restrict")
  assert(cdecl.declare(decl) == "const int *restrict restrict_ptr_to_const_int")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value()
  end) == "typedef const int const_int_type")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value()
  end) == "const_int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const_int_type *restrict")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const_int_type *restrict restrict_ptr_to_const_int")
end

function test.restrict_volatile_ptr_to_const_int(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef const int const_int_type")
  assert(cdecl.declare(decl:type():type()) == "const int")
  assert(cdecl.declare(decl:type()) == "const int *restrict volatile")
  assert(cdecl.declare(decl) == "const int *restrict volatile restrict_volatile_ptr_to_const_int")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value()
  end) == "typedef const int const_int_type")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value()
  end) == "const_int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const_int_type *restrict volatile")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const_int_type *restrict volatile restrict_volatile_ptr_to_const_int")
end

function test.const_restrict_ptr_to_void(decl)
  assert(cdecl.declare(decl:type()) == "void *const restrict")
  assert(cdecl.declare(decl) == "void *const restrict const_restrict_ptr_to_void")
end

function test.const_restrict_ptr_to_ptr_to_ptr_to_ptr_to_void(decl)
  assert(cdecl.declare(decl:type()) == "void ****const restrict")
  assert(cdecl.declare(decl) == "void ****const restrict const_restrict_ptr_to_ptr_to_ptr_to_ptr_to_void")
end

function test.const_restrict_ptr_to_volatile_ptr_to_complex_double(decl)
  assert(cdecl.declare(decl:type()) == "complex double *volatile *const restrict")
  assert(cdecl.declare(decl) == "complex double *volatile *const restrict const_restrict_ptr_to_volatile_ptr_to_complex_double")
end

-- pointer type declaration
function test.ptr_to_ptr_to_const_int(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef const int *ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type()) == "const int *")
  assert(cdecl.declare(decl:type()) == "const int **")
  assert(cdecl.declare(decl) == "const int **ptr_to_ptr_to_const_int")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value()
  end) == "typedef const int_type *ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value()
  end) == "ptr_to_const_int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "ptr_to_const_int_type *")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "ptr_to_const_int_type *ptr_to_ptr_to_const_int")
end

function test.ptr_to_const_restrict_ptr_to_const_int(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef const int *ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type()) == "const int *const restrict")
  assert(cdecl.declare(decl:type()) == "const int *const restrict *")
  assert(cdecl.declare(decl) == "const int *const restrict *ptr_to_const_restrict_ptr_to_const_int")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value()
  end) == "typedef const int_type *ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value()
  end) == "const restrict ptr_to_const_int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "const restrict ptr_to_const_int_type *")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "const restrict ptr_to_const_int_type *ptr_to_const_restrict_ptr_to_const_int")
end

function test.ptr_to_volatile_ptr_to_const_restrict_ptr_to_const_int(decl)
  assert(cdecl.declare(decl:type():type():type():name()) == "typedef const int *ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type():type()) == "const int *const restrict")
  assert(cdecl.declare(decl:type():type():name()) == "typedef const int *const restrict *ptr_to_const_restrict_ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type()) == "const int *const restrict *volatile")
  assert(cdecl.declare(decl:type()) == "const int *const restrict *volatile *")
  assert(cdecl.declare(decl) == "const int *const restrict *volatile *ptr_to_volatile_ptr_to_const_restrict_ptr_to_const_int")
  assert(cdecl.declare(decl:type():type():type():name(), function(node)
    return node:name():value()
  end) == "typedef const int_type *ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type():type(), function(node)
    return node:name():value()
  end) == "const restrict ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value()
  end) == "typedef const restrict ptr_to_const_int_type *ptr_to_const_restrict_ptr_to_const_int_type")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value()
  end) == "volatile ptr_to_const_restrict_ptr_to_const_int_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "volatile ptr_to_const_restrict_ptr_to_const_int_type *")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "volatile ptr_to_const_restrict_ptr_to_const_int_type *ptr_to_volatile_ptr_to_const_restrict_ptr_to_const_int")
end
