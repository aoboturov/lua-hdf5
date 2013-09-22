/*
 * C declaration composer for the GCC Lua plugin.
 * Copyright © 2013 Peter Colberg.
 * For conditions of distribution and use, see copyright notice in LICENSE.
 */

/* function type */
void *(*ptr_to_func_int_ret_ptr_to_void)(int, ...);
void *(*(*ptr_to_func_int_ret_ptr_to_array_2_of_ptr_to_void)(int, ...))[2];
float (*(*(*(*ptr_to_func_ret_ptr_to_func_void_ret_ptr_to_array_42_of_ptr_to_func_ptr_to_const_char_ret_float)())(void))[42])(const char *, ...);

/* function declaration */
short *func_ret_ptr_to_short();
typedef short *func_ret_ptr_to_short_type();
func_ret_ptr_to_short_type *ptr_to_func_ret_ptr_to_short = func_ret_ptr_to_short;

void func_int_ret_void(int, ...);
typedef void func_int_ret_void_type(int, ...);
func_int_ret_void_type *ptr_to_func_int_ret_void = func_int_ret_void;

int func_char_ptr_to_char_ptr_to_const_char_ret_int(char *, const char *, ...);
typedef int func_char_ptr_to_char_ptr_to_const_char_ret_int_type(char *, const char *, ...);
func_char_ptr_to_char_ptr_to_const_char_ret_int_type *ptr_to_func_char_ptr_to_char_ptr_to_const_char_ret_int = func_char_ptr_to_char_ptr_to_const_char_ret_int;

void func_int_void_ret_void(int);
typedef void func_int_void_ret_void_type(int);
func_int_void_ret_void_type *ptr_to_func_int_void_ret_void = func_int_void_ret_void;

void func_void_ret_void(void);
typedef void func_void_ret_void_type(void);
func_void_ret_void_type *ptr_to_func_void_ret_void = func_void_ret_void;

/* GCC C extension: function declaration attributes */
typedef int aligned_int __attribute__((aligned(16)));
aligned_int func_void_ret_aligned_int(void) __attribute__((nothrow, visibility("default")));
aligned_int (*ptr_to_func_void_ret_aligned_int)(void) = func_void_ret_aligned_int;
