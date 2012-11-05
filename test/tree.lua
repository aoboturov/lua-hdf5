--
-- Lua plugin for the GNU Compiler Collection.
-- Copyright © 2012 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
--

local gcc = require("gcc")

local test = {}

gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
  local vars = gcc.get_variables()
  for i = #vars, 1, -1 do
    local decl = assert(vars[i])
    local name = assert(decl:name():value())
    test[name](decl)
  end
end)

-- constants
function test.fibonacci(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:initial():code() == gcc.INTEGER_CST)
  assert(decl:initial():value() == 806515533049393)
end

function test.pi(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:initial():code() == gcc.REAL_CST)
  assert(decl:initial():value() == 3.14159265358979323846)
end

function test.euler_mascheroni(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:initial():code() == gcc.STRING_CST)
  assert(decl:initial():value() == "0.577215664901532860606512090082402431042159")
end

-- pointer and array
function test.pointer_to_troposphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type() == decl:type())
  assert(decl:type():type() ~= decl:type())
  assert(decl:type() ~= decl)
  assert(decl:type() ~= 0)
  assert(decl:type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():name():name():value() == "troposphere_t")
end

function test.pointer_to_pointer_to_troposphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():type():name():name():value() == "troposphere_t")
end

function test.array_3_of_troposphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():domain():code() == gcc.INTEGER_TYPE)
  assert(decl:type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():min():value() == 0)
  assert(decl:type():domain():max():value() == 2)
  assert(decl:type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():name():name():value() == "troposphere_t")
end

function test.array_3_of_array_4_of_troposphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():type():name():name():value() == "troposphere_t")
  assert(decl:type():domain():code() == gcc.INTEGER_TYPE)
  assert(decl:type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():min():value() == 0)
  assert(decl:type():domain():max():value() == 2)
  assert(decl:type():type():domain():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():type():domain():min():value() == 0)
  assert(decl:type():type():domain():max():value() == 3)
end

function test.array_4_of_pointer_to_troposphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():domain():code() == gcc.INTEGER_TYPE)
  assert(decl:type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():min():value() == 0)
  assert(decl:type():domain():max():value() == 3)
  assert(decl:type():type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():type():name():name():value() == "troposphere_t")
end

function test.pointer_to_array_5_of_troposphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():type():domain():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():type():domain():min():value() == 0)
  assert(decl:type():type():domain():max():value() == 4)
  assert(decl:type():type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():type():name():name():value() == "troposphere_t")
end

function test.pointer_to_array_4_of_pointer_to_array_5_of_int(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():type():domain():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():type():domain():min():value() == 0)
  assert(decl:type():type():domain():max():value() == 3)
  assert(decl:type():type():type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():type():type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():type():type():type():domain():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():type():type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():type():type():type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():type():type():type():domain():min():value() == 0)
  assert(decl:type():type():type():type():domain():max():value() == 4)
  assert(decl:type():type():type():type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():type():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():type():type():type():name():name():value() == "troposphere_t")
end

-- qualifier
function test.const_char(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():name():name():value() == "char")
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == false)
end

function test.const_volatile_float(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.REAL_TYPE)
  assert(decl:type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():name():name():value() == "float")
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == true)
end

function test.const_restrict_pointer_to_void(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == true)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.VOID_TYPE)
  assert(decl:type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():name():name():value() == "void")
end

function test.const_restrict_pointer_to_volatile_pointer_to_complex_double(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == true)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():const() == false)
  assert(decl:type():type():restrict() == false)
  assert(decl:type():type():volatile() == true)
  assert(decl:type():type():type():code() == gcc.COMPLEX_TYPE)
  assert(decl:type():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():type():name():name():value() == "complex double")
end

function test.array_2_of_const_pointer_to_array_3_of_restrict_pointer_to_volatile_bool(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():domain():min():value() == 0)
  assert(decl:type():domain():max():value() == 1)
  assert(decl:type():type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():const() == true)
  assert(decl:type():type():volatile() == false)
  assert(decl:type():type():restrict() == false)
  assert(decl:type():type():type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():type():type():domain():min():code() == gcc.INTEGER_CST)
  assert(decl:type():type():type():domain():max():code() == gcc.INTEGER_CST)
  assert(decl:type():type():type():domain():min():value() == 0)
  assert(decl:type():type():type():domain():max():value() == 2)
  assert(decl:type():type():type():type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():type():type():const() == false)
  assert(decl:type():type():type():type():restrict() == true)
  assert(decl:type():type():type():type():volatile() == false)
  assert(decl:type():type():type():type():type():code() == gcc.BOOLEAN_TYPE)
  assert(decl:type():type():type():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():type():type():type():name():name():value() == "_Bool")
end

-- struct and enum
function test.const_pointer_to_enum_stratosphere(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.ENUMERAL_TYPE)
  assert(decl:type():type():name():code() == gcc.IDENTIFIER_NODE)
  assert(decl:type():type():name():value() == "stratosphere")
end

function test.const_pointer_to_stratosphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.ENUMERAL_TYPE)
  assert(decl:type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():name():name():value() == "stratosphere_t")
end

function test.const_pointer_to_struct_mesosphere(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.RECORD_TYPE)
  assert(decl:type():type():name():code() == gcc.IDENTIFIER_NODE)
  assert(decl:type():type():name():value() == "mesosphere")
end

function test.const_pointer_to_mesosphere_t(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():const() == true)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.RECORD_TYPE)
  assert(decl:type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():name():name():value() == "mesosphere_t")
end

