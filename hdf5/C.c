/*
 * HDF5 for Lua.
 * Copyright © 2013 Peter Colberg.
 * Distributed under the MIT license. (See accompanying file LICENSE.)
 */

/* LuaJIT allows passing Lua file object as `void *` argument. */
#include <stdio.h>
#define FILE void

/* LuaJIT defines ptrdiff_t but not ssize_t. */
#include <sys/types.h>
#define ssize_t ptrdiff_t

#include <hdf5.h>

#ifndef H5_VERSION_GE
#define H5_VERSION_GE(maj, min, rel) (H5_VERS_MAJOR > maj || H5_VERS_MAJOR == maj && (H5_VERS_MINOR > min || H5_VERS_MINOR == min && H5_VERS_RELEASE >= rel))
#endif

#include "ffi-cdecl.h"
#include "ffi-cdecl-luajit.h"

/* General Library Functions */
cdecl_type(herr_t)
cdecl_type(hbool_t)
cdecl_type(htri_t)
cdecl_type(hsize_t)
cdecl_type(hssize_t)
cdecl_typealias(haddr_t, uint64_t)

cdecl_const(H5_VERS_MAJOR)
cdecl_const(H5_VERS_MINOR)
cdecl_const(H5_VERS_RELEASE)

cdecl_const(H5P_DEFAULT)

cdecl_type(H5_iter_order_t)
cdecl_memb(H5_iter_order_t)

cdecl_const(H5_ITER_ERROR)
cdecl_const(H5_ITER_CONT)
cdecl_const(H5_ITER_STOP)

cdecl_type(H5_index_t)
cdecl_memb(H5_index_t)

cdecl_type(H5_ih_info_t)
cdecl_memb(H5_ih_info_t)

cdecl_func(H5open)
cdecl_func(H5close)
cdecl_func(H5dont_atexit)
cdecl_func(H5garbage_collect)
cdecl_func(H5set_free_list_limits)
cdecl_func(H5get_libversion)
cdecl_func(H5check_version)

/* Identifier Interface */
cdecl_type(hid_t)

cdecl_const(H5I_INVALID_HID)

cdecl_type(H5I_type_t)
cdecl_memb(H5I_type_t)

cdecl_type(H5I_free_t)
cdecl_type(H5I_search_func_t)

cdecl_func(H5Iregister)
cdecl_func(H5Iobject_verify)
cdecl_func(H5Iremove_verify)
cdecl_func(H5Iget_type)
cdecl_func(H5Iget_file_id)
cdecl_func(H5Iget_name)
cdecl_func(H5Iinc_ref)
cdecl_func(H5Idec_ref)
cdecl_func(H5Iget_ref)
cdecl_func(H5Iregister_type)
cdecl_func(H5Iclear_type)
cdecl_func(H5Idestroy_type)
cdecl_func(H5Iinc_type_ref)
cdecl_func(H5Idec_type_ref)
cdecl_func(H5Iget_type_ref)
cdecl_func(H5Isearch)
cdecl_func(H5Inmembers)
cdecl_func(H5Itype_exists)
#if H5_VERSION_GE(1, 8, 3)
cdecl_func(H5Iis_valid)
#endif

/* Error Interface */
cdecl_const(H5E_DEFAULT)

cdecl_type(H5E_type_t)
cdecl_memb(H5E_type_t)

cdecl_type(H5E_error_t)
cdecl_memb(H5E_error_t)

