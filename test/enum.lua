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

-- enumeral type
function test.tagged_enum(decl)
  assert(cdecl.declare(decl) == "enum interaction tagged_enum")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "interaction tagged_enum")
  assert(cdecl.declare(decl, function(node)
    return node:name():value():upper()
  end) == [[INTERACTION TAGGED_ENUM __asm__("tagged_enum")]])
  assert(cdecl.declare(decl:type()) == [[
enum interaction {
  strong = 0,
  weak = 1,
  electromagnetic = 2,
  gravitational = 3,
}]])
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "interaction")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value():upper()
  end) == "INTERACTION")
  assert(cdecl.declare(decl:type():main_variant()) == [[
enum interaction {
  strong = 0,
  weak = 1,
  electromagnetic = 2,
  gravitational = 3,
}]])
  assert(cdecl.declare(decl:type():main_variant(), function(node)
    return node:name():value()
  end) == [[
enum interaction {
  strong = 0,
  weak = 1,
  electromagnetic = 2,
  gravitational = 3,
}]])
  assert(cdecl.declare(decl:type():main_variant(), function(node)
    return node:name():value():upper()
  end) == [[
enum INTERACTION {
  strong = 0,
  weak = 1,
  electromagnetic = 2,
  gravitational = 3,
}]])
  assert(cdecl.declare(decl:type():name()) == "typedef enum interaction interaction")
end

function test.untagged_enum(decl)
  assert(cdecl.declare(decl) == [[
enum {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
} untagged_enum]])
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "elements untagged_enum")
  assert(cdecl.declare(decl:type()) == [[
enum {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
}]])
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "elements")
  assert(cdecl.declare(decl:type(), function(node)
    return "ELEMENTS"
  end) == "ELEMENTS")
  assert(cdecl.declare(decl:type():main_variant()) == [[
enum {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
}]])
  assert(cdecl.declare(decl:type():main_variant(), function(node)
    return node:name() and node:name():value()
  end) == [[
enum {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
}]])
  assert(cdecl.declare(decl:type():main_variant(), function(node)
    return "ELEMENTS"
  end) == [[
enum ELEMENTS {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
}]])
  assert(cdecl.declare(decl:type():name()) == [[
typedef enum {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
} elements]])
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name() and node:name():value()
  end) == [[
typedef enum {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
} elements]])
  assert(cdecl.declare(decl:type():name(), function(node)
    return "ELEMENTS"
  end) == "typedef enum ELEMENTS ELEMENTS")
end

-- enumeral type as function argument
function test.ptr_to_func_const_enum_interaction_void_ret_void(decl)
  assert(cdecl.declare(decl) == "void (*ptr_to_func_const_enum_interaction_void_ret_void)(const enum interaction)")
  assert(cdecl.declare(decl:type()) == "void (*)(const enum interaction)")
  assert(cdecl.declare(decl:type():type()) == "void (const enum interaction)")
end

function test.ptr_to_func_const_interaction_void_ret_void(decl)
  assert(cdecl.declare(decl) == "void (*ptr_to_func_const_interaction_void_ret_void)(const enum interaction)")
  assert(cdecl.declare(decl:type()) == "void (*)(const enum interaction)")
  assert(cdecl.declare(decl:type():type()) == "void (const enum interaction)")
end

-- GCC C extension: enumeral type attributes
function test.packed_enum(decl)
  assert(cdecl.declare(decl) == [[
enum {
  FALSE = 0,
  TRUE = 1,
} __attribute__((packed)) packed_enum]])
  assert(cdecl.declare(decl:type()) == [[
enum {
  FALSE = 0,
  TRUE = 1,
} __attribute__((packed))]])
  assert(cdecl.declare(decl:type():name()) == [[
typedef enum {
  FALSE = 0,
  TRUE = 1,
} __attribute__((packed)) BOOL]])
  assert(cdecl.declare(decl:type():name(), function(node)
    return "BOOL"
  end) == "typedef enum BOOL BOOL")
end