-- bitfield
function test.bitfield(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.RECORD_TYPE)
  assert(decl:type():fields():bit_field() == true)
  assert(decl:type():fields():bit_field_type():name():name():value() == "unsigned int")
  assert(decl:type():fields():name():value() == "unsigned_int_bitfield")
  assert(decl:type():fields():size():value() == 1)
  assert(decl:type():fields():chain():bit_field() == true)
  assert(decl:type():fields():chain():bit_field_type():name():name():value() == "int")
  assert(decl:type():fields():chain():name():value() == "signed_int_bitfield")
  assert(decl:type():fields():chain():size():value() == 2)
  assert(decl:type():fields():chain():chain():bit_field() == true)
  assert(decl:type():fields():chain():chain():bit_field_type():name():name():value() == "unsigned int")
  assert(decl:type():fields():chain():chain():name() == nil)
  assert(decl:type():fields():chain():chain():size():value() == 3)
  assert(decl:type():fields():chain():chain():chain():bit_field() == true)
  assert(decl:type():fields():chain():chain():chain():bit_field_type():name():name():value() == "int")
  assert(decl:type():fields():chain():chain():chain():name() == nil)
  assert(decl:type():fields():chain():chain():chain():size():value() == 4)
  assert(decl:type():fields():chain():chain():chain():chain():bit_field() == false)
  assert(decl:type():fields():chain():chain():chain():chain():bit_field_type() == nil)
  assert(decl:type():fields():chain():chain():chain():chain():name():value() == "unsigned_short")
  assert(decl:type():fields():chain():chain():chain():chain():type():name():name():value() == "short unsigned int")
  assert(decl:type():fields():chain():chain():chain():chain():chain() == nil)
end

-- vector
function test.vector_2_of_double(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.VECTOR_TYPE)
  assert(decl:type():const() == false)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.REAL_TYPE)
  assert(decl:type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():name():name():value() == "double")
  assert(decl:type():size():code() == gcc.INTEGER_CST)
  assert(decl:type():size():value() == 128)
  assert(decl:type():units() == 2)
end

function test.vector_8_of_int(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.VECTOR_TYPE)
  assert(decl:type():const() == false)
  assert(decl:type():restrict() == false)
  assert(decl:type():volatile() == false)
  assert(decl:type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():name():name():value() == "int")
  assert(decl:type():size():code() == gcc.INTEGER_CST)
  assert(decl:type():size():value() == 256)
  assert(decl:type():units() == 8)
end

-- packed struct
function test.packed_struct(decl)
  assert(decl:type():packed() == true)
  assert(decl:type():size():value() == 96)
  assert(decl:type():attributes():code() == gcc.TREE_LIST)
  assert(decl:type():attributes():purpose():value() == "packed")
  assert(decl:type():attributes():value() == nil)
  assert(decl:type():attributes():chain() == nil)
  assert(decl:type():fields():code() == gcc.FIELD_DECL)
  assert(decl:type():fields():name():value() == "i")
  assert(decl:type():fields():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():fields():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():type():name():name():value() == "int")
  assert(decl:type():fields():chain():name():value() == "d")
  assert(decl:type():fields():chain():type():code() == gcc.REAL_TYPE)
  assert(decl:type():fields():chain():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():chain():type():name():name():value() == "double")
  assert(decl:type():fields():chain():chain() == nil)
end

function test.unpacked_struct(decl)
  assert(decl:type():packed() == false)
  assert(decl:type():size():value() == 128)
  assert(decl:type():attributes() == nil)
end

-- non-default alignment
function test.user_align(decl)
  assert(decl:type():user_align() == true)
  assert(decl:type():align() == 128)
  assert(decl:type():align_unit() == 16)
  assert(decl:type():attributes() == nil)
  assert(decl:type():fields():name():value() == "s")
  assert(decl:type():fields():type():code() == gcc.ARRAY_TYPE)
  assert(decl:type():fields():type():domain():min():value() == 0)
  assert(decl:type():fields():type():domain():max():value() == 3)
  assert(decl:type():fields():type():type():code() == gcc.INTEGER_TYPE)
  assert(decl:type():fields():type():type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():type():type():name():name():value() == "int")
  assert(decl:type():fields():align() == 128)
  assert(decl:type():fields():align_unit() == 16)
  assert(decl:type():fields():user_align() == true)
  assert(decl:type():fields():size():value() == 128)
  assert(decl:type():fields():size_unit():value() == 16)
  assert(decl:type():fields():attributes():code() == gcc.TREE_LIST)
  assert(decl:type():fields():attributes():purpose():value() == "aligned")
  assert(decl:type():fields():attributes():value():code() == gcc.TREE_LIST)
  assert(decl:type():fields():attributes():value():value():code() == gcc.INTEGER_CST)
  assert(decl:type():fields():attributes():value():value():value() == 16)
end

function test.default_align(decl)
  assert(decl:type():user_align() == false)
  assert(decl:type():align() == 32)
  assert(decl:type():align_unit() == 4)
end

-- function
function test.function_int_returning_void(decl)
  assert(decl:type():code() == gcc.POINTER_TYPE)
  assert(decl:type():type():code() == gcc.FUNCTION_TYPE)
  assert(decl:type():type():retn():code() == gcc.VOID_TYPE)
  assert(decl:type():type():args():code() == gcc.TREE_LIST)
  assert(decl:type():type():args():value():code() == gcc.INTEGER_TYPE)
  assert(decl:type():type():args():value():name():code() == gcc.TYPE_DECL)
  assert(decl:type():type():args():value():name():name():value() == "int")
  assert(decl:type():type():args():chain():value():code() == gcc.VOID_TYPE)
  assert(decl:type():type():args():chain():chain() == nil)
end

-- operand
function test.address_of_const_char(decl)
  assert(decl:initial():code() == gcc.ADDR_EXPR)
  assert(#{decl:initial():operand()} == 1)
  assert(decl:initial():operand():code() == gcc.VAR_DECL)
  assert(decl:initial():operand():name():value() == "const_char")
end