cdecl_const(H5E_ERR_CLS)
cdecl_const(H5E_DATASET)
cdecl_const(H5E_FUNC)
cdecl_const(H5E_STORAGE)
cdecl_const(H5E_FILE)
cdecl_const(H5E_SOHM)
cdecl_const(H5E_SYM)
#if H5_VERSION_GE(1, 8, 11)
cdecl_const(H5E_PLUGIN)
#endif
cdecl_const(H5E_VFL)
cdecl_const(H5E_INTERNAL)
cdecl_const(H5E_BTREE)
cdecl_const(H5E_REFERENCE)
cdecl_const(H5E_DATASPACE)
cdecl_const(H5E_RESOURCE)
cdecl_const(H5E_PLIST)
cdecl_const(H5E_LINK)
cdecl_const(H5E_DATATYPE)
cdecl_const(H5E_RS)
cdecl_const(H5E_HEAP)
cdecl_const(H5E_OHDR)
cdecl_const(H5E_ATOM)
cdecl_const(H5E_ATTR)
cdecl_const(H5E_NONE_MAJOR)
cdecl_const(H5E_IO)
cdecl_const(H5E_SLIST)
cdecl_const(H5E_EFL)
cdecl_const(H5E_TST)
cdecl_const(H5E_ARGS)
cdecl_const(H5E_ERROR)
cdecl_const(H5E_PLINE)
cdecl_const(H5E_FSPACE)
cdecl_const(H5E_CACHE)
cdecl_const(H5E_SEEKERROR)
cdecl_const(H5E_READERROR)
cdecl_const(H5E_WRITEERROR)
cdecl_const(H5E_CLOSEERROR)
cdecl_const(H5E_OVERFLOW)
cdecl_const(H5E_FCNTL)
cdecl_const(H5E_NOSPACE)
cdecl_const(H5E_CANTALLOC)
cdecl_const(H5E_CANTCOPY)
cdecl_const(H5E_CANTFREE)
cdecl_const(H5E_ALREADYEXISTS)
cdecl_const(H5E_CANTLOCK)
cdecl_const(H5E_CANTUNLOCK)
cdecl_const(H5E_CANTGC)
cdecl_const(H5E_CANTGETSIZE)
cdecl_const(H5E_OBJOPEN)
cdecl_const(H5E_CANTRESTORE)
cdecl_const(H5E_CANTCOMPUTE)
cdecl_const(H5E_CANTEXTEND)
cdecl_const(H5E_CANTATTACH)
cdecl_const(H5E_CANTUPDATE)
cdecl_const(H5E_CANTOPERATE)
cdecl_const(H5E_CANTINIT)
cdecl_const(H5E_ALREADYINIT)
cdecl_const(H5E_CANTRELEASE)
cdecl_const(H5E_CANTGET)
cdecl_const(H5E_CANTSET)
cdecl_const(H5E_DUPCLASS)
#if H5_VERSION_GE(1, 8, 9)
cdecl_const(H5E_SETDISALLOWED)
#endif
cdecl_const(H5E_CANTMERGE)
cdecl_const(H5E_CANTREVIVE)
cdecl_const(H5E_CANTSHRINK)
cdecl_const(H5E_LINKCOUNT)
cdecl_const(H5E_VERSION)
cdecl_const(H5E_ALIGNMENT)
cdecl_const(H5E_BADMESG)
cdecl_const(H5E_CANTDELETE)
cdecl_const(H5E_BADITER)
cdecl_const(H5E_CANTPACK)
cdecl_const(H5E_CANTRESET)
cdecl_const(H5E_CANTRENAME)
cdecl_const(H5E_SYSERRSTR)
cdecl_const(H5E_NOFILTER)
cdecl_const(H5E_CALLBACK)
cdecl_const(H5E_CANAPPLY)
cdecl_const(H5E_SETLOCAL)
cdecl_const(H5E_NOENCODER)
cdecl_const(H5E_CANTFILTER)
cdecl_const(H5E_CANTOPENOBJ)
cdecl_const(H5E_CANTCLOSEOBJ)
cdecl_const(H5E_COMPLEN)
cdecl_const(H5E_PATH)
cdecl_const(H5E_NONE_MINOR)
#if H5_VERSION_GE(1, 8, 11)
cdecl_const(H5E_OPENERROR)
#endif
cdecl_const(H5E_FILEEXISTS)
cdecl_const(H5E_FILEOPEN)
cdecl_const(H5E_CANTCREATE)
cdecl_const(H5E_CANTOPENFILE)
cdecl_const(H5E_CANTCLOSEFILE)
cdecl_const(H5E_NOTHDF5)
cdecl_const(H5E_BADFILE)
cdecl_const(H5E_TRUNCATED)
cdecl_const(H5E_MOUNT)
cdecl_const(H5E_BADATOM)
cdecl_const(H5E_BADGROUP)
cdecl_const(H5E_CANTREGISTER)
cdecl_const(H5E_CANTINC)
cdecl_const(H5E_CANTDEC)
cdecl_const(H5E_NOIDS)
cdecl_const(H5E_CANTFLUSH)
cdecl_const(H5E_CANTSERIALIZE)
cdecl_const(H5E_CANTLOAD)
cdecl_const(H5E_PROTECT)
cdecl_const(H5E_NOTCACHED)
cdecl_const(H5E_SYSTEM)
cdecl_const(H5E_CANTINS)
cdecl_const(H5E_CANTPROTECT)
cdecl_const(H5E_CANTUNPROTECT)
cdecl_const(H5E_CANTPIN)
cdecl_const(H5E_CANTUNPIN)
cdecl_const(H5E_CANTMARKDIRTY)
cdecl_const(H5E_CANTDIRTY)
cdecl_const(H5E_CANTEXPUNGE)
cdecl_const(H5E_CANTRESIZE)
cdecl_const(H5E_TRAVERSE)
cdecl_const(H5E_NLINKS)
cdecl_const(H5E_NOTREGISTERED)
cdecl_const(H5E_CANTMOVE)
cdecl_const(H5E_CANTSORT)
cdecl_const(H5E_MPI)
cdecl_const(H5E_MPIERRSTR)
cdecl_const(H5E_CANTRECV)
cdecl_const(H5E_CANTCLIP)
cdecl_const(H5E_CANTCOUNT)
cdecl_const(H5E_CANTSELECT)
cdecl_const(H5E_CANTNEXT)
cdecl_const(H5E_BADSELECT)
cdecl_const(H5E_CANTCOMPARE)
cdecl_const(H5E_UNINITIALIZED)
cdecl_const(H5E_UNSUPPORTED)
cdecl_const(H5E_BADTYPE)
cdecl_const(H5E_BADRANGE)
cdecl_const(H5E_BADVALUE)
cdecl_const(H5E_NOTFOUND)
cdecl_const(H5E_EXISTS)
cdecl_const(H5E_CANTENCODE)
cdecl_const(H5E_CANTDECODE)
cdecl_const(H5E_CANTSPLIT)
cdecl_const(H5E_CANTREDISTRIBUTE)
cdecl_const(H5E_CANTSWAP)
cdecl_const(H5E_CANTINSERT)
cdecl_const(H5E_CANTLIST)
cdecl_const(H5E_CANTMODIFY)
cdecl_const(H5E_CANTREMOVE)
cdecl_const(H5E_CANTCONVERT)
cdecl_const(H5E_BADSIZE)

cdecl_type(H5E_direction_t)
cdecl_memb(H5E_direction_t)

cdecl_type(H5E_walk_t)
cdecl_type(H5E_auto_t)

cdecl_func(H5Eregister_class)
cdecl_func(H5Eunregister_class)
cdecl_func(H5Eclose_msg)
cdecl_func(H5Ecreate_msg)
cdecl_func(H5Ecreate_stack)
cdecl_func(H5Eget_current_stack)
cdecl_func(H5Eclose_stack)
cdecl_func(H5Eget_class_name)
cdecl_func(H5Eset_current_stack)
cdecl_func(H5Epush)
cdecl_func(H5Epop)
cdecl_func(H5Eprint)
cdecl_func(H5Ewalk)
cdecl_func(H5Eget_auto)
cdecl_func(H5Eset_auto)
cdecl_func(H5Eclear)
cdecl_func(H5Eget_msg)
cdecl_func(H5Eget_num)

/* File Interface */
cdecl_enum(H5C_cache_incr_mode)

cdecl_enum(H5C_cache_flash_incr_mode)

cdecl_enum(H5C_cache_decr_mode)

cdecl_const(H5AC__CURR_CACHE_CONFIG_VERSION)
cdecl_const(H5AC__MAX_TRACE_FILE_NAME_LEN)

#if H5_VERSION_GE(1, 8, 6)
cdecl_const(H5AC_METADATA_WRITE_STRATEGY__PROCESS_0_ONLY)
cdecl_const(H5AC_METADATA_WRITE_STRATEGY__DISTRIBUTED)
#endif

cdecl_type(H5AC_cache_config_t)
cdecl_memb(H5AC_cache_config_t)

cdecl_const(H5F_ACC_RDONLY)
cdecl_const(H5F_ACC_RDWR)
cdecl_const(H5F_ACC_TRUNC)
cdecl_const(H5F_ACC_EXCL)
cdecl_const(H5F_ACC_DEBUG)
cdecl_const(H5F_ACC_CREAT)
#if H5_VERSION_GE(1, 8, 3)
cdecl_const(H5F_ACC_DEFAULT)
#endif

cdecl_const(H5F_OBJ_FILE)
cdecl_const(H5F_OBJ_DATASET)
cdecl_const(H5F_OBJ_GROUP)
cdecl_const(H5F_OBJ_DATATYPE)
cdecl_const(H5F_OBJ_ATTR)
cdecl_const(H5F_OBJ_ALL)
cdecl_const(H5F_OBJ_LOCAL)

cdecl_const(H5F_FAMILY_DEFAULT)

cdecl_type(H5F_scope_t)
cdecl_memb(H5F_scope_t)

cdecl_const(H5F_UNLIMITED)

cdecl_type(H5F_close_degree_t)
cdecl_memb(H5F_close_degree_t)

cdecl_type(H5F_info_t)
cdecl_memb(H5F_info_t)

