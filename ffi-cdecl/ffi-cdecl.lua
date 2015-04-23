------------------------------------------------------------------------------
-- Generate C declarations for use with a foreign function interface (FFI).
-- Copyright © 2013–2015 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

local _M = {}

-- Cache library functions
local select = select

-- The C capture macros are implemented using C function definitions.
-- Some macros parse the function body to evaluate an expression, which
-- is available at the earlier PLUGIN_PRE_GENERICIZE event, but not at
-- the later PLUGIN_FINISH_UNIT event. For the output of functions and
-- global variables, the symbol name is needed, which is available at the
-- PLUGIN_FINISH_UNIT event, but not at the PLUGIN_PRE_GENERICIZE event.
--
-- Each macro function parses a C declaration from a function definition
-- at the PLUGIN_PRE_GENERICIZE event for that definition and returns the
-- captured C declaration and its identifier. The C declaration may be
-- formatted using gcc.cdecl.declare() at the PLUGIN_FINISH_UNIT event.
local macro = {
  type = function(decl)
    return decl:args():type():type():name()
  end,

  memb = function(decl, id)
    return decl:args():type():type():main_variant()
  end,

  expr = function(decl, id)
    local result = decl:body():body():args()
    while true do
      if result:class() == "declaration" then
        break
      elseif result:class() == "constant" then
        break
      end
      result = select(-1, result:operand())
    end
    return result
  end,
}

macro.struct = macro.memb
macro.union = macro.memb
macro.enum = macro.memb

-- Parse C declaration from capture macro.
function _M.parse(node)
  local name = node:name()
  if not name then return end
  local op, id = name:value():match("^cdecl_(.-)__(.+)")
  if not op then return end
  local decl = macro[op](node)
  return decl, id
end

return _M
