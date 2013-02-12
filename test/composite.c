/*
 * C declaration composer for GCC Lua plugin.
 * Copyright © 2013 Peter Colberg.
 * For conditions of distribution and use, see copyright notice in LICENSE.
 */

/* composite type */
typedef struct tagged_struct {
  short s;
  int i;
} tagged_struct;
tagged_struct tagged_struct_decl;

typedef struct {
  short s;
  int i;
} untagged_struct;
untagged_struct untagged_struct_decl;

/* opaque composite type */
union opaque_union *opaque_union_decl;

/* composite type as function argument */
void (*ptr_to_func_const_struct_tagged_struct_void_ret_void)(const struct tagged_struct);
void (*ptr_to_func_const_tagged_struct_void_ret_void)(const tagged_struct);

/* bitfield */
typedef struct bitfield {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  unsigned short unsigned_short;
} bitfield_type;
bitfield_type bitfield_decl;

typedef struct {
  unsigned int unsigned_int_bitfield : 1;
  int signed_int_bitfield : 2;
  unsigned int : 3;
  int : 4;
  struct bitfield struct_bitfield;
} nested_bitfield_type;
nested_bitfield_type nested_bitfield_decl;

/* GCC C extension: composite type attributes */
typedef struct packed_struct {
  short s;
  int i;
} __attribute__((packed)) packed_struct;
packed_struct packed_struct_decl;

/* GCC C extension: anonymous struct/union members */
union {
  int __attribute__((aligned(16))) s[4];
  struct {
    int x, y, z, w;
  };
  struct {
    int s0, s1, s2, s3;
  };
  struct {
    union {
      int __attribute__((aligned(8))) s[2];
      struct {
        int x, y;
      };
      struct {
        int s0, s1;
      };
      struct {
        int lo, hi;
      };
      int __attribute__((vector_size(8))) v2;
    } lo, hi;
  };
  int __attribute__((vector_size(8))) v2[2];
  int __attribute__((vector_size(16))) v4;
} anon_struct_union;