#if H5_VERSION_GE(1, 8, 4)
cdecl_type(H5F_mem_t)
cdecl_memb(H5F_mem_t)
#else
cdecl_memb(H5FD_mem_t)
#endif
cdecl_type(H5FD_mem_t)

cdecl_type(H5F_libver_t)
cdecl_memb(H5F_libver_t)

#if !H5_VERSION_GE(1, 8, 6)
#define H5F_LIBVER_18 H5F_LIBVER_LATEST
#endif
cdecl_const(H5F_LIBVER_18)

cdecl_func(H5Fis_hdf5)
cdecl_func(H5Fcreate)
cdecl_func(H5Fopen)
cdecl_func(H5Freopen)
cdecl_func(H5Fflush)
cdecl_func(H5Fclose)
cdecl_func(H5Fget_create_plist)
cdecl_func(H5Fget_access_plist)
cdecl_func(H5Fget_intent)
#if H5_VERSION_GE(1, 8, 2)
cdecl_func(H5Fget_obj_count)
cdecl_func(H5Fget_obj_ids)
#else
cdecl_func(H5Fget_obj_count)
cdecl_func(H5Fget_obj_ids)
#endif
cdecl_func(H5Fget_vfd_handle)
cdecl_func(H5Fmount)
cdecl_func(H5Funmount)
cdecl_func(H5Fget_freespace)
cdecl_func(H5Fget_filesize)
#if H5_VERSION_GE(1, 8, 9)
cdecl_func(H5Fget_file_image)
#endif
cdecl_func(H5Fget_mdc_config)
cdecl_func(H5Fset_mdc_config)
cdecl_func(H5Fget_mdc_hit_rate)
cdecl_func(H5Fget_mdc_size)
cdecl_func(H5Freset_mdc_hit_rate_stats)
cdecl_func(H5Fget_name)
cdecl_func(H5Fget_info)
#if H5_VERSION_GE(1, 8, 7)
cdecl_func(H5Fclear_elink_file_cache)
#endif
#if H5_HAVE_PARALLEL && H5_VERSION_GE(1, 8, 9)
cdecl_func(H5Fset_mpi_atomicity)
cdecl_func(H5Fget_mpi_atomicity)
#endif

/* Dataspace Interface */
cdecl_const(H5S_ALL)
cdecl_const(H5S_UNLIMITED)

cdecl_const(H5S_MAX_RANK)

cdecl_type(H5S_class_t)
cdecl_memb(H5S_class_t)

cdecl_type(H5S_seloper_t)
cdecl_memb(H5S_seloper_t)

cdecl_type(H5S_sel_type)
cdecl_memb(H5S_sel_type)

cdecl_func(H5Screate)
cdecl_func(H5Screate_simple)
cdecl_func(H5Sset_extent_simple)
cdecl_func(H5Scopy)
cdecl_func(H5Sclose)
cdecl_func(H5Sencode)
cdecl_func(H5Sdecode)
cdecl_func(H5Sget_simple_extent_npoints)
cdecl_func(H5Sget_simple_extent_ndims)
cdecl_func(H5Sget_simple_extent_dims)
cdecl_func(H5Sis_simple)
cdecl_func(H5Sget_select_npoints)
cdecl_func(H5Sselect_hyperslab)
#if NEW_HYPERSLAB_API
cdecl_func(H5Scombine_hyperslab)
cdecl_func(H5Sselect_select)
cdecl_func(H5Scombine_select)
#endif
cdecl_func(H5Sselect_elements)
cdecl_func(H5Sget_simple_extent_type)
cdecl_func(H5Sset_extent_none)
cdecl_func(H5Sextent_copy)
cdecl_func(H5Sextent_equal)
cdecl_func(H5Sselect_all)
cdecl_func(H5Sselect_none)
cdecl_func(H5Soffset_simple)
cdecl_func(H5Sselect_valid)
cdecl_func(H5Sget_select_hyper_nblocks)
cdecl_func(H5Sget_select_elem_npoints)
cdecl_func(H5Sget_select_hyper_blocklist)
cdecl_func(H5Sget_select_elem_pointlist)
cdecl_func(H5Sget_select_bounds)
cdecl_func(H5Sget_select_type)

/* Datatype Interface */
cdecl_type(H5T_class_t)
cdecl_memb(H5T_class_t)

cdecl_type(H5T_order_t)
cdecl_memb(H5T_order_t)

cdecl_type(H5T_sign_t)
cdecl_memb(H5T_sign_t)

cdecl_type(H5T_norm_t)
cdecl_memb(H5T_norm_t)

cdecl_type(H5T_cset_t)
cdecl_memb(H5T_cset_t)

cdecl_type(H5T_str_t)
cdecl_memb(H5T_str_t)

cdecl_type(H5T_pad_t)
cdecl_memb(H5T_pad_t)

cdecl_type(H5T_cmd_t)
cdecl_memb(H5T_cmd_t)

cdecl_type(H5T_bkg_t)
cdecl_memb(H5T_bkg_t)

cdecl_type(H5T_pers_t)
cdecl_memb(H5T_pers_t)

cdecl_type(H5T_direction_t)
cdecl_memb(H5T_direction_t)

cdecl_type(H5T_conv_except_t)
cdecl_memb(H5T_conv_except_t)

cdecl_type(H5T_conv_ret_t)
cdecl_memb(H5T_conv_ret_t)

cdecl_type(H5T_cdata_t)
cdecl_memb(H5T_cdata_t)

cdecl_type(hvl_t)
cdecl_memb(hvl_t)

cdecl_const(H5T_VARIABLE)
cdecl_const(H5T_OPAQUE_TAG_MAX)

cdecl_const(H5T_IEEE_F32BE)
cdecl_const(H5T_IEEE_F32LE)
cdecl_const(H5T_IEEE_F64BE)
cdecl_const(H5T_IEEE_F64LE)

cdecl_const(H5T_STD_I8BE)
cdecl_const(H5T_STD_I8LE)
cdecl_const(H5T_STD_I16BE)
cdecl_const(H5T_STD_I16LE)
cdecl_const(H5T_STD_I32BE)
cdecl_const(H5T_STD_I32LE)
cdecl_const(H5T_STD_I64BE)
cdecl_const(H5T_STD_I64LE)
cdecl_const(H5T_STD_U8BE)
cdecl_const(H5T_STD_U8LE)
cdecl_const(H5T_STD_U16BE)
cdecl_const(H5T_STD_U16LE)
cdecl_const(H5T_STD_U32BE)
cdecl_const(H5T_STD_U32LE)
cdecl_const(H5T_STD_U64BE)
cdecl_const(H5T_STD_U64LE)
cdecl_const(H5T_STD_B8BE)
cdecl_const(H5T_STD_B8LE)
cdecl_const(H5T_STD_B16BE)
cdecl_const(H5T_STD_B16LE)
cdecl_const(H5T_STD_B32BE)
cdecl_const(H5T_STD_B32LE)
cdecl_const(H5T_STD_B64BE)
cdecl_const(H5T_STD_B64LE)
cdecl_const(H5T_STD_REF_OBJ)
cdecl_const(H5T_STD_REF_DSETREG)

