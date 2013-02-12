C declaration composer for GCC Lua plugin
=========================================

gcc‑lua‑cdecl is a Lua module for composing C declarations from a C source file
using the `Lua plugin for GCC`_. The module generates C99 function, variable
and type declarations, and supports the GCC extensions for `attributes
<http://gcc.gnu.org/onlinedocs/gcc/Attribute-Syntax.html>`_ and `vector types
<http://gcc.gnu.org/onlinedocs/gcc/Vector-Extensions.html>`_. The module may be
used to generate C library bindings for a foreign function interface, e.g.,
`LuaJIT FFI`_.

.. _Lua plugin for GCC: http://colberg.org/gcc-lua/
.. _LuaJIT FFI: http://luajit.org/ext_ffi.html

Reference
---------

.. toctree::
   :maxdepth: 2

   reference/index

Installation
------------

gcc‑lua‑cdecl is available from a `git repository`_::

   git clone http://git.colberg.org/gcc-lua-cdecl.git

.. _git repository: http://git.colberg.org/gcc-lua-cdecl.git

Before using the module, make sure to `compile the gcc‑lua plugin
<http://colberg.org/gcc-lua/#installation>`_.

The module is accompanied by a test suite::

   make test

By default, the tests assume that the gcc‑lua and gcc‑lua‑cdecl repositories are
located in the same parent directory. If the gcc‑lua plugin is installed in the
`GCC plugin directory <http://gcc.gnu.org/onlinedocs/gccint/Plugins-loading.html>`_,
override the make variable ``GCCLUA`` as follows::

   make test GCCLUA=gcclua

Usage
-----

The module :mod:`gcc.cdecl` provides a function :func:`gcc.cdecl.declare`, which
formats a GCC declaration or type node as a string of C code. In the following
examples, we will learn how to use this function to extract functions, variables
and types from the operating system's implementation of the `POSIX
<http://pubs.opengroup.org/onlinepubs/9699919799/>`_ C API.

Extracting functions and variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To extract function and variable declarations from a C header file, we declare
specially-prefixed variables in a C source file that point to the declarations.
The source file is parsed using GCC and a Lua plugin script that selects these
variables by matching their common name prefix.

Create a file ``func.c`` with the following C source code:

.. code-block:: c

   #define _XOPEN_SOURCE 700
   #include <unistd.h>

   #define cdecl_func(name) __typeof__(name) *cdecl_func__ ## name = &name;
   #define cdecl_var cdecl_func

   /* http://pubs.opengroup.org/onlinepubs/9699919799/functions/optarg.html */
   cdecl_func(getopt)
   cdecl_var(optarg)
   cdecl_var(opterr)
   cdecl_var(optind)
   cdecl_var(optopt)

Create a file ``func.lua`` with the following Lua source code:

.. code-block:: lua

   local gcc = require("gcc")
   local cdecl = require("gcc.cdecl")

   -- send assembler output to /dev/null
   gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

   -- invoke Lua function after translation unit has been parsed
   gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
     -- get global variables in reverse order of declaration
     local nodes = gcc.get_variables()
     for i = #nodes, 1, -1 do
       local name = nodes[i]:name():value()
       if name:match("^cdecl_func__") then
         -- get function or variable pointed to by initial value
         local decl = nodes[i]:initial():operand()
         -- output function or variable declaration
         print(cdecl.declare(decl) .. ";")
       end
     end
   end)

Parse the C source file using the GCC Lua plugin::

   gcc -S -std=c99 -Wall -fplugin=../gcc-lua/gcc/gcclua.so -fplugin-arg-gcclua-script=func.lua func.c

The output contains the declarations captured in the C source file::

   int getopt(int, char *const *, const char *) __attribute__((__nothrow__));
   extern char *optarg;
   extern int opterr;
   extern int optind;
   extern int optopt;

Extracting assembler names
^^^^^^^^^^^^^^^^^^^^^^^^^^

