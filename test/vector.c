/*
 * C declaration composer for the GCC Lua plugin.
 * Copyright © 2013–2015 Peter Colberg.
 * Distributed under the MIT license. (See accompanying file LICENSE.)
 */

/* vector type */
int __attribute__((vector_size(8))) int2_vector;
double __attribute__((vector_size(32))) double4_vector;

/* vector type declaration */
typedef int __attribute__((vector_size(8))) int2_type;
const int2_type const_int2_type_vector;
typedef unsigned short __attribute__((vector_size(16))) unsigned_short8_type;
const volatile unsigned_short8_type const_volatile_unsigned_short8_type_vector;