cdecl_const(H5T_UNIX_D32BE)
cdecl_const(H5T_UNIX_D32LE)
cdecl_const(H5T_UNIX_D64BE)
cdecl_const(H5T_UNIX_D64LE)

cdecl_const(H5T_C_S1)

cdecl_const(H5T_FORTRAN_S1)

cdecl_const(H5T_INTEL_I8)
cdecl_const(H5T_INTEL_I16)
cdecl_const(H5T_INTEL_I32)
cdecl_const(H5T_INTEL_I64)
cdecl_const(H5T_INTEL_U8)
cdecl_const(H5T_INTEL_U16)
cdecl_const(H5T_INTEL_U32)
cdecl_const(H5T_INTEL_U64)
cdecl_const(H5T_INTEL_B8)
cdecl_const(H5T_INTEL_B16)
cdecl_const(H5T_INTEL_B32)
cdecl_const(H5T_INTEL_B64)
cdecl_const(H5T_INTEL_F32)
cdecl_const(H5T_INTEL_F64)

cdecl_const(H5T_ALPHA_I8)
cdecl_const(H5T_ALPHA_I16)
cdecl_const(H5T_ALPHA_I32)
cdecl_const(H5T_ALPHA_I64)
cdecl_const(H5T_ALPHA_U8)
cdecl_const(H5T_ALPHA_U16)
cdecl_const(H5T_ALPHA_U32)
cdecl_const(H5T_ALPHA_U64)
cdecl_const(H5T_ALPHA_B8)
cdecl_const(H5T_ALPHA_B16)
cdecl_const(H5T_ALPHA_B32)
cdecl_const(H5T_ALPHA_B64)
cdecl_const(H5T_ALPHA_F32)
cdecl_const(H5T_ALPHA_F64)

cdecl_const(H5T_MIPS_I8)
cdecl_const(H5T_MIPS_I16)
cdecl_const(H5T_MIPS_I32)
cdecl_const(H5T_MIPS_I64)
cdecl_const(H5T_MIPS_U8)
cdecl_const(H5T_MIPS_U16)
cdecl_const(H5T_MIPS_U32)
cdecl_const(H5T_MIPS_U64)
cdecl_const(H5T_MIPS_B8)
cdecl_const(H5T_MIPS_B16)
cdecl_const(H5T_MIPS_B32)
cdecl_const(H5T_MIPS_B64)
cdecl_const(H5T_MIPS_F32)
cdecl_const(H5T_MIPS_F64)

cdecl_const(H5T_VAX_F32)
cdecl_const(H5T_VAX_F64)

cdecl_const(H5T_NATIVE_CHAR)
cdecl_const(H5T_NATIVE_SCHAR)
cdecl_const(H5T_NATIVE_UCHAR)
cdecl_const(H5T_NATIVE_SHORT)
cdecl_const(H5T_NATIVE_USHORT)
cdecl_const(H5T_NATIVE_INT)
cdecl_const(H5T_NATIVE_UINT)
cdecl_const(H5T_NATIVE_LONG)
cdecl_const(H5T_NATIVE_ULONG)
cdecl_const(H5T_NATIVE_LLONG)
cdecl_const(H5T_NATIVE_ULLONG)
cdecl_const(H5T_NATIVE_FLOAT)
cdecl_const(H5T_NATIVE_DOUBLE)
cdecl_const(H5T_NATIVE_LDOUBLE)
cdecl_const(H5T_NATIVE_B8)
cdecl_const(H5T_NATIVE_B16)
cdecl_const(H5T_NATIVE_B32)
cdecl_const(H5T_NATIVE_B64)
cdecl_const(H5T_NATIVE_OPAQUE)
cdecl_const(H5T_NATIVE_HADDR)
cdecl_const(H5T_NATIVE_HSIZE)
cdecl_const(H5T_NATIVE_HSSIZE)
cdecl_const(H5T_NATIVE_HERR)
cdecl_const(H5T_NATIVE_HBOOL)

cdecl_const(H5T_NATIVE_INT8)
cdecl_const(H5T_NATIVE_UINT8)
cdecl_const(H5T_NATIVE_INT_LEAST8)
cdecl_const(H5T_NATIVE_UINT_LEAST8)
cdecl_const(H5T_NATIVE_INT_FAST8)
cdecl_const(H5T_NATIVE_UINT_FAST8)

cdecl_const(H5T_NATIVE_INT16)
cdecl_const(H5T_NATIVE_UINT16)
cdecl_const(H5T_NATIVE_INT_LEAST16)
cdecl_const(H5T_NATIVE_UINT_LEAST16)
cdecl_const(H5T_NATIVE_INT_FAST16)
cdecl_const(H5T_NATIVE_UINT_FAST16)

cdecl_const(H5T_NATIVE_INT32)
cdecl_const(H5T_NATIVE_UINT32)
cdecl_const(H5T_NATIVE_INT_LEAST32)
cdecl_const(H5T_NATIVE_UINT_LEAST32)
cdecl_const(H5T_NATIVE_INT_FAST32)
cdecl_const(H5T_NATIVE_UINT_FAST32)

cdecl_const(H5T_NATIVE_INT64)
cdecl_const(H5T_NATIVE_UINT64)
cdecl_const(H5T_NATIVE_INT_LEAST64)
cdecl_const(H5T_NATIVE_UINT_LEAST64)
cdecl_const(H5T_NATIVE_INT_FAST64)
cdecl_const(H5T_NATIVE_UINT_FAST64)

cdecl_type(H5T_conv_t)
cdecl_type(H5T_conv_except_func_t)

cdecl_func(H5Tcreate)
cdecl_func(H5Tcopy)
cdecl_func(H5Tclose)
cdecl_func(H5Tequal)
cdecl_func(H5Tlock)
cdecl_func(H5Tcommit)
cdecl_func(H5Topen)
cdecl_func(H5Tcommit_anon)
cdecl_func(H5Tget_create_plist)
cdecl_func(H5Tcommitted)
cdecl_func(H5Tencode)
cdecl_func(H5Tdecode)

cdecl_func(H5Tinsert)
cdecl_func(H5Tpack)

cdecl_func(H5Tenum_create)
cdecl_func(H5Tenum_insert)
cdecl_func(H5Tenum_nameof)
cdecl_func(H5Tenum_valueof)

cdecl_func(H5Tvlen_create)

cdecl_func(H5Tarray_create)
cdecl_func(H5Tget_array_ndims)
cdecl_func(H5Tget_array_dims)

cdecl_func(H5Tset_tag)
cdecl_func(H5Tget_tag)

