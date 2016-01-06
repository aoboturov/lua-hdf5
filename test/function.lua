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

-- function type
function test.ptr_to_func_int_ret_ptr_to_void(decl)
  assert(cdecl.declare(decl:type()) == "void *(*)(int, ...)")
  assert(cdecl.declare(decl) == "void *(*ptr_to_func_int_ret_ptr_to_void)(int, ...)")
end

function test.ptr_to_func_int_ret_ptr_to_array_2_of_ptr_to_void(decl)
  assert(cdecl.declare(decl:type()) == "void *(*(*)(int, ...))[2]")
  assert(cdecl.declare(decl) == "void *(*(*ptr_to_func_int_ret_ptr_to_array_2_of_ptr_to_void)(int, ...))[2]")
end

function test.ptr_to_func_ret_ptr_to_func_void_ret_ptr_to_array_42_of_ptr_to_func_ptr_to_const_char_ret_float(decl)
  assert(cdecl.declare(decl:type()) == "float (*(*(*(*)())(void))[42])(const char *, ...)")
  assert(cdecl.declare(decl) == "float (*(*(*(*ptr_to_func_ret_ptr_to_func_void_ret_ptr_to_array_42_of_ptr_to_func_ptr_to_const_char_ret_float)())(void))[42])(const char *, ...)")
end

-- function declaration
function test.ptr_to_func_ret_ptr_to_short(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef short int *func_ret_ptr_to_short_type()")
  assert(cdecl.declare(decl:type():type()) == "short int *()")
  assert(cdecl.declare(decl:type()) == "short int *(*)()")
  assert(cdecl.declare(decl) == "short int *(*ptr_to_func_ret_ptr_to_short)()")
  assert(cdecl.declare(decl:initial():operand()) == "short int *func_ret_ptr_to_short()")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value()
  end) == "typedef short int *func_ret_ptr_to_short_type()")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value()
  end) == "func_ret_ptr_to_short_type")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "func_ret_ptr_to_short_type *")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "func_ret_ptr_to_short_type *ptr_to_func_ret_ptr_to_short")
  assert(cdecl.declare(decl:initial():operand(), function(node)
    if node == decl:initial():operand() then
      return node:name():value()
    end
  end) == "short int *func_ret_ptr_to_short()")
end

function test.ptr_to_func_int_ret_void(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef void func_int_ret_void_type(int, ...)")
  assert(cdecl.declare(decl:type():type()) == "void (int, ...)")
  assert(cdecl.declare(decl:type()) == "void (*)(int, ...)")
  assert(cdecl.declare(decl) == "void (*ptr_to_func_int_ret_void)(int, ...)")
  assert(cdecl.declare(decl:initial():operand()) == "void func_int_ret_void(int, ...)")
  assert(cdecl.declare(decl:type():type():name(), function(node)
    return node:name():value():upper()
  end) == "typedef VOID FUNC_INT_RET_VOID_TYPE(INT, ...)")
  assert(cdecl.declare(decl:type():type(), function(node)
    return node:name():value():upper()
  end) == "FUNC_INT_RET_VOID_TYPE")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value():upper()
  end) == "FUNC_INT_RET_VOID_TYPE *")
  assert(cdecl.declare(decl, function(node)
    return node:name():value():upper()
  end) == [[FUNC_INT_RET_VOID_TYPE *PTR_TO_FUNC_INT_RET_VOID __asm__("ptr_to_func_int_ret_void")]])
  assert(cdecl.declare(decl:initial():operand(), function(node)
    if node == decl:initial():operand() then
      return node:name():value():upper()
    end
  end) == [[void FUNC_INT_RET_VOID(int, ...) __asm__("func_int_ret_void")]])
end

function test.ptr_to_func_char_ptr_to_char_ptr_to_const_char_ret_int(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef int func_char_ptr_to_char_ptr_to_const_char_ret_int_type(char *, const char *, ...)")
  assert(cdecl.declare(decl:type():type()) == "int (char *, const char *, ...)")
  assert(cdecl.declare(decl:type()) == "int (*)(char *, const char *, ...)")
  assert(cdecl.declare(decl) == "int (*ptr_to_func_char_ptr_to_char_ptr_to_const_char_ret_int)(char *, const char *, ...)")
  assert(cdecl.declare(decl:initial():operand()) == "int func_char_ptr_to_char_ptr_to_const_char_ret_int(char *, const char *, ...)")
end

function test.ptr_to_func_int_void_ret_void(decl)
  assert(cdecl.declare(decl:type():type():name()) == "typedef void func_int_void_ret_void_type(int)")
  assert(cdecl.declare(decl:type():type()) == "void (int)")
  assert(cdecl.declare(decl:type()) == "void (*)(int)")
  assert(cdecl.declare(decl) == "void (*ptr_to_func_int_void_ret_void)(int)")
  assert(cdecl.declare(decl:initial():operand()) == "void func_int_void_ret_void(int)")
end

function test.ptr_to_func_void_ret_void(decl)
  assert(cdecl.declare(decl:type():type()) == "void (void)")
  assert(cdecl.declare(decl:type()) == "void (*)(void)")
  assert(cdecl.declare(decl) == "void (*ptr_to_func_void_ret_void)(void)")
  assert(cdecl.declare(decl:initial():operand()) == "void func_void_ret_void(void)")
  assert(cdecl.declare(decl:initial():operand(), function(node)
    if node == decl:initial():operand() then
      return "function_void_returning_void"
    end
  end) == [[void function_void_returning_void(void) __asm__("func_void_ret_void")]])
  assert(cdecl.declare(decl:initial():operand():type()) == "void (void)")
end

-- variable-length argument list
function test.ptr_to_func_ptr_to_const_char_va_list_ret_void(decl)
  assert(cdecl.declare(decl))
  assert(cdecl.declare(decl:type()))
  assert(cdecl.declare(decl:type():type()))
end

-- GCC C extension: function declaration attributes
function test.ptr_to_func_void_ret_aligned_int(decl)
  assert(cdecl.declare(decl:type():type():type():name()) == "typedef int aligned_int __attribute__((aligned(16)))")
  assert(cdecl.declare(decl:type():type():type()) == "int")
  assert(cdecl.declare(decl) == "int (*ptr_to_func_void_ret_aligned_int)(void)")
  assert(cdecl.declare(decl:initial():operand()) == [[int func_void_ret_aligned_int(void) __attribute__((nothrow, visibility("default")))]])
  assert(cdecl.declare(decl:initial():operand(), function(node)
    return node:name():value()
  end) == [[aligned_int func_void_ret_aligned_int(void) __attribute__((nothrow, visibility("default")))]])
  assert(cdecl.declare(decl:initial():operand():type()) == "int (void)")
  assert(cdecl.declare(decl:initial():operand():type(), function(node)
    return node:name():value()
  end) == "aligned_int (void)")
end