Many C libraries use the C preprocessor to substitute documented API names
with internal ABI names. For example, the POSIX function ``basename`` is
implemented as ``__xpg_basename`` in the GNU C library.

:func:`gcc.cdecl.declare` may be passed a function as second argument. This
function is invoked on any declaration or type encountered upon formatting
the first argument, and may return a string that overrides the parsed name. In
this example, we override the internal ABI name of a declaration with its
documented API name.

Create a file ``asm.c`` with the following C source code:

.. code-block:: c

   #define _XOPEN_SOURCE 700
   #include <libgen.h>

   #define cdecl_func(name) __typeof__(name) *cdecl_func__ ## name = &name;
   #define cdecl_var cdecl_func

   /* http://pubs.opengroup.org/onlinepubs/9699919799/functions/basename.html */
   cdecl_func(basename)
   /* http://pubs.opengroup.org/onlinepubs/9699919799/functions/dirname.html */
   cdecl_func(dirname)

Create a file ``asm.lua`` with the following Lua source code:

.. code-block:: lua

   local gcc = require("gcc")
   local cdecl = require("gcc.cdecl")

   -- send assembler output to /dev/null
   gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

   -- invoke Lua function after translation unit has been parsed
   gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
     -- get global variables in reverse order of declaration
     local nodes = gcc.get_variables()
     for i = #nodes, 1, -1 do
       local name = nodes[i]:name():value()
       local name = name:match("^cdecl_func__(.+)")
       if name then
         -- get function or variable pointed to by initial value
         local decl = nodes[i]:initial():operand()
         -- output function or variable declaration with API name
         print(cdecl.declare(decl, function(node)
           if node == decl then return name end
         end) .. ";")
       end
     end
   end)

Parse the C source file using the GCC Lua plugin::

   gcc -S -std=c99 -Wall -fplugin=../gcc-lua/gcc/gcclua.so -fplugin-arg-gcclua-script=asm.lua asm.c

The output contains the declarations captured in the C source file::

   char *basename(char *) __asm__("__xpg_basename") __attribute__((__nothrow__));
   char *dirname(char *) __attribute__((__nothrow__));

Declarations with a differing assembler name include a GCC `asm label
<http://gcc.gnu.org/onlinedocs/gcc/Asm-Labels.html>`_.

Extracting type declarations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To extract type declarations, we declare variables with a corresponding pointee
type. We use pointer variables to avoid warnings about missing initialisation
for constant types.

Create a file ``type.c`` with the following C source code:

.. code-block:: c

   #define _XOPEN_SOURCE 700
   #include <time.h>

   #define cdecl_type(name) name *cdecl_type__ ## name;

   cdecl_type(clockid_t)
   cdecl_type(time_t)

Create a file ``type.lua`` with the following Lua source code:

.. code-block:: lua

   local gcc = require("gcc")
   local cdecl = require("gcc.cdecl")

   -- send assembler output to /dev/null
   gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

   -- invoke Lua function after translation unit has been parsed
   gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
     -- get global variables in reverse order of declaration
     local nodes = gcc.get_variables()
     for i = #nodes, 1, -1 do
       local name = nodes[i]:name():value()
       local name = name:match("^cdecl_type__(.+)")
       if name then
         -- get type declaration of pointee type
         local decl = nodes[i]:type():type():name()
         -- output type declaration with API name
         print(cdecl.declare(decl, function(node)
           if node == decl then return name end
         end) .. ";")
       end
     end
   end)

Parse the C source file using the GCC Lua plugin::

   gcc -S -std=c99 -Wall -fplugin=../gcc-lua/gcc/gcclua.so -fplugin-arg-gcclua-script=type.lua type.c

The output contains the declarations captured in the C source file::

   typedef int clockid_t;
   typedef long int time_t;

