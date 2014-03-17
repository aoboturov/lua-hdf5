package = "lua-hdf5"
version = "1.0.0-1"
source = {
   url = "git://git.colberg.org/lua-hdf5",
   tag = "1.0.0",
}
description = {
   summary = "HDF5 for Lua",
   detailed = [[
      HDF5 for Lua provides bindings for the Hierarchical Data Format (HDF5), a
      file format and library for portable, flexible and efficient storage of
      numerical data. Lua is a powerful, fast, lightweight, and embeddable
      scripting language. LuaJIT is a just-in-time compiler for the Lua
      language, which allows using native C data structures as part of its
      foreign function interface library (FFI). HDF5 for Lua supports HDF5 1.8
      or later, using LuaJIT.
   ]],
   homepage = "http://colberg.org/lua-hdf5/",
   license = "MIT/X11",
}
build = {
   type = "make",
   install_variables = {
      PREFIX = "$(PREFIX)",
      INSTALL_LMOD = "$(LUADIR)/hdf5",
   }
}
