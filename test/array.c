/*
 * C declaration composer for GCC Lua plugin.
 * Copyright © 2013 Peter Colberg.
 * For conditions of distribution and use, see copyright notice in LICENSE.
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