Extracting struct, union and enum types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For a type declaration, :func:`gcc.cdecl.declare()` only expands *anonymous*
struct, union and enum types, for the purpose of allowing forward declarations,
and to avoid duplicate definitions. Instead of the type declaration, we format
the type itself to define a named struct, union or enum type.

Create a file ``struct.c`` with the following C source code:

.. code-block:: c

   #define _XOPEN_SOURCE 700
   #include <time.h>

   #define cdecl_struct(name) struct name *cdecl_struct__ ## name;

   cdecl_struct(timespec)

Create a file ``struct.lua`` with the following Lua source code:

.. code-block:: lua

   local gcc = require("gcc")
   local cdecl = require("gcc.cdecl")

   -- send assembler output to /dev/null
   gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

   -- invoke Lua function after translation unit has been parsed
   gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
     -- get global variables in reverse order of declaration
     local nodes = gcc.get_variables()
     for i = #nodes, 1, -1 do
       local name = nodes[i]:name():value()
       local name = name:match("^cdecl_struct__(.+)")
       if name then
         -- get pointee type
         local type = nodes[i]:type():type()
         -- output type with API name
         print(cdecl.declare(type, function(node)
           if node == type then return name end
         end) .. ";")
       end
     end
   end)

Parse the C source file using the GCC Lua plugin::

   gcc -S -std=c99 -Wall -fplugin=../gcc-lua/gcc/gcclua.so -fplugin-arg-gcclua-script=struct.lua struct.c

The output contains the definitions of types captured in the C source file::

   struct timespec {
     long int tv_sec;
     long int tv_nsec;
   };

Extracting constants
^^^^^^^^^^^^^^^^^^^^

In this example, we extract and declare integer constants, which is the only
kind of C constant supported by `LuaJIT FFI`_ as of LuaJIT version 2.0.

Create a file ``const.c`` with the following C source code:

.. code-block:: c

   #define _XOPEN_SOURCE 700
   #include <sys/resource.h>

   #define cdecl_const(name) __typeof__(name) cdecl_const__ ## name = name;

   /* http://pubs.opengroup.org/onlinepubs/9699919799/functions/getrlimit.html */
   cdecl_const(RLIM_INFINITY)
   cdecl_const(RLIMIT_CORE)
   cdecl_const(RLIMIT_CPU)
   cdecl_const(RLIMIT_DATA)
   cdecl_const(RLIMIT_FSIZE)
   cdecl_const(RLIMIT_NOFILE)
   cdecl_const(RLIMIT_STACK)

Create a file ``const.lua`` with the following Lua source code:

.. code-block:: lua

   local gcc = require("gcc")

   -- send assembler output to /dev/null
   gcc.set_asm_file_name(gcc.HOST_BIT_BUCKET)

   -- invoke Lua function after translation unit has been parsed
   gcc.register_callback(gcc.PLUGIN_FINISH_UNIT, function()
     -- get global variables in reverse order of declaration
     local nodes = gcc.get_variables()
     for i = #nodes, 1, -1 do
       local name = nodes[i]:name():value()
       local name = name:match("^cdecl_const__(.+)")
       if name then
         -- extract constant value
         local value = nodes[i]:initial():value()
         -- output constant with API name
         print(("static const int %s = %d;"):format(name, value))
       end
     end
   end)

Parse the C source file using the GCC Lua plugin::

   gcc -S -std=c99 -Wall -fplugin=../gcc-lua/gcc/gcclua.so -fplugin-arg-gcclua-script=const.lua const.c

The output contains the definitions of constants captured in the C source file::

   static const int RLIM_INFINITY = -1;
   static const int RLIMIT_CORE = 4;
   static const int RLIMIT_CPU = 0;
   static const int RLIMIT_DATA = 2;
   static const int RLIMIT_FSIZE = 1;
   static const int RLIMIT_NOFILE = 7;
   static const int RLIMIT_STACK = 3;

Resources
---------

`cdecl <http://packages.debian.org/cdecl>`_ converts C declarations from a
human-readable phrase to C code, and vice versa.