cdecl_func(H5Tget_super)
cdecl_func(H5Tget_class)
cdecl_func(H5Tdetect_class)
cdecl_func(H5Tget_size)
cdecl_func(H5Tget_order)
cdecl_func(H5Tget_precision)
cdecl_func(H5Tget_offset)
cdecl_func(H5Tget_pad)
cdecl_func(H5Tget_sign)
cdecl_func(H5Tget_fields)
cdecl_func(H5Tget_ebias)
cdecl_func(H5Tget_norm)
cdecl_func(H5Tget_inpad)
cdecl_func(H5Tget_strpad)
cdecl_func(H5Tget_nmembers)
cdecl_func(H5Tget_member_name)
cdecl_func(H5Tget_member_index)
cdecl_func(H5Tget_member_offset)
cdecl_func(H5Tget_member_class)
cdecl_func(H5Tget_member_type)
cdecl_func(H5Tget_member_value)
cdecl_func(H5Tget_cset)
cdecl_func(H5Tis_variable_str)
cdecl_func(H5Tget_native_type)

cdecl_func(H5Tset_size)
cdecl_func(H5Tset_order)
cdecl_func(H5Tset_precision)
cdecl_func(H5Tset_offset)
cdecl_func(H5Tset_pad)
cdecl_func(H5Tset_sign)
cdecl_func(H5Tset_fields)
cdecl_func(H5Tset_ebias)
cdecl_func(H5Tset_norm)
cdecl_func(H5Tset_inpad)
cdecl_func(H5Tset_cset)
cdecl_func(H5Tset_strpad)

cdecl_func(H5Tregister)
cdecl_func(H5Tunregister)
cdecl_func(H5Tfind)
cdecl_func(H5Tcompiler_conv)
cdecl_func(H5Tconvert)

/* Link Interface */
cdecl_const(H5L_SAME_LOC)
cdecl_const(H5L_LINK_CLASS_T_VERS)

cdecl_type(H5L_type_t)
cdecl_memb(H5L_type_t)

cdecl_const(H5L_TYPE_UD_MIN)

cdecl_type(H5L_info_t)
cdecl_memb(H5L_info_t)

cdecl_type(H5L_create_func_t)
cdecl_type(H5L_move_func_t)
cdecl_type(H5L_copy_func_t)
cdecl_type(H5L_traverse_func_t)
cdecl_type(H5L_delete_func_t)
cdecl_type(H5L_query_func_t)

cdecl_type(H5L_class_t)
cdecl_memb(H5L_class_t)

cdecl_type(H5L_iterate_t)
#if H5_VERSION_GE(1, 8, 3)
cdecl_type(H5L_elink_traverse_t)
#endif

cdecl_func(H5Lmove)
cdecl_func(H5Lcopy)
cdecl_func(H5Lcreate_hard)
cdecl_func(H5Lcreate_soft)
cdecl_func(H5Ldelete)
cdecl_func(H5Ldelete_by_idx)
cdecl_func(H5Lget_val)
cdecl_func(H5Lget_val_by_idx)
cdecl_func(H5Lexists)
cdecl_func(H5Lget_info)
cdecl_func(H5Lget_info_by_idx)
cdecl_func(H5Lget_name_by_idx)
cdecl_func(H5Literate)
cdecl_func(H5Literate_by_name)
cdecl_func(H5Lvisit)
cdecl_func(H5Lvisit_by_name)

cdecl_func(H5Lcreate_ud)
cdecl_func(H5Lregister)
cdecl_func(H5Lunregister)
cdecl_func(H5Lis_registered)

cdecl_func(H5Lunpack_elink_val)
cdecl_func(H5Lcreate_external)

/* Object Interface */
cdecl_const(H5O_COPY_SHALLOW_HIERARCHY_FLAG)
cdecl_const(H5O_COPY_EXPAND_SOFT_LINK_FLAG)
cdecl_const(H5O_COPY_EXPAND_EXT_LINK_FLAG)
cdecl_const(H5O_COPY_EXPAND_REFERENCE_FLAG)
cdecl_const(H5O_COPY_WITHOUT_ATTR_FLAG)
cdecl_const(H5O_COPY_PRESERVE_NULL_FLAG)
#if H5_VERSION_GE(1, 8, 9)
cdecl_const(H5O_COPY_MERGE_COMMITTED_DTYPE_FLAG)
#endif
cdecl_const(H5O_COPY_ALL)

cdecl_const(H5O_SHMESG_NONE_FLAG)
cdecl_const(H5O_SHMESG_SDSPACE_FLAG)
cdecl_const(H5O_SHMESG_DTYPE_FLAG)
cdecl_const(H5O_SHMESG_FILL_FLAG)
cdecl_const(H5O_SHMESG_PLINE_FLAG)
cdecl_const(H5O_SHMESG_ATTR_FLAG)
cdecl_const(H5O_SHMESG_ALL_FLAG)

cdecl_const(H5O_HDR_CHUNK0_SIZE)
cdecl_const(H5O_HDR_ATTR_CRT_ORDER_TRACKED)
cdecl_const(H5O_HDR_ATTR_CRT_ORDER_INDEXED)
cdecl_const(H5O_HDR_ATTR_STORE_PHASE_CHANGE)
cdecl_const(H5O_HDR_STORE_TIMES)
cdecl_const(H5O_HDR_ALL_FLAGS)

cdecl_const(H5O_SHMESG_MAX_NINDEXES)
cdecl_const(H5O_SHMESG_MAX_LIST_SIZE)

cdecl_type(H5O_type_t)
cdecl_memb(H5O_type_t)

#if H5_VERSION_GE(1, 8, 4)
cdecl_type(H5O_hdr_info_t)
cdecl_memb(H5O_hdr_info_t)
#endif

cdecl_type(H5O_info_t)
cdecl_memb(H5O_info_t)

cdecl_typealias(H5O_msg_crt_idx_t, uint32_t)

cdecl_type(H5O_iterate_t)

#if H5_VERSION_GE(1, 8, 9)
cdecl_type(H5O_mcdt_search_ret_t)

cdecl_type(H5O_mcdt_search_cb_t)

#endif
cdecl_func(H5Oopen)
cdecl_func(H5Oopen_by_addr)
cdecl_func(H5Oopen_by_idx)
#if H5_VERSION_GE(1, 8, 5)
cdecl_func(H5Oexists_by_name)
#endif
cdecl_func(H5Oget_info)
cdecl_func(H5Oget_info_by_name)
cdecl_func(H5Oget_info_by_idx)
cdecl_func(H5Olink)
cdecl_func(H5Oincr_refcount)
cdecl_func(H5Odecr_refcount)
cdecl_func(H5Ocopy)
cdecl_func(H5Oset_comment)
cdecl_func(H5Oset_comment_by_name)
cdecl_func(H5Oget_comment)
cdecl_func(H5Oget_comment_by_name)
cdecl_func(H5Ovisit)
cdecl_func(H5Ovisit_by_name)
cdecl_func(H5Oclose)

