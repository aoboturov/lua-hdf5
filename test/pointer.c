/*
 * C declaration composer for the GCC Lua plugin.
 * Copyright © 2013 Peter Colberg.
 * For conditions of distribution and use, see copyright notice in LICENSE.
 */

/* pointer type */
typedef int int_type;
typedef const int_type const_int_type;
const_int_type *ptr_to_const_int;
const_int_type *restrict restrict_ptr_to_const_int;
const_int_type *restrict volatile restrict_volatile_ptr_to_const_int;
void *const restrict const_restrict_ptr_to_void;
void ****const restrict const_restrict_ptr_to_ptr_to_ptr_to_ptr_to_void;
double _Complex *volatile *const restrict const_restrict_ptr_to_volatile_ptr_to_complex_double;

/* pointer type declaration */
typedef const int_type *ptr_to_const_int_type;
ptr_to_const_int_type *ptr_to_ptr_to_const_int;
const restrict ptr_to_const_int_type *ptr_to_const_restrict_ptr_to_const_int;
typedef const restrict ptr_to_const_int_type *ptr_to_const_restrict_ptr_to_const_int_type;
volatile ptr_to_const_restrict_ptr_to_const_int_type *ptr_to_volatile_ptr_to_const_restrict_ptr_to_const_int;
