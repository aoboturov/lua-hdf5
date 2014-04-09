------------------------------------------------------------------------------
-- Generate C declarations for use with a foreign function interface (FFI).
-- Copyright © 2013–2014 Peter Colberg.
-- Distributed under the MIT license. (See accompanying file LICENSE.)
------------------------------------------------------------------------------

local cdecl = require("gcc.cdecl")

local _M = {}

-- Cache library functions
local select, setmetatable = select, setmetatable

-- The C capture macros are implemented using C function definitions.
-- Some macros parse the function body to evaluate an expression, which
-- is available at the earlier PLUGIN_PRE_GENERICIZE event, but not at
-- the later PLUGIN_FINISH_UNIT event. For the output of functions and
-- global variables, the symbol name is needed, which is available at the
-- PLUGIN_FINISH_UNIT event, but not at the PLUGIN_PRE_GENERICIZE event.
--
-- Each macro function parses a C declaration from a function definition
-- at the PLUGIN_PRE_GENERICIZE event for that definition and returns an
-- output function. The C declaration may be formatted as a string by
-- calling the output function at the PLUGIN_FINISH_UNIT event.
local macro = {}

-- Type declarations may be reordered in the same order as their definition in
-- the header files, which allows an arbitrary order of the capture macros.
-- This table assigns a unique number to each C declaration.
local rank = setmetatable({}, {__mode = "k"})

local function comp(a, b)
  return rank[a] < rank[b]
end

-- Parse C declaration from capture macro.
function _M.parse(node, f)
  local name = node:name()
  if not name then return end
  local op, id = name:value():match("^cdecl_(.-)__(.+)")
  if not op then return end
  if f and op ~= "typename" then id = f(id) or id end
  local output, uid = macro[op](node, id)
  if not output then return end
  local decl = setmetatable({}, {__tostring = output, __lt = comp})
  rank[decl] = uid or node:uid()
  return decl
end

-- Table with type declarations or composite types as keys and identifiers as values.
local typename = {}

function macro.typename(decl, id)
  local result = decl:args():type():type():name()
  typename[result] = id
end

function macro.type(decl, id)
  local result = decl:args():type():type():name()
  typename[result] = id
  local output = function()
    return cdecl.declare(result, function(node)
      return typename[node]
    end)
  end
  return output, result:uid()
end

function macro.typealias(decl, id)
  local result = decl:args():type():type():name()
  typename[result] = id
  local alias = decl:args():chain():type():type():name()
  local output = function()
    return cdecl.declare(result, function(node)
      if node == alias:type():canonical():name() then
        return typename[alias] or alias:name():value()
      end
      return typename[node]
    end)
  end
  return output, result:uid()
end

function macro.memb(decl, id)
  local result = decl:args():type():type():main_variant()
  typename[result] = id
  local output = function()
    return cdecl.declare(result, function(node)
      return typename[node]
    end)
  end
  if result:code() == "enumeral_type" or not result:fields() then
    return output, result:stub_decl():uid()
  end
  return output, result:fields():uid()
end

macro.struct = macro.memb
macro.union  = macro.memb
macro.enum   = macro.memb

function macro.expr(decl, id)
  local result = decl:body():body():args()
  while true do
    if result:class() == "declaration" then
      return function()
        return cdecl.declare(result, function(node)
          if node == result then return id end
          return typename[node]
        end)
      end
    elseif result:class() == "constant" then
      return function()
        return "static const int " .. id .. " = " .. result:value()
      end
    end
    result = select(-1, result:operand())
  end
end

return _M
