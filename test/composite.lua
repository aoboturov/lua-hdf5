--
-- C declaration composer for the GCC Lua plugin.
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

-- composite type
function test.tagged_struct_decl(decl)
  assert(cdecl.declare(decl) == "struct tagged_struct tagged_struct_decl")
  assert(cdecl.declare(decl, function(node)
    return node:name():value()
  end) == "tagged_struct tagged_struct_decl")
  assert(cdecl.declare(decl, function(node)
    return node:name():value():upper()
  end) == [[TAGGED_STRUCT TAGGED_STRUCT_DECL __asm__("tagged_struct_decl")]])
  assert(cdecl.declare(decl:type()) == [[
struct tagged_struct {
  short int s;
  int i;
}]])
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value()
  end) == "tagged_struct")
  assert(cdecl.declare(decl:type(), function(node)
    return node:name():value():upper()
  end) == "TAGGED_STRUCT")
  assert(cdecl.declare(decl:type():main_variant()) == [[
struct tagged_struct {
  short int s;
  int i;
}]])
  assert(cdecl.declare(decl:type():main_variant(), function(node)
    return node:name():value()
  end) == [[
struct tagged_struct {
  short int s;
  int i;
}]])
  assert(cdecl.declare(decl:type():main_variant(), function(node)
    return node:name():value():upper()
  end) == [[
struct TAGGED_STRUCT {
  SHORT INT S;
  INT I;
}]])
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value()
  end) == "typedef struct tagged_struct tagged_struct")
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name():value():upper()
  end) == "typedef struct TAGGED_STRUCT TAGGED_STRUCT")
end

function test.untagged_struct_decl(decl)
  assert(cdecl.declare(decl) == [[
struct {
  short int s;
  int i;
} untagged_struct_decl]])
  assert(cdecl.declare(decl:type()) == [[
struct {
  short int s;
  int i;
}]])
  assert(cdecl.declare(decl:type():main_variant()) == [[
struct {
  short int s;
  int i;
}]])
  assert(cdecl.declare(decl:type():main_variant()) == [[
struct {
  short int s;
  int i;
}]])
  assert(cdecl.declare(decl:type():name()) == [[
typedef struct {
  short int s;
  int i;
} untagged_struct]])
  assert(cdecl.declare(decl:type():name()) == [[
typedef struct {
  short int s;
  int i;
} untagged_struct]])
end

function test.empty_struct_decl(decl)
  assert(cdecl.declare(decl) == [[
struct {
} empty_struct_decl]])
  assert(cdecl.declare(decl:type()) == [[
struct {
}]])
  assert(cdecl.declare(decl:type():name()) == [[
typedef struct {
} empty_struct]])
end

-- opaque composite type
function test.opaque_union_decl(decl)
  assert(cdecl.declare(decl) == "union opaque_union *opaque_union_decl")
  assert(cdecl.declare(decl:type()) == "union opaque_union *")
  assert(cdecl.declare(decl:type():type()) == "union opaque_union")
end

-- composite type as function argument
function test.ptr_to_func_const_struct_tagged_struct_void_ret_void(decl)
  assert(cdecl.declare(decl) == "void (*ptr_to_func_const_struct_tagged_struct_void_ret_void)(const struct tagged_struct)")
  assert(cdecl.declare(decl:type()) == "void (*)(const struct tagged_struct)")
  assert(cdecl.declare(decl:type():type()) == "void (const struct tagged_struct)")
end

function test.ptr_to_func_const_tagged_struct_void_ret_void(decl)
  assert(cdecl.declare(decl) == "void (*ptr_to_func_const_tagged_struct_void_ret_void)(const struct tagged_struct)")
  assert(cdecl.declare(decl:type()) == "void (*)(const struct tagged_struct)")
  assert(cdecl.declare(decl:type():type()) == "void (const struct tagged_struct)")
end

-- bitfield
function test.bitfield_decl(decl)
  assert(cdecl.declare(decl) == "struct bitfield bitfield_decl")
  assert(cdecl.declare(decl:type()) == [[
struct bitfield {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  short unsigned int unsigned_short;
}]])
  assert(cdecl.declare(decl:type():main_variant()) == [[
struct bitfield {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  short unsigned int unsigned_short;
}]])
  assert(cdecl.declare(decl:type():name()) == "typedef struct bitfield bitfield_type")
end

function test.nested_bitfield_decl(decl)
  assert(cdecl.declare(decl) == [[
struct {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  struct bitfield struct_bitfield;
} nested_bitfield_decl]])
  assert(cdecl.declare(decl:type()) == [[
struct {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  struct bitfield struct_bitfield;
}]])
  assert(cdecl.declare(decl:type():main_variant()) == [[
struct {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  struct bitfield struct_bitfield;
}]])
  assert(cdecl.declare(decl:type():name()) == [[
typedef struct {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  struct bitfield struct_bitfield;
} nested_bitfield_type]])
  assert(cdecl.declare(decl:type():name(), function(node)
    return node:name() and node:name():value():upper()
  end) == [[
typedef struct {
  UNSIGNED INT UNSIGNED_INT_BITFIELD : 1;
  INT SIGNED_INT_BITFIELD : 2;
  UNSIGNED INT : 3;
  INT : 4;
  struct BITFIELD STRUCT_BITFIELD;
} NESTED_BITFIELD_TYPE]])
end

-- GCC C extension: composite type attributes
function test.packed_struct_decl(decl)
  assert(cdecl.declare(decl) == "struct packed_struct packed_struct_decl")
  assert(cdecl.declare(decl:type()) == [[
struct packed_struct {
  short int s;
  int i;
} __attribute__((packed))]])
  assert(cdecl.declare(decl:type():main_variant()) == [[
struct packed_struct {
  short int s;
  int i;
} __attribute__((packed))]])
  assert(cdecl.declare(decl:type():name()) == "typedef struct packed_struct packed_struct")
end

-- GCC C extension: unnamed anonymous members
function test.anon_struct_union(decl)
  assert(cdecl.declare(decl:type()) == [[
union {
  int s[4] __attribute__((aligned(16)));
  struct {
    int x;
    int y;
    int z;
    int w;
  };
  struct {
    int s0;
    int s1;
    int s2;
    int s3;
  };
  struct {
    union {
      int s[2] __attribute__((aligned(8)));
      struct {
        int x;
        int y;
      };
      struct {
        int s0;
        int s1;
      };
      struct {
        int lo;
        int hi;
      };
      int __attribute__((vector_size(8))) v2;
    } lo;
    union {
      int s[2] __attribute__((aligned(8)));
      struct {
        int x;
        int y;
      };
      struct {
        int s0;
        int s1;
      };
      struct {
        int lo;
        int hi;
      };
      int __attribute__((vector_size(8))) v2;
    } hi;
  };
  int __attribute__((vector_size(8))) v2[2];
  int __attribute__((vector_size(16))) v4;
}]])
end
