/*
 * C declaration composer for the GCC Lua plugin.
 * Copyright © 2013 Peter Colberg.
 * Distributed under the MIT license. (See accompanying file LICENSE.)
 */

/* GCC C extension: variable declaration attributes */
extern volatile short extern_aligned_volatile_short __attribute__((weak, aligned(32)));
volatile short *ptr_to_extern_aligned_volatile_short = &extern_aligned_volatile_short;