/* Group Interface */
cdecl_type(H5G_storage_type_t)
cdecl_memb(H5G_storage_type_t)

cdecl_type(H5G_info_t)
cdecl_memb(H5G_info_t)

cdecl_func(H5Gcreate)
cdecl_func(H5Gcreate_anon)
cdecl_func(H5Gopen)
cdecl_func(H5Gget_create_plist)
cdecl_func(H5Gget_info)
cdecl_func(H5Gget_info_by_name)
cdecl_func(H5Gget_info_by_idx)
cdecl_func(H5Gclose)

/* Attribute Interface */
cdecl_type(H5A_info_t)
cdecl_memb(H5A_info_t)

cdecl_type(H5A_operator_t)

cdecl_func(H5Acreate)
cdecl_func(H5Acreate_by_name)
cdecl_func(H5Aopen)
cdecl_func(H5Aopen_by_name)
cdecl_func(H5Aopen_by_idx)
cdecl_func(H5Awrite)
cdecl_func(H5Aread)
cdecl_func(H5Aclose)
cdecl_func(H5Aget_space)
cdecl_func(H5Aget_type)
cdecl_func(H5Aget_create_plist)
cdecl_func(H5Aget_name)
cdecl_func(H5Aget_name_by_idx)
cdecl_func(H5Aget_storage_size)
cdecl_func(H5Aget_info)
cdecl_func(H5Aget_info_by_name)
cdecl_func(H5Aget_info_by_idx)
cdecl_func(H5Arename)
cdecl_func(H5Arename_by_name)
cdecl_func(H5Aiterate)
cdecl_func(H5Aiterate_by_name)
cdecl_func(H5Adelete)
cdecl_func(H5Adelete_by_name)
cdecl_func(H5Adelete_by_idx)
cdecl_func(H5Aexists)
cdecl_func(H5Aexists_by_name)

/* Dataset Interface */
#if H5_VERSION_GE(1, 8, 3)
cdecl_const(H5D_CHUNK_CACHE_NSLOTS_DEFAULT)
cdecl_const(H5D_CHUNK_CACHE_NBYTES_DEFAULT)
cdecl_const(H5D_CHUNK_CACHE_W0_DEFAULT)
#endif

cdecl_type(H5D_layout_t)
cdecl_memb(H5D_layout_t)

#if H5_VERSION_GE(1, 8, 3)
cdecl_type(H5D_chunk_index_t)
cdecl_memb(H5D_chunk_index_t)
#endif

cdecl_type(H5D_alloc_time_t)
cdecl_memb(H5D_alloc_time_t)

cdecl_type(H5D_space_status_t)
cdecl_memb(H5D_space_status_t)

cdecl_type(H5D_fill_time_t)
cdecl_memb(H5D_fill_time_t)

cdecl_type(H5D_fill_value_t)
cdecl_memb(H5D_fill_value_t)

cdecl_type(H5D_operator_t)
#if H5_VERSION_GE(1, 8, 11)
cdecl_type(H5D_scatter_func_t)
cdecl_type(H5D_gather_func_t)
#endif

cdecl_func(H5Dcreate)
cdecl_func(H5Dcreate_anon)
cdecl_func(H5Dopen)
cdecl_func(H5Dclose)
cdecl_func(H5Dget_space)
cdecl_func(H5Dget_space_status)
cdecl_func(H5Dget_type)
cdecl_func(H5Dget_create_plist)
#if H5_VERSION_GE(1, 8, 3)
cdecl_func(H5Dget_access_plist)
#endif
cdecl_func(H5Dget_storage_size)
cdecl_func(H5Dget_offset)
cdecl_func(H5Dread)
cdecl_func(H5Dwrite)
cdecl_func(H5Diterate)
cdecl_func(H5Dvlen_reclaim)
cdecl_func(H5Dvlen_get_buf_size)
cdecl_func(H5Dfill)
cdecl_func(H5Dset_extent)
#if H5_VERSION_GE(1, 8, 11)
cdecl_func(H5Dscatter)
cdecl_func(H5Dgather)
#endif
cdecl_func(H5Ddebug)

/* Reference Interface */
cdecl_type(H5R_type_t)
cdecl_memb(H5R_type_t)

cdecl_typealias(hobj_ref_t, haddr_t)
cdecl_type(hdset_reg_ref_t)

cdecl_func(H5Rcreate)
cdecl_func(H5Rdereference)
cdecl_func(H5Rget_region)
cdecl_func(H5Rget_obj_type)
cdecl_func(H5Rget_name)

/* Filter and Compression Interface */
cdecl_type(H5Z_filter_t)

cdecl_const(H5Z_FILTER_ERROR)
cdecl_const(H5Z_FILTER_NONE)
cdecl_const(H5Z_FILTER_DEFLATE)
cdecl_const(H5Z_FILTER_SHUFFLE)
cdecl_const(H5Z_FILTER_FLETCHER32)
cdecl_const(H5Z_FILTER_SZIP)
cdecl_const(H5Z_FILTER_NBIT)
cdecl_const(H5Z_FILTER_SCALEOFFSET)
cdecl_const(H5Z_FILTER_RESERVED)
cdecl_const(H5Z_FILTER_MAX)

cdecl_const(H5Z_FILTER_ALL)
cdecl_const(H5Z_MAX_NFILTERS)

cdecl_const(H5Z_FLAG_DEFMASK)
cdecl_const(H5Z_FLAG_MANDATORY)
cdecl_const(H5Z_FLAG_OPTIONAL)

cdecl_const(H5Z_FLAG_INVMASK)
cdecl_const(H5Z_FLAG_REVERSE)
cdecl_const(H5Z_FLAG_SKIP_EDC)

cdecl_const(H5_SZIP_ALLOW_K13_OPTION_MASK)
cdecl_const(H5_SZIP_CHIP_OPTION_MASK)
cdecl_const(H5_SZIP_EC_OPTION_MASK)
cdecl_const(H5_SZIP_NN_OPTION_MASK)
cdecl_const(H5_SZIP_MAX_PIXELS_PER_BLOCK)

cdecl_const(H5Z_SHUFFLE_USER_NPARMS)
cdecl_const(H5Z_SHUFFLE_TOTAL_NPARMS)

cdecl_const(H5Z_SZIP_USER_NPARMS)
cdecl_const(H5Z_SZIP_TOTAL_NPARMS)
cdecl_const(H5Z_SZIP_PARM_MASK)
cdecl_const(H5Z_SZIP_PARM_PPB)
cdecl_const(H5Z_SZIP_PARM_BPP)
cdecl_const(H5Z_SZIP_PARM_PPS)

cdecl_const(H5Z_NBIT_USER_NPARMS)

cdecl_const(H5Z_SCALEOFFSET_USER_NPARMS)

cdecl_const(H5Z_SO_INT_MINBITS_DEFAULT)
cdecl_type(H5Z_SO_scale_type_t)
cdecl_memb(H5Z_SO_scale_type_t)

