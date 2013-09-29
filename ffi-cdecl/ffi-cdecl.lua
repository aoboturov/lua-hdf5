------------------------------------------------------------------------------
-- Generate C declarations for use with a foreign function interface (FFI).
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

local gcc   = require("gcc")
local cdecl = require("gcc.cdecl")

-- Cache library functions
local insert, concat = table.insert, table.concat

-- Output generated assembly to /dev/null
gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

-- The C capture macros are implemented using C function definitions.
-- Some macros parse the function body to evaluate an expression, which
-- is available at the earlier PLUGIN_PRE_GENERICIZE event, but not at
-- the later PLUGIN_FINISH_UNIT event. For the output of functions and
-- global variables, the symbol name is needed, which is available at the
-- PLUGIN_FINISH_UNIT event, but not at the PLUGIN_PRE_GENERICIZE event.
--
-- A queue containing output functions is used to gather tree nodes with
-- the PLUGIN_PRE_GENERICIZE event, and postpone the output of declarations
-- to the PLUGIN_FINISH_UNIT event.
local queue = {}

-- Reads the template file specified with -fplugin-arg-gcclua-input=…,
-- generates C declarations from the gathered tree nodes, substitutes
-- the declarations for the @CDECL@ keyword, and writes the output file
-- specified with -fplugin-arg-gcclua-output=….
gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
  local input = assert(io.open(arg.input, "r"))
  local template = input:read("*a")
  input:close()
  local result = template:gsub("([%w_]*)@CDECL@([%w_]*)", function(prefix, postfix)
    local f = function(id) return prefix .. id .. postfix end
    local result = {}
    for i = 1, #queue do
      local decl = queue[i](f)
      insert(result, decl .. ";")
    end
    return concat(result, "\n")
  end)
  local output = assert(io.open(arg.output, "w"))
  output:write(result)
  output:close()
end)

-- Functions to handle the function definition created by a capture macro,
-- which extract a tree node, and append an output function to the queue.
local macro = {}

-- Dispatches capture macro to a handler function.
gcc.register_callback(gcc.PLUGIN_PRE_GENERICIZE, function(decl)
  local name = decl:name()
  if not name then return end
  local op, id = name:value():match("^cdecl_(.-)__(.+)")
  if not op then return end
  macro[op](decl, id)
end)

-- Table with type declarations or types as keys, and identifiers as values.
local typename = {}

function macro.typename(decl, id)
  local result = decl:args():type():type():name()
  typename[result] = function() return id end
end

function macro.type(decl, id)
  local result = decl:args():type():type():name()
  insert(queue, function(f)
    return cdecl.declare(result, function(node)
      local name = typename[node]
      if name then return name(f) end
    end)
  end)
  typename[result] = function(f) return f(id) end
end

function macro.memb(decl, id)
  local result = decl:args():type():type():main_variant()
  insert(queue, function(f)
    return cdecl.declare(result, function(node)
      local name = typename[node]
      if name then return name(f) end
    end)
  end)
  typename[result] = function(f) return f(id) end
end

macro.struct = macro.memb
macro.union  = macro.memb
macro.enum   = macro.memb

function macro.expr(decl, id)
  local result = decl:body():body():args()
  while true do
    if result:class() == "declaration" then
      insert(queue, function(f)
        return cdecl.declare(result, function(node)
          if node == result then return f(id) end
          local name = typename[node]
          if name then return name(f) end
        end)
      end)
      break
    elseif result:class() == "constant" then
      insert(queue, function(f)
        return "static const int " .. f(id) .. " = " .. result:value()
      end)
      break
    end
    result = result:operand()
  end
end
