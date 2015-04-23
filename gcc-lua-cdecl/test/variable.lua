--
-- C declaration composer for the GCC Lua plugin.
-- Copyright © 2013–2015 Peter Colberg.
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

-- GCC C extension: variable declaration attributes
function test.ptr_to_extern_aligned_volatile_short(decl)
  assert(cdecl.declare(decl) == "volatile short int *ptr_to_extern_aligned_volatile_short")
  assert(cdecl.declare(decl, function(node)
    if node == decl then
      return "pointer_to_extern_aligned_volatile_short"
    end
  end) == [[volatile short int *pointer_to_extern_aligned_volatile_short __asm__("ptr_to_extern_aligned_volatile_short")]])
  assert(cdecl.declare(decl:initial():operand()) == "extern volatile short int extern_aligned_volatile_short __attribute__((weak, aligned(32)))")
  assert(cdecl.declare(decl:initial():operand(), function(node)
    if node == decl:initial():operand() then
      return "extern_aligned_volatile_short_int"
    end
  end) == [[extern volatile short int extern_aligned_volatile_short_int __asm__("extern_aligned_volatile_short") __attribute__((weak, aligned(32)))]])
end

function test.extern_aligned_volatile_short(decl)
  assert(cdecl.declare(decl) == "extern volatile short int extern_aligned_volatile_short __attribute__((weak, aligned(32)))")
end
