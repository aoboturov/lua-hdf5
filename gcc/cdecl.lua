--
-- C declaration composer for the GCC Lua plugin.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
--

local _M = {}

-- Default indentation.
_M.INDENT = "  "

-- Cache library functions.
local concat, insert, remove = table.concat, table.insert, table.remove
-- Forward declaration.
local format_node_class

-- GCC C extension: Format declaration or type attributes.
local function format_attributes(node, result, last)
  local attr = node:attributes()
  if attr and attr ~= last then
    local pos = #result + 1
    while true do
      local partial = {}
      insert(partial, attr:purpose():value())
      local value = attr:value()
      if value then
        local value = value:value()
        insert(partial, "(")
        if value:code() == "string_cst" then insert(partial, [["]]) end
        insert(partial, value:value())
        if value:code() == "string_cst" then insert(partial, [["]]) end
        insert(partial, ")")
      end
      attr = attr:chain()
      insert(result, pos, concat(partial))
      if not attr or attr == last then break end
      insert(result, pos, ", ")
    end
    insert(result, pos, " __attribute__((")
    insert(result, "))")
  end
end

-- Format type qualifiers.
local function format_qualifiers(node, parent, result, pos, unql)
  local delim = parent and parent:code() ~= "array_type"
  if node:volatile() and not unql:volatile() then
    if delim then insert(result, pos, " ") end
    insert(result, pos, "volatile")
    delim = true
  end
  if node:restrict() and not unql:restrict() then
    if delim then insert(result, pos, " ") end
    insert(result, pos, "restrict")
    delim = true
  end
  if node:const() and not unql:const() then
    if delim then insert(result, pos, " ") end
    insert(result, pos, "const")
    delim = true
  end
end

-- Format scalar type.
local function format_scalar_type(node, parent, result, pos, shift, f)
  if parent then insert(result, pos, " ") end
  local node = node:canonical()
  local decl = node:name()
  insert(result, pos, decl:name():value())
  format_qualifiers(node, decl, result, pos, decl:type())
end

-- Format vector type.
local function format_vector_type(node, parent, result, pos, shift, f)
  if parent then insert(result, pos, " ") end
  insert(result, pos, ")))")
  insert(result, pos, node:size_unit():value())
  insert(result, pos, "__attribute__((vector_size(")
  format_node_class(node:type(), node, result, pos, shift, f)
  format_qualifiers(node, node, result, pos, node:main_variant())
end

-- Format pointer type.
local function format_pointer_type(node, parent, result, pos, shift, f)
  format_qualifiers(node, parent, result, pos, node:main_variant())
  insert(result, pos, "*")
  return format_node_class(node:type(), node, result, pos, shift, f)
end

-- Format array type.
local function format_array_type(node, parent, result, pos, shift, f)
  if parent and parent:code() == "pointer_type" then
    insert(result, pos, "(")
    insert(result, ")")
  end
  insert(result, "[")
  local domain = node:domain()
  if domain and domain:max() then
    local max, min = domain:max():value(), domain:min():value()
    insert(result, max + 1 - min)
  end
  insert(result, "]")
  return format_node_class(node:type(), parent, result, pos, shift, f)
end

-- Format function type.
local function format_function_type(node, parent, result, pos, shift, f)
  if parent and parent:code() == "pointer_type" then
    insert(result, pos, "(")
    insert(result, ")")
  end
  insert(result, "(")
  local arg = node:args()
  if arg then
    while true do
      format_node_class(arg:value(), nil, result, #result + 1, shift, f)
      if arg:value():code() == "void_type" then
        break
      end
      arg = arg:chain()
      if not arg then
        insert(result, ", ...")
        break
      elseif arg:value():code() == "void_type" then
        break
      end
      insert(result, ", ")
    end
  end
  insert(result, ")")
  return format_node_class(node:type(), node, result, pos, shift, f)
end

-- Format enumerated type.
local function format_enumeral_type(node, parent, result, pos, shift, f)
  if parent then insert(result, pos, " ") end
  local main = node:main_variant()
  local name = f and f(main)
  if not name then
    local node = main:name()
    if node then name = node:value() end
  end
  if node:size() and (not name or #result == 0) then
    local body = {}
    insert(body, [[ {
]])
    do
      local shift = shift .. _M.INDENT
      local value = node:values()
      while value do
        insert(body, shift)
        insert(body, value:purpose():value())
        insert(body, " = ")
        insert(body, value:value():value())
        insert(body, [[,
]])
        value = value:chain()
      end
    end
    insert(body, shift)
    insert(body, "}")
    format_attributes(node, body)
    insert(result, pos, concat(body))
  end
  if name then
    insert(result, pos, name)
    insert(result, pos, " ")
  end
  insert(result, pos, "enum")
  format_qualifiers(node, main, result, pos, main)
end

-- Format struct or union type.
local function format_composite_type(node, parent, result, pos, shift, f)
  if parent then insert(result, pos, " ") end
  local main = node:main_variant()
  local name = f and f(main)
  if not name then
    local node = main:name()
    if node then name = node:value() end
  end
  if node:size() and (not name or #result == 0) then
    local body = {}
    insert(body, [[ {
]])
    do
      local shift = shift .. _M.INDENT
      local field = node:fields()
      while field and field:code() == "field_decl" do
        insert(body, shift)
        format_node_class(field, nil, body, #body + 1, shift, f)
        insert(body, [[;
]])
        field = field:chain()
      end
    end
    insert(body, shift)
    insert(body, "}")
    format_attributes(node, body)
    insert(result, pos, concat(body))
  end
  if name then
    insert(result, pos, name)
    insert(result, pos, " ")
  end
  insert(result, pos, node:code() == "record_type" and "struct" or "union")
  format_qualifiers(node, main, result, pos, main)
end

-- Format struct or union field declaration.
local function format_field_decl(node, parent, result, pos, shift, f)
  local name = f and f(node)
  if not name then
    local node = node:name()
    if node then name = node:value() end
  end
  if name then insert(result, pos, name) end
  do
    local parent = name and node
    local node = node:bit_field() and node:bit_field_type() or node:type()
    format_node_class(node, parent, result, pos, shift, f)
  end
  if node:bit_field() then
    insert(result, " : ")
    insert(result, node:size():value())
  end
  format_attributes(node, result)
end

-- Format assembler name.
local function format_assembler_name(node, result, name)
  local label = node:assembler_name()
  if label then
    local label = label:value()
    if label ~= name then
      insert(result, [[ __asm__("]])
      insert(result, label)
      insert(result, [[")]])
    end
  end
end

-- Format function declaration.
local function format_function_decl(node, parent, result, pos, shift, f)
  local name = f and f(node) or node:name():value()
  insert(result, pos, name)
  format_node_class(node:type(), node, result, pos, shift, f)
  format_assembler_name(node, result, name)
  local last
  local decl = node:type():type():name()
  if decl and decl:code() == "type_decl" then
    last = decl:attributes()
  end
  format_attributes(node, result, last)
end

-- Format type declaration.
local function format_type_decl(node, parent, result, pos, shift, f)
  local name = f and f(node) or node:name():value()
  insert(result, pos, name)
  format_node_class(node:type(), node, result, pos, shift, f)
  insert(result, pos, "typedef ")
  format_attributes(node, result)
end

-- Format variable declaration.
local function format_var_decl(node, parent, result, pos, shift, f)
  local name = f and f(node) or node:name():value()
  insert(result, pos, name)
  format_node_class(node:type(), node, result, pos, shift, f)
  format_assembler_name(node, result, name)
  format_attributes(node, result)
  if node:external() then
    insert(result, pos, "extern ")
  end
end

-- Format function by node type.
local type_map = {
  array_type    = format_array_type,
  boolean_type  = format_scalar_type,
  complex_type  = format_scalar_type,
  enumeral_type = format_enumeral_type,
  field_decl    = format_field_decl,
  function_decl = format_function_decl,
  function_type = format_function_type,
  integer_type  = format_scalar_type,
  pointer_type  = format_pointer_type,
  real_type     = format_scalar_type,
  record_type   = format_composite_type,
  type_decl     = format_type_decl,
  union_type    = format_composite_type,
  var_decl      = format_var_decl,
  vector_type   = format_vector_type,
  void_type     = format_scalar_type,
}

-- Format node by node type.
local function format_tree_type(node, parent, result, pos, shift, f)
  local code = node:code()
  local format = type_map[code]
  if not format then
    return error("unsupported tree node type `" .. node:code() .. "'")
  end
  return format(node, parent, result, pos, shift, f)
end

-- Format type.
local function format_type(node, parent, result, pos, shift, f)
  local decl = node:name()
  local name
  if decl and decl ~= parent and decl ~= node:main_variant():name() then
    name = f and f(decl)
  end
  if name then
    if parent then insert(result, pos, " ") end
    insert(result, pos, name)
    return format_qualifiers(node, decl, result, pos, decl:type())
  end
  return format_tree_type(node, parent, result, pos, shift, f)
end

-- Format function by node class.
local class_map = {
  declaration = format_tree_type,
  type        = format_type,
}

-- Format node by node class.
function format_node_class(node, parent, result, pos, shift, f)
  local class = node:class()
  local format = class_map[class]
  if not format then
    return error("unsupported tree node class `" .. node:class() .. "'")
  end
  return format(node, parent, result, pos, shift, f)
end

-- Format declaration or type node.
function _M.declare(node, f)
  local result = {}
  format_node_class(node, nil, result, 1, "", f)
  return concat(result)
end

return _M
