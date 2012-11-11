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

-- anonymous struct and union
function test.unnamed_union(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.UNION_TYPE)
  assert(decl:type():anonymous() == true)
  assert(decl:type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():name():artificial() == true)
  assert(decl:type():fields():code() == gcc.FIELD_DECL)
  assert(decl:type():fields():name():value() == "unnamed")
  assert(decl:type():fields():type():code() == gcc.RECORD_TYPE)
  assert(decl:type():fields():type():anonymous() == true)
  assert(decl:type():fields():chain():code() == gcc.FIELD_DECL)
  assert(decl:type():fields():chain():name():value() == "named")
  assert(decl:type():fields():chain():type():code() == gcc.RECORD_TYPE)
  assert(decl:type():fields():chain():type():anonymous() == false)
  assert(decl:type():fields():chain():chain():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():chain():chain():artificial() == true)
  assert(decl:type():fields():chain():chain():type():canonical() == decl:type():canonical())
  assert(decl:type():fields():chain():chain():chain():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():chain():chain():chain():artificial() == true)
  assert(decl:type():fields():chain():chain():chain():type():canonical() == decl:type():fields():type():canonical())
  assert(decl:type():fields():chain():chain():chain():chain():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():chain():chain():chain():chain():artificial() == true)
  assert(decl:type():fields():chain():chain():chain():chain():type():canonical() == decl:type():fields():chain():type():canonical())
  assert(decl:type():fields():chain():chain():chain():chain():chain() == nil)
end

function test.named_union(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.UNION_TYPE)
  assert(decl:type():anonymous() == false)
  assert(decl:type():name():code() == gcc.TYPE_DECL)
  assert(decl:type():name():artificial() == false)
  assert(decl:type():fields():code() == gcc.FIELD_DECL)
  assert(decl:type():fields():name():value() == "unnamed")
  assert(decl:type():fields():type():code() == gcc.RECORD_TYPE)
  assert(decl:type():fields():type():anonymous() == true)
  assert(decl:type():fields():chain():code() == gcc.FIELD_DECL)
  assert(decl:type():fields():chain():name():value() == "named")
  assert(decl:type():fields():chain():type():code() == gcc.RECORD_TYPE)
  assert(decl:type():fields():chain():type():anonymous() == false)
  assert(decl:type():fields():chain():chain():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():chain():chain():artificial() == true)
  assert(decl:type():fields():chain():chain():type():canonical() == decl:type():canonical())
  assert(decl:type():fields():chain():chain():chain():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():chain():chain():chain():artificial() == true)
  assert(decl:type():fields():chain():chain():chain():type():canonical() == decl:type():fields():type():canonical())
  assert(decl:type():fields():chain():chain():chain():chain():code() == gcc.TYPE_DECL)
  assert(decl:type():fields():chain():chain():chain():chain():artificial() == true)
  assert(decl:type():fields():chain():chain():chain():chain():type():canonical() == decl:type():fields():chain():type():canonical())
  assert(decl:type():fields():chain():chain():chain():chain():chain() == nil)
end

-- anonymous enum
function test.unnamed_oligomer(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.ENUMERAL_TYPE)
  assert(decl:type():anonymous() == true)
  assert(decl:type():name():artificial() == true)
end

function test.named_oligomer(decl)
  assert(decl:code() == gcc.VAR_DECL)
  assert(decl:type():code() == gcc.ENUMERAL_TYPE)
  assert(decl:type():anonymous() == false)
  assert(decl:type():name():artificial() == true)
end
