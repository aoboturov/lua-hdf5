/*
 * C declaration composer for the GCC Lua plugin.
 * Copyright © 2013 Peter Colberg.
 * For conditions of distribution and use, see copyright notice in LICENSE.
 */

/* enumeral type */
typedef enum interaction {
  strong,
  weak,
  electromagnetic,
  gravitational,
} interaction;
interaction tagged_enum;

typedef enum {
  hydrogen = 1,
  helim = 2,
  oxygen = 8,
  carbon = 6,
  neon = 10,
} elements;
elements untagged_enum;

/* enumeral type as function argument */
void (*ptr_to_func_const_enum_interaction_void_ret_void)(const enum interaction);
void (*ptr_to_func_const_interaction_void_ret_void)(const interaction);

/* GCC C extension: enumeral type attributes */
typedef enum {
  FALSE,
  TRUE,
} __attribute__((packed)) BOOL;
BOOL packed_enum;