cdecl_const(H5Z_CLASS_T_VERS)

cdecl_type(H5Z_EDC_t)
cdecl_memb(H5Z_EDC_t)

cdecl_const(H5Z_FILTER_CONFIG_ENCODE_ENABLED)
cdecl_const(H5Z_FILTER_CONFIG_DECODE_ENABLED)

cdecl_type(H5Z_cb_return_t)
cdecl_memb(H5Z_cb_return_t)

cdecl_type(H5Z_filter_func_t)

cdecl_type(H5Z_cb_t)
cdecl_memb(H5Z_cb_t)

cdecl_type(H5Z_can_apply_func_t)

cdecl_type(H5Z_set_local_func_t)

cdecl_type(H5Z_func_t)

cdecl_type(H5Z_class_t)
cdecl_memb(H5Z_class_t)

cdecl_func(H5Zregister)
cdecl_func(H5Zunregister)
cdecl_func(H5Zfilter_avail)
cdecl_func(H5Zget_filter_info)

/* Memory Management Interface */
cdecl_type(H5MM_allocate_t)
cdecl_type(H5MM_free_t)

/* Property List Interface */
cdecl_const(H5P_ROOT)
cdecl_const(H5P_OBJECT_CREATE)
cdecl_const(H5P_FILE_CREATE)
cdecl_const(H5P_FILE_ACCESS)
cdecl_const(H5P_DATASET_CREATE)
cdecl_const(H5P_DATASET_ACCESS)
cdecl_const(H5P_DATASET_XFER)
cdecl_const(H5P_FILE_MOUNT)
cdecl_const(H5P_GROUP_CREATE)
cdecl_const(H5P_GROUP_ACCESS)
cdecl_const(H5P_DATATYPE_CREATE)
cdecl_const(H5P_DATATYPE_ACCESS)
cdecl_const(H5P_STRING_CREATE)
cdecl_const(H5P_ATTRIBUTE_CREATE)
cdecl_const(H5P_OBJECT_COPY)
cdecl_const(H5P_LINK_CREATE)
cdecl_const(H5P_LINK_ACCESS)

cdecl_const(H5P_FILE_CREATE_DEFAULT)
cdecl_const(H5P_FILE_ACCESS_DEFAULT)
cdecl_const(H5P_DATASET_CREATE_DEFAULT)
cdecl_const(H5P_DATASET_ACCESS_DEFAULT)
cdecl_const(H5P_DATASET_XFER_DEFAULT)
cdecl_const(H5P_FILE_MOUNT_DEFAULT)
cdecl_const(H5P_GROUP_CREATE_DEFAULT)
cdecl_const(H5P_GROUP_ACCESS_DEFAULT)
cdecl_const(H5P_DATATYPE_CREATE_DEFAULT)
cdecl_const(H5P_DATATYPE_ACCESS_DEFAULT)
cdecl_const(H5P_ATTRIBUTE_CREATE_DEFAULT)
cdecl_const(H5P_OBJECT_COPY_DEFAULT)
cdecl_const(H5P_LINK_CREATE_DEFAULT)
cdecl_const(H5P_LINK_ACCESS_DEFAULT)

cdecl_const(H5P_CRT_ORDER_TRACKED)
cdecl_const(H5P_CRT_ORDER_INDEXED)

cdecl_type(H5P_cls_create_func_t)
cdecl_type(H5P_cls_copy_func_t)
cdecl_type(H5P_cls_close_func_t)

cdecl_type(H5P_prp_cb1_t)
cdecl_type(H5P_prp_cb2_t)
cdecl_type(H5P_prp_create_func_t)
cdecl_type(H5P_prp_set_func_t)
cdecl_type(H5P_prp_get_func_t)
cdecl_type(H5P_prp_delete_func_t)
cdecl_type(H5P_prp_copy_func_t)
cdecl_type(H5P_prp_compare_func_t)
cdecl_type(H5P_prp_close_func_t)

cdecl_type(H5P_iterate_t)

#if H5_VERSION_GE(1, 8, 8)
cdecl_type(H5D_mpio_actual_chunk_opt_mode_t)
cdecl_memb(H5D_mpio_actual_chunk_opt_mode_t)
cdecl_type(H5D_mpio_actual_io_mode_t)
cdecl_memb(H5D_mpio_actual_io_mode_t)
#endif
#if H5_VERSION_GE(1, 8, 10)
cdecl_type(H5D_mpio_no_collective_cause_t)
#endif

cdecl_func(H5Pcreate_class)
cdecl_func(H5Pget_class_name)
cdecl_func(H5Pcreate)
cdecl_func(H5Pregister)
cdecl_func(H5Pinsert)
cdecl_func(H5Pset)
cdecl_func(H5Pexist)
cdecl_func(H5Pget_size)
cdecl_func(H5Pget_nprops)
cdecl_func(H5Pget_class)
cdecl_func(H5Pget_class_parent)
cdecl_func(H5Pget)
cdecl_func(H5Pequal)
cdecl_func(H5Pisa_class)
cdecl_func(H5Piterate)
cdecl_func(H5Pcopy_prop)
cdecl_func(H5Premove)
cdecl_func(H5Punregister)
cdecl_func(H5Pclose_class)
cdecl_func(H5Pclose)
cdecl_func(H5Pcopy)

cdecl_func(H5Pset_attr_phase_change)
cdecl_func(H5Pget_attr_phase_change)
cdecl_func(H5Pset_attr_creation_order)
cdecl_func(H5Pget_attr_creation_order)
cdecl_func(H5Pset_obj_track_times)
cdecl_func(H5Pget_obj_track_times)
cdecl_func(H5Pmodify_filter)
cdecl_func(H5Pset_filter)
cdecl_func(H5Pget_nfilters)
cdecl_func(H5Pget_filter)
cdecl_func(H5Pget_filter_by_id)
cdecl_func(H5Pall_filters_avail)
cdecl_func(H5Premove_filter)
cdecl_func(H5Pset_deflate)
cdecl_func(H5Pset_fletcher32)

cdecl_func(H5Pget_version)
cdecl_func(H5Pset_userblock)
cdecl_func(H5Pget_userblock)
cdecl_func(H5Pset_sizes)
cdecl_func(H5Pget_sizes)
cdecl_func(H5Pset_sym_k)
cdecl_func(H5Pget_sym_k)
cdecl_func(H5Pset_istore_k)
cdecl_func(H5Pget_istore_k)
cdecl_func(H5Pset_shared_mesg_nindexes)
cdecl_func(H5Pget_shared_mesg_nindexes)
cdecl_func(H5Pset_shared_mesg_index)
cdecl_func(H5Pget_shared_mesg_index)
cdecl_func(H5Pset_shared_mesg_phase_change)
cdecl_func(H5Pget_shared_mesg_phase_change)

