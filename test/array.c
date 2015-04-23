/*
 * C declaration composer for the GCC Lua plugin.
 * Copyright © 2013–2015 Peter Colberg.
 * Distributed under the MIT license. (See accompanying file LICENSE.)
 */

/* array type */
int array_3_of_array_4_of_int[3][4];
int *array_5_of_ptr_to_int[5];
int (*ptr_to_array_of_int)[];
int (*const restrict (*ptr_to_array_4_of_const_restrict_ptr_to_array_5_of_int)[4])[5];
volatile _Bool *restrict (*const array_2_of_const_ptr_to_array_3_of_restrict_ptr_to_volatile_bool[2])[3];

/* array type declaration */
typedef int array_3_of_int_type[3];
array_3_of_int_type array_3_of_int;

/* C99: flexible array member */
struct {
  int i;
  char c[];
} struct_int_array_of_char;

/* GCC C extension: zero-length array member */
struct {
  long l;
  short s[0];
} struct_long_array_of_short;
