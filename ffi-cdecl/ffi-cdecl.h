#ifndef FFI_CDECL_H
#define FFI_CDECL_H

#define cdecl_typename(id)              void cdecl_typename__ ## id(id *unused) {}
#define cdecl_type(id)                  void cdecl_type__ ## id(id *unused) {}
#define cdecl_typealias(id, alias)      void cdecl_typealias__ ## id(id *unused1, alias *unused2) {}
#define cdecl_memb(id)                  void cdecl_memb__ ## id(id *unused) {}
#define cdecl_struct(tag)               void cdecl_struct__ ## tag(struct tag *unused) {}
#define cdecl_union(tag)                void cdecl_union__ ## tag(union tag *unused) {}
#define cdecl_enum(tag)                 void cdecl_enum__ ## tag(enum tag *unused) {}
#define cdecl_func(id)                  void cdecl_expr__ ## id(__typeof__(id) unused) { cdecl_expr__ ## id(id); }
#define cdecl_var                       cdecl_func
#define cdecl_const                     cdecl_func

#endif