cdecl_func(H5Pset_alignment)
cdecl_func(H5Pget_alignment)
cdecl_func(H5Pset_driver)
cdecl_func(H5Pget_driver)
cdecl_func(H5Pget_driver_info)
cdecl_func(H5Pset_family_offset)
cdecl_func(H5Pget_family_offset)
cdecl_func(H5Pset_multi_type)
cdecl_func(H5Pget_multi_type)
cdecl_func(H5Pset_cache)
cdecl_func(H5Pget_cache)
cdecl_func(H5Pset_mdc_config)
cdecl_func(H5Pget_mdc_config)
cdecl_func(H5Pset_gc_references)
cdecl_func(H5Pget_gc_references)
cdecl_func(H5Pset_fclose_degree)
cdecl_func(H5Pget_fclose_degree)
cdecl_func(H5Pset_meta_block_size)
cdecl_func(H5Pget_meta_block_size)
cdecl_func(H5Pset_sieve_buf_size)
cdecl_func(H5Pget_sieve_buf_size)
cdecl_func(H5Pset_small_data_block_size)
cdecl_func(H5Pget_small_data_block_size)
cdecl_func(H5Pset_libver_bounds)
cdecl_func(H5Pget_libver_bounds)
#if H5_VERSION_GE(1, 8, 7)
cdecl_func(H5Pset_elink_file_cache_size)
cdecl_func(H5Pget_elink_file_cache_size)
#endif
#if H5_VERSION_GE(1, 8, 9)
cdecl_func(H5Pset_file_image)
cdecl_func(H5Pget_file_image)
cdecl_type(H5FD_file_image_op_t)
cdecl_type(H5FD_file_image_callbacks_t)
cdecl_func(H5Pset_file_image_callbacks)
cdecl_func(H5Pget_file_image_callbacks)
#endif

cdecl_func(H5Pset_layout)
cdecl_func(H5Pget_layout)
cdecl_func(H5Pset_chunk)
cdecl_func(H5Pget_chunk)
cdecl_func(H5Pset_external)
cdecl_func(H5Pget_external_count)
cdecl_func(H5Pget_external)
cdecl_func(H5Pset_szip)
cdecl_func(H5Pset_shuffle)
cdecl_func(H5Pset_nbit)
cdecl_func(H5Pset_scaleoffset)
cdecl_func(H5Pset_fill_value)
cdecl_func(H5Pget_fill_value)
cdecl_func(H5Pfill_value_defined)
cdecl_func(H5Pset_alloc_time)
cdecl_func(H5Pget_alloc_time)
cdecl_func(H5Pset_fill_time)
cdecl_func(H5Pget_fill_time)

#if H5_VERSION_GE(1, 8, 3)
cdecl_func(H5Pset_chunk_cache)
cdecl_func(H5Pget_chunk_cache)
#endif

cdecl_func(H5Pset_data_transform)
cdecl_func(H5Pget_data_transform)
cdecl_func(H5Pset_buffer)
cdecl_func(H5Pget_buffer)
cdecl_func(H5Pset_preserve)
cdecl_func(H5Pget_preserve)
cdecl_func(H5Pset_edc_check)
cdecl_func(H5Pget_edc_check)
cdecl_func(H5Pset_filter_callback)
cdecl_func(H5Pset_btree_ratios)
cdecl_func(H5Pget_btree_ratios)
cdecl_func(H5Pset_vlen_mem_manager)
cdecl_func(H5Pget_vlen_mem_manager)
cdecl_func(H5Pset_hyper_vector_size)
cdecl_func(H5Pget_hyper_vector_size)
cdecl_func(H5Pset_type_conv_cb)
cdecl_func(H5Pget_type_conv_cb)
#if H5_HAVE_PARALLEL && H5_VERSION_GE(1, 8, 8)
cdecl_func(H5Pget_mpio_actual_chunk_opt_mode)
cdecl_func(H5Pget_mpio_actual_io_mode)
#endif
#if H5_HAVE_PARALLEL && H5_VERSION_GE(1, 8, 10)
cdecl_func(H5Pget_mpio_no_collective_cause)
#endif

cdecl_func(H5Pset_create_intermediate_group)
cdecl_func(H5Pget_create_intermediate_group)

cdecl_func(H5Pset_local_heap_size_hint)
cdecl_func(H5Pget_local_heap_size_hint)
cdecl_func(H5Pset_link_phase_change)
cdecl_func(H5Pget_link_phase_change)
cdecl_func(H5Pset_est_link_info)
cdecl_func(H5Pget_est_link_info)
cdecl_func(H5Pset_link_creation_order)
cdecl_func(H5Pget_link_creation_order)

cdecl_func(H5Pset_char_encoding)
cdecl_func(H5Pget_char_encoding)

cdecl_func(H5Pset_nlinks)
cdecl_func(H5Pget_nlinks)
cdecl_func(H5Pset_elink_prefix)
cdecl_func(H5Pget_elink_prefix)
#if H5_VERSION_GE(1, 8, 2)
cdecl_func(H5Pget_elink_fapl)
cdecl_func(H5Pset_elink_fapl)
#endif
#if H5_VERSION_GE(1, 8, 3)
cdecl_func(H5Pset_elink_acc_flags)
cdecl_func(H5Pget_elink_acc_flags)
cdecl_func(H5Pset_elink_cb)
cdecl_func(H5Pget_elink_cb)
#endif

cdecl_func(H5Pset_copy_object)
cdecl_func(H5Pget_copy_object)
#if H5_VERSION_GE(1, 8, 9)
cdecl_func(H5Padd_merge_committed_dtype_path)
cdecl_func(H5Pfree_merge_committed_dtype_paths)
cdecl_func(H5Pset_mcdt_search_cb)
cdecl_func(H5Pget_mcdt_search_cb)
#endif

#ifdef H5_HAVE_PARALLEL
/* MPI-IO driver */
cdecl_type(H5FD_mpio_xfer_t)
cdecl_memb(H5FD_mpio_xfer_t)
cdecl_type(H5FD_mpio_chunk_opt_t)
cdecl_memb(H5FD_mpio_chunk_opt_t)
cdecl_type(H5FD_mpio_collective_opt_t)
cdecl_memb(H5FD_mpio_collective_opt_t)
cdecl_func(H5Pset_fapl_mpio)
cdecl_func(H5Pget_fapl_mpio)
cdecl_func(H5Pset_dxpl_mpio)
cdecl_func(H5Pget_dxpl_mpio)
cdecl_func(H5Pset_dxpl_mpio_collective_opt)
cdecl_func(H5Pset_dxpl_mpio_chunk_opt)
cdecl_func(H5Pset_dxpl_mpio_chunk_opt_num)
cdecl_func(H5Pset_dxpl_mpio_chunk_opt_ratio)

/* MPI POSIX driver */
cdecl_func(H5Pset_fapl_mpiposix)
cdecl_func(H5Pget_fapl_mpiposix)
#endif
