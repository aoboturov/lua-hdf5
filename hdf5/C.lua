------------------------------------------------------------------------------
-- HDF5 for Lua.
-- Copyright © 2013 Peter Colberg.
-- For conditions of distribution and use, see copyright notice in LICENSE.
------------------------------------------------------------------------------

local ffi = require("ffi")

ffi.cdef[[
typedef int herr_t;
typedef unsigned int hbool_t;
typedef int htri_t;
typedef long long unsigned int hsize_t;
typedef long long int hssize_t;
typedef uint64_t haddr_t;
static const int H5_VERS_MAJOR = 1;
static const int H5_VERS_MINOR = 8;
static const int H5_VERS_RELEASE = 12;
static const int H5P_DEFAULT = 0;
typedef enum H5_iter_order_t H5_iter_order_t;
enum H5_iter_order_t {
  H5_ITER_UNKNOWN = -1,
  H5_ITER_INC = 0,
  H5_ITER_DEC = 1,
  H5_ITER_NATIVE = 2,
  H5_ITER_N = 3,
};
static const int H5_ITER_ERROR = -1;
static const int H5_ITER_CONT = 0;
static const int H5_ITER_STOP = 1;
typedef enum H5_index_t H5_index_t;
enum H5_index_t {
  H5_INDEX_UNKNOWN = -1,
  H5_INDEX_NAME = 0,
  H5_INDEX_CRT_ORDER = 1,
  H5_INDEX_N = 2,
};
typedef struct H5_ih_info_t H5_ih_info_t;
struct H5_ih_info_t {
  hsize_t index_size;
  hsize_t heap_size;
};
herr_t H5open(void);
herr_t H5close(void);
herr_t H5dont_atexit(void);
herr_t H5garbage_collect(void);
herr_t H5set_free_list_limits(int, int, int, int, int, int);
herr_t H5get_libversion(unsigned int *, unsigned int *, unsigned int *);
herr_t H5check_version(unsigned int, unsigned int, unsigned int);
typedef int hid_t;
static const int H5I_INVALID_HID = -1;
typedef enum H5I_type_t H5I_type_t;
enum H5I_type_t {
  H5I_UNINIT = -2,
  H5I_BADID = -1,
  H5I_FILE = 1,
  H5I_GROUP = 2,
  H5I_DATATYPE = 3,
  H5I_DATASPACE = 4,
  H5I_DATASET = 5,
  H5I_ATTR = 6,
  H5I_REFERENCE = 7,
  H5I_VFL = 8,
  H5I_GENPROP_CLS = 9,
  H5I_GENPROP_LST = 10,
  H5I_ERROR_CLASS = 11,
  H5I_ERROR_MSG = 12,
  H5I_ERROR_STACK = 13,
  H5I_NTYPES = 14,
};
typedef herr_t (*H5I_free_t)(void *);
typedef int (*H5I_search_func_t)(void *, hid_t, void *);
hid_t H5Iregister(H5I_type_t, const void *);
void *H5Iobject_verify(hid_t, H5I_type_t);
void *H5Iremove_verify(hid_t, H5I_type_t);
H5I_type_t H5Iget_type(hid_t);
hid_t H5Iget_file_id(hid_t);
ptrdiff_t H5Iget_name(hid_t, char *, size_t);
int H5Iinc_ref(hid_t);
int H5Idec_ref(hid_t);
int H5Iget_ref(hid_t);
H5I_type_t H5Iregister_type(size_t, unsigned int, H5I_free_t);
herr_t H5Iclear_type(H5I_type_t, hbool_t);
herr_t H5Idestroy_type(H5I_type_t);
int H5Iinc_type_ref(H5I_type_t);
int H5Idec_type_ref(H5I_type_t);
int H5Iget_type_ref(H5I_type_t);
void *H5Isearch(H5I_type_t, H5I_search_func_t, void *);
herr_t H5Inmembers(H5I_type_t, hsize_t *);
htri_t H5Itype_exists(H5I_type_t);
htri_t H5Iis_valid(hid_t);
static const int H5E_DEFAULT = 0;
typedef enum H5E_type_t H5E_type_t;
enum H5E_type_t {
  H5E_MAJOR = 0,
  H5E_MINOR = 1,
};
typedef struct H5E_error_t H5E_error_t;
struct H5E_error_t {
  hid_t cls_id;
  hid_t maj_num;
  hid_t min_num;
  unsigned int line;
  const char *func_name;
  const char *file_name;
  const char *desc;
};
extern hid_t H5E_ERR_CLS __asm__("H5E_ERR_CLS_g");
extern hid_t H5E_DATASET __asm__("H5E_DATASET_g");
extern hid_t H5E_FUNC __asm__("H5E_FUNC_g");
extern hid_t H5E_STORAGE __asm__("H5E_STORAGE_g");
extern hid_t H5E_FILE __asm__("H5E_FILE_g");
extern hid_t H5E_SOHM __asm__("H5E_SOHM_g");
extern hid_t H5E_SYM __asm__("H5E_SYM_g");
extern hid_t H5E_PLUGIN __asm__("H5E_PLUGIN_g");
extern hid_t H5E_VFL __asm__("H5E_VFL_g");
extern hid_t H5E_INTERNAL __asm__("H5E_INTERNAL_g");
extern hid_t H5E_BTREE __asm__("H5E_BTREE_g");
extern hid_t H5E_REFERENCE __asm__("H5E_REFERENCE_g");
extern hid_t H5E_DATASPACE __asm__("H5E_DATASPACE_g");
extern hid_t H5E_RESOURCE __asm__("H5E_RESOURCE_g");
extern hid_t H5E_PLIST __asm__("H5E_PLIST_g");
extern hid_t H5E_LINK __asm__("H5E_LINK_g");
extern hid_t H5E_DATATYPE __asm__("H5E_DATATYPE_g");
extern hid_t H5E_RS __asm__("H5E_RS_g");
extern hid_t H5E_HEAP __asm__("H5E_HEAP_g");
extern hid_t H5E_OHDR __asm__("H5E_OHDR_g");
extern hid_t H5E_ATOM __asm__("H5E_ATOM_g");
extern hid_t H5E_ATTR __asm__("H5E_ATTR_g");
extern hid_t H5E_NONE_MAJOR __asm__("H5E_NONE_MAJOR_g");
extern hid_t H5E_IO __asm__("H5E_IO_g");
extern hid_t H5E_SLIST __asm__("H5E_SLIST_g");
extern hid_t H5E_EFL __asm__("H5E_EFL_g");
extern hid_t H5E_TST __asm__("H5E_TST_g");
extern hid_t H5E_ARGS __asm__("H5E_ARGS_g");
extern hid_t H5E_ERROR __asm__("H5E_ERROR_g");
extern hid_t H5E_PLINE __asm__("H5E_PLINE_g");
extern hid_t H5E_FSPACE __asm__("H5E_FSPACE_g");
extern hid_t H5E_CACHE __asm__("H5E_CACHE_g");
extern hid_t H5E_SEEKERROR __asm__("H5E_SEEKERROR_g");
extern hid_t H5E_READERROR __asm__("H5E_READERROR_g");
extern hid_t H5E_WRITEERROR __asm__("H5E_WRITEERROR_g");
extern hid_t H5E_CLOSEERROR __asm__("H5E_CLOSEERROR_g");
extern hid_t H5E_OVERFLOW __asm__("H5E_OVERFLOW_g");
extern hid_t H5E_FCNTL __asm__("H5E_FCNTL_g");
extern hid_t H5E_NOSPACE __asm__("H5E_NOSPACE_g");
extern hid_t H5E_CANTALLOC __asm__("H5E_CANTALLOC_g");
extern hid_t H5E_CANTCOPY __asm__("H5E_CANTCOPY_g");
extern hid_t H5E_CANTFREE __asm__("H5E_CANTFREE_g");
extern hid_t H5E_ALREADYEXISTS __asm__("H5E_ALREADYEXISTS_g");
extern hid_t H5E_CANTLOCK __asm__("H5E_CANTLOCK_g");
extern hid_t H5E_CANTUNLOCK __asm__("H5E_CANTUNLOCK_g");
extern hid_t H5E_CANTGC __asm__("H5E_CANTGC_g");
extern hid_t H5E_CANTGETSIZE __asm__("H5E_CANTGETSIZE_g");
extern hid_t H5E_OBJOPEN __asm__("H5E_OBJOPEN_g");
extern hid_t H5E_CANTRESTORE __asm__("H5E_CANTRESTORE_g");
extern hid_t H5E_CANTCOMPUTE __asm__("H5E_CANTCOMPUTE_g");
extern hid_t H5E_CANTEXTEND __asm__("H5E_CANTEXTEND_g");
extern hid_t H5E_CANTATTACH __asm__("H5E_CANTATTACH_g");
extern hid_t H5E_CANTUPDATE __asm__("H5E_CANTUPDATE_g");
extern hid_t H5E_CANTOPERATE __asm__("H5E_CANTOPERATE_g");
extern hid_t H5E_CANTINIT __asm__("H5E_CANTINIT_g");
extern hid_t H5E_ALREADYINIT __asm__("H5E_ALREADYINIT_g");
extern hid_t H5E_CANTRELEASE __asm__("H5E_CANTRELEASE_g");
extern hid_t H5E_CANTGET __asm__("H5E_CANTGET_g");
extern hid_t H5E_CANTSET __asm__("H5E_CANTSET_g");
extern hid_t H5E_DUPCLASS __asm__("H5E_DUPCLASS_g");
extern hid_t H5E_SETDISALLOWED __asm__("H5E_SETDISALLOWED_g");
extern hid_t H5E_CANTMERGE __asm__("H5E_CANTMERGE_g");
extern hid_t H5E_CANTREVIVE __asm__("H5E_CANTREVIVE_g");
extern hid_t H5E_CANTSHRINK __asm__("H5E_CANTSHRINK_g");
extern hid_t H5E_LINKCOUNT __asm__("H5E_LINKCOUNT_g");
extern hid_t H5E_VERSION __asm__("H5E_VERSION_g");
extern hid_t H5E_ALIGNMENT __asm__("H5E_ALIGNMENT_g");
extern hid_t H5E_BADMESG __asm__("H5E_BADMESG_g");
extern hid_t H5E_CANTDELETE __asm__("H5E_CANTDELETE_g");
extern hid_t H5E_BADITER __asm__("H5E_BADITER_g");
extern hid_t H5E_CANTPACK __asm__("H5E_CANTPACK_g");
extern hid_t H5E_CANTRESET __asm__("H5E_CANTRESET_g");
extern hid_t H5E_CANTRENAME __asm__("H5E_CANTRENAME_g");
extern hid_t H5E_SYSERRSTR __asm__("H5E_SYSERRSTR_g");
extern hid_t H5E_NOFILTER __asm__("H5E_NOFILTER_g");
extern hid_t H5E_CALLBACK __asm__("H5E_CALLBACK_g");
extern hid_t H5E_CANAPPLY __asm__("H5E_CANAPPLY_g");
extern hid_t H5E_SETLOCAL __asm__("H5E_SETLOCAL_g");
extern hid_t H5E_NOENCODER __asm__("H5E_NOENCODER_g");
extern hid_t H5E_CANTFILTER __asm__("H5E_CANTFILTER_g");
extern hid_t H5E_CANTOPENOBJ __asm__("H5E_CANTOPENOBJ_g");
extern hid_t H5E_CANTCLOSEOBJ __asm__("H5E_CANTCLOSEOBJ_g");
extern hid_t H5E_COMPLEN __asm__("H5E_COMPLEN_g");
extern hid_t H5E_PATH __asm__("H5E_PATH_g");
extern hid_t H5E_NONE_MINOR __asm__("H5E_NONE_MINOR_g");
extern hid_t H5E_OPENERROR __asm__("H5E_OPENERROR_g");
extern hid_t H5E_FILEEXISTS __asm__("H5E_FILEEXISTS_g");
extern hid_t H5E_FILEOPEN __asm__("H5E_FILEOPEN_g");
extern hid_t H5E_CANTCREATE __asm__("H5E_CANTCREATE_g");
extern hid_t H5E_CANTOPENFILE __asm__("H5E_CANTOPENFILE_g");
extern hid_t H5E_CANTCLOSEFILE __asm__("H5E_CANTCLOSEFILE_g");
extern hid_t H5E_NOTHDF5 __asm__("H5E_NOTHDF5_g");
extern hid_t H5E_BADFILE __asm__("H5E_BADFILE_g");
extern hid_t H5E_TRUNCATED __asm__("H5E_TRUNCATED_g");
extern hid_t H5E_MOUNT __asm__("H5E_MOUNT_g");
extern hid_t H5E_BADATOM __asm__("H5E_BADATOM_g");
extern hid_t H5E_BADGROUP __asm__("H5E_BADGROUP_g");
extern hid_t H5E_CANTREGISTER __asm__("H5E_CANTREGISTER_g");
extern hid_t H5E_CANTINC __asm__("H5E_CANTINC_g");
extern hid_t H5E_CANTDEC __asm__("H5E_CANTDEC_g");
extern hid_t H5E_NOIDS __asm__("H5E_NOIDS_g");
extern hid_t H5E_CANTFLUSH __asm__("H5E_CANTFLUSH_g");
extern hid_t H5E_CANTSERIALIZE __asm__("H5E_CANTSERIALIZE_g");
extern hid_t H5E_CANTLOAD __asm__("H5E_CANTLOAD_g");
extern hid_t H5E_PROTECT __asm__("H5E_PROTECT_g");
extern hid_t H5E_NOTCACHED __asm__("H5E_NOTCACHED_g");
extern hid_t H5E_SYSTEM __asm__("H5E_SYSTEM_g");
extern hid_t H5E_CANTINS __asm__("H5E_CANTINS_g");
extern hid_t H5E_CANTPROTECT __asm__("H5E_CANTPROTECT_g");
extern hid_t H5E_CANTUNPROTECT __asm__("H5E_CANTUNPROTECT_g");
extern hid_t H5E_CANTPIN __asm__("H5E_CANTPIN_g");
extern hid_t H5E_CANTUNPIN __asm__("H5E_CANTUNPIN_g");
extern hid_t H5E_CANTMARKDIRTY __asm__("H5E_CANTMARKDIRTY_g");
extern hid_t H5E_CANTDIRTY __asm__("H5E_CANTDIRTY_g");
extern hid_t H5E_CANTEXPUNGE __asm__("H5E_CANTEXPUNGE_g");
extern hid_t H5E_CANTRESIZE __asm__("H5E_CANTRESIZE_g");
extern hid_t H5E_TRAVERSE __asm__("H5E_TRAVERSE_g");
extern hid_t H5E_NLINKS __asm__("H5E_NLINKS_g");
extern hid_t H5E_NOTREGISTERED __asm__("H5E_NOTREGISTERED_g");
extern hid_t H5E_CANTMOVE __asm__("H5E_CANTMOVE_g");
extern hid_t H5E_CANTSORT __asm__("H5E_CANTSORT_g");
extern hid_t H5E_MPI __asm__("H5E_MPI_g");
extern hid_t H5E_MPIERRSTR __asm__("H5E_MPIERRSTR_g");
extern hid_t H5E_CANTRECV __asm__("H5E_CANTRECV_g");
extern hid_t H5E_CANTCLIP __asm__("H5E_CANTCLIP_g");
extern hid_t H5E_CANTCOUNT __asm__("H5E_CANTCOUNT_g");
extern hid_t H5E_CANTSELECT __asm__("H5E_CANTSELECT_g");
extern hid_t H5E_CANTNEXT __asm__("H5E_CANTNEXT_g");
extern hid_t H5E_BADSELECT __asm__("H5E_BADSELECT_g");
extern hid_t H5E_CANTCOMPARE __asm__("H5E_CANTCOMPARE_g");
extern hid_t H5E_UNINITIALIZED __asm__("H5E_UNINITIALIZED_g");
extern hid_t H5E_UNSUPPORTED __asm__("H5E_UNSUPPORTED_g");
extern hid_t H5E_BADTYPE __asm__("H5E_BADTYPE_g");
extern hid_t H5E_BADRANGE __asm__("H5E_BADRANGE_g");
extern hid_t H5E_BADVALUE __asm__("H5E_BADVALUE_g");
extern hid_t H5E_NOTFOUND __asm__("H5E_NOTFOUND_g");
extern hid_t H5E_EXISTS __asm__("H5E_EXISTS_g");
extern hid_t H5E_CANTENCODE __asm__("H5E_CANTENCODE_g");
extern hid_t H5E_CANTDECODE __asm__("H5E_CANTDECODE_g");
extern hid_t H5E_CANTSPLIT __asm__("H5E_CANTSPLIT_g");
extern hid_t H5E_CANTREDISTRIBUTE __asm__("H5E_CANTREDISTRIBUTE_g");
extern hid_t H5E_CANTSWAP __asm__("H5E_CANTSWAP_g");
extern hid_t H5E_CANTINSERT __asm__("H5E_CANTINSERT_g");
extern hid_t H5E_CANTLIST __asm__("H5E_CANTLIST_g");
extern hid_t H5E_CANTMODIFY __asm__("H5E_CANTMODIFY_g");
extern hid_t H5E_CANTREMOVE __asm__("H5E_CANTREMOVE_g");
extern hid_t H5E_CANTCONVERT __asm__("H5E_CANTCONVERT_g");
extern hid_t H5E_BADSIZE __asm__("H5E_BADSIZE_g");
typedef enum H5E_direction_t H5E_direction_t;
enum H5E_direction_t {
  H5E_WALK_UPWARD = 0,
  H5E_WALK_DOWNWARD = 1,
};
typedef herr_t (*H5E_walk_t)(unsigned int, const H5E_error_t *, void *);
typedef herr_t (*H5E_auto_t)(hid_t, void *);
hid_t H5Eregister_class(const char *, const char *, const char *);
herr_t H5Eunregister_class(hid_t);
herr_t H5Eclose_msg(hid_t);
hid_t H5Ecreate_msg(hid_t, H5E_type_t, const char *);
hid_t H5Ecreate_stack(void);
hid_t H5Eget_current_stack(void);
herr_t H5Eclose_stack(hid_t);
ptrdiff_t H5Eget_class_name(hid_t, char *, size_t);
herr_t H5Eset_current_stack(hid_t);
herr_t H5Epush(hid_t, const char *, const char *, unsigned int, hid_t, hid_t, hid_t, const char *, ...) __asm__("H5Epush2");
herr_t H5Epop(hid_t, size_t);
herr_t H5Eprint(hid_t, void *) __asm__("H5Eprint2");
herr_t H5Ewalk(hid_t, H5E_direction_t, H5E_walk_t, void *) __asm__("H5Ewalk2");
herr_t H5Eget_auto(hid_t, H5E_auto_t *, void **) __asm__("H5Eget_auto2");
herr_t H5Eset_auto(hid_t, H5E_auto_t, void *) __asm__("H5Eset_auto2");
herr_t H5Eclear(hid_t) __asm__("H5Eclear2");
ptrdiff_t H5Eget_msg(hid_t, H5E_type_t *, char *, size_t);
ptrdiff_t H5Eget_num(hid_t);
enum H5C_cache_incr_mode {
  H5C_incr__off = 0,
  H5C_incr__threshold = 1,
};
enum H5C_cache_flash_incr_mode {
  H5C_flash_incr__off = 0,
  H5C_flash_incr__add_space = 1,
};
enum H5C_cache_decr_mode {
  H5C_decr__off = 0,
  H5C_decr__threshold = 1,
  H5C_decr__age_out = 2,
  H5C_decr__age_out_with_threshold = 3,
};
static const int H5AC__CURR_CACHE_CONFIG_VERSION = 1;
static const int H5AC__MAX_TRACE_FILE_NAME_LEN = 1024;
static const int H5AC_METADATA_WRITE_STRATEGY__PROCESS_0_ONLY = 0;
static const int H5AC_METADATA_WRITE_STRATEGY__DISTRIBUTED = 1;
typedef struct H5AC_cache_config_t H5AC_cache_config_t;
struct H5AC_cache_config_t {
  int version;
  hbool_t rpt_fcn_enabled;
  hbool_t open_trace_file;
  hbool_t close_trace_file;
  char trace_file_name[1025];
  hbool_t evictions_enabled;
  hbool_t set_initial_size;
  size_t initial_size;
  double min_clean_fraction;
  size_t max_size;
  size_t min_size;
  long int epoch_length;
  enum H5C_cache_incr_mode incr_mode;
  double lower_hr_threshold;
  double increment;
  hbool_t apply_max_increment;
  size_t max_increment;
  enum H5C_cache_flash_incr_mode flash_incr_mode;
  double flash_multiple;
  double flash_threshold;
  enum H5C_cache_decr_mode decr_mode;
  double upper_hr_threshold;
  double decrement;
  hbool_t apply_max_decrement;
  size_t max_decrement;
  int epochs_before_eviction;
  hbool_t apply_empty_reserve;
  double empty_reserve;
  int dirty_bytes_threshold;
  int metadata_write_strategy;
};
static const int H5F_ACC_RDONLY = 0;
static const int H5F_ACC_RDWR = 1;
static const int H5F_ACC_TRUNC = 2;
static const int H5F_ACC_EXCL = 4;
static const int H5F_ACC_DEBUG = 8;
static const int H5F_ACC_CREAT = 16;
static const int H5F_ACC_DEFAULT = 65535;
static const int H5F_OBJ_FILE = 1;
static const int H5F_OBJ_DATASET = 2;
static const int H5F_OBJ_GROUP = 4;
static const int H5F_OBJ_DATATYPE = 8;
static const int H5F_OBJ_ATTR = 16;
static const int H5F_OBJ_ALL = 31;
static const int H5F_OBJ_LOCAL = 32;
static const int H5F_FAMILY_DEFAULT = 0;
typedef enum H5F_scope_t H5F_scope_t;
enum H5F_scope_t {
  H5F_SCOPE_LOCAL = 0,
  H5F_SCOPE_GLOBAL = 1,
};
static const int H5F_UNLIMITED = -1;
typedef enum H5F_close_degree_t H5F_close_degree_t;
enum H5F_close_degree_t {
  H5F_CLOSE_DEFAULT = 0,
  H5F_CLOSE_WEAK = 1,
  H5F_CLOSE_SEMI = 2,
  H5F_CLOSE_STRONG = 3,
};
typedef struct H5F_info_t H5F_info_t;
struct H5F_info_t {
  hsize_t super_ext_size;
  struct {
    hsize_t hdr_size;
    H5_ih_info_t msgs_info;
  } sohm;
};
typedef enum H5F_mem_t H5F_mem_t;
enum H5F_mem_t {
  H5FD_MEM_NOLIST = -1,
  H5FD_MEM_DEFAULT = 0,
  H5FD_MEM_SUPER = 1,
  H5FD_MEM_BTREE = 2,
  H5FD_MEM_DRAW = 3,
  H5FD_MEM_GHEAP = 4,
  H5FD_MEM_LHEAP = 5,
  H5FD_MEM_OHDR = 6,
  H5FD_MEM_NTYPES = 7,
};
typedef enum H5F_mem_t H5FD_mem_t;
typedef enum H5F_libver_t H5F_libver_t;
enum H5F_libver_t {
  H5F_LIBVER_EARLIEST = 0,
  H5F_LIBVER_LATEST = 1,
};
static const int H5F_LIBVER_18 = 1;
htri_t H5Fis_hdf5(const char *);
hid_t H5Fcreate(const char *, unsigned int, hid_t, hid_t);
hid_t H5Fopen(const char *, unsigned int, hid_t);
hid_t H5Freopen(hid_t);
herr_t H5Fflush(hid_t, H5F_scope_t);
herr_t H5Fclose(hid_t);
hid_t H5Fget_create_plist(hid_t);
hid_t H5Fget_access_plist(hid_t);
herr_t H5Fget_intent(hid_t, unsigned int *);
ptrdiff_t H5Fget_obj_count(hid_t, unsigned int);
ptrdiff_t H5Fget_obj_ids(hid_t, unsigned int, size_t, hid_t *);
herr_t H5Fget_vfd_handle(hid_t, hid_t, void **);
herr_t H5Fmount(hid_t, const char *, hid_t, hid_t);
herr_t H5Funmount(hid_t, const char *);
hssize_t H5Fget_freespace(hid_t);
herr_t H5Fget_filesize(hid_t, hsize_t *);
ptrdiff_t H5Fget_file_image(hid_t, void *, size_t);
herr_t H5Fget_mdc_config(hid_t, H5AC_cache_config_t *);
herr_t H5Fset_mdc_config(hid_t, H5AC_cache_config_t *);
herr_t H5Fget_mdc_hit_rate(hid_t, double *);
herr_t H5Fget_mdc_size(hid_t, size_t *, size_t *, size_t *, int *);
herr_t H5Freset_mdc_hit_rate_stats(hid_t);
ptrdiff_t H5Fget_name(hid_t, char *, size_t);
herr_t H5Fget_info(hid_t, H5F_info_t *);
herr_t H5Fclear_elink_file_cache(hid_t);
herr_t H5Fset_mpi_atomicity(hid_t, hbool_t);
herr_t H5Fget_mpi_atomicity(hid_t, hbool_t *);
static const int H5S_ALL = 0;
static const int H5S_UNLIMITED = -1;
static const int H5S_MAX_RANK = 32;
typedef enum H5S_class_t H5S_class_t;
enum H5S_class_t {
  H5S_NO_CLASS = -1,
  H5S_SCALAR = 0,
  H5S_SIMPLE = 1,
  H5S_NULL = 2,
};
typedef enum H5S_seloper_t H5S_seloper_t;
enum H5S_seloper_t {
  H5S_SELECT_NOOP = -1,
  H5S_SELECT_SET = 0,
  H5S_SELECT_OR = 1,
  H5S_SELECT_AND = 2,
  H5S_SELECT_XOR = 3,
  H5S_SELECT_NOTB = 4,
  H5S_SELECT_NOTA = 5,
  H5S_SELECT_APPEND = 6,
  H5S_SELECT_PREPEND = 7,
  H5S_SELECT_INVALID = 8,
};
typedef enum H5S_sel_type H5S_sel_type;
enum H5S_sel_type {
  H5S_SEL_ERROR = -1,
  H5S_SEL_NONE = 0,
  H5S_SEL_POINTS = 1,
  H5S_SEL_HYPERSLABS = 2,
  H5S_SEL_ALL = 3,
  H5S_SEL_N = 4,
};
hid_t H5Screate(H5S_class_t);
hid_t H5Screate_simple(int, const hsize_t *, const hsize_t *);
herr_t H5Sset_extent_simple(hid_t, int, const hsize_t *, const hsize_t *);
hid_t H5Scopy(hid_t);
herr_t H5Sclose(hid_t);
herr_t H5Sencode(hid_t, void *, size_t *);
hid_t H5Sdecode(const void *);
hssize_t H5Sget_simple_extent_npoints(hid_t);
int H5Sget_simple_extent_ndims(hid_t);
int H5Sget_simple_extent_dims(hid_t, hsize_t *, hsize_t *);
htri_t H5Sis_simple(hid_t);
hssize_t H5Sget_select_npoints(hid_t);
herr_t H5Sselect_hyperslab(hid_t, H5S_seloper_t, const hsize_t *, const hsize_t *, const hsize_t *, const hsize_t *);
herr_t H5Sselect_elements(hid_t, H5S_seloper_t, size_t, const hsize_t *);
H5S_class_t H5Sget_simple_extent_type(hid_t);
herr_t H5Sset_extent_none(hid_t);
herr_t H5Sextent_copy(hid_t, hid_t);
htri_t H5Sextent_equal(hid_t, hid_t);
herr_t H5Sselect_all(hid_t);
herr_t H5Sselect_none(hid_t);
herr_t H5Soffset_simple(hid_t, const hssize_t *);
htri_t H5Sselect_valid(hid_t);
hssize_t H5Sget_select_hyper_nblocks(hid_t);
hssize_t H5Sget_select_elem_npoints(hid_t);
herr_t H5Sget_select_hyper_blocklist(hid_t, hsize_t, hsize_t, hsize_t *);
herr_t H5Sget_select_elem_pointlist(hid_t, hsize_t, hsize_t, hsize_t *);
herr_t H5Sget_select_bounds(hid_t, hsize_t *, hsize_t *);
H5S_sel_type H5Sget_select_type(hid_t);
typedef enum H5T_class_t H5T_class_t;
enum H5T_class_t {
  H5T_NO_CLASS = -1,
  H5T_INTEGER = 0,
  H5T_FLOAT = 1,
  H5T_TIME = 2,
  H5T_STRING = 3,
  H5T_BITFIELD = 4,
  H5T_OPAQUE = 5,
  H5T_COMPOUND = 6,
  H5T_REFERENCE = 7,
  H5T_ENUM = 8,
  H5T_VLEN = 9,
  H5T_ARRAY = 10,
  H5T_NCLASSES = 11,
};
typedef enum H5T_order_t H5T_order_t;
enum H5T_order_t {
  H5T_ORDER_ERROR = -1,
  H5T_ORDER_LE = 0,
  H5T_ORDER_BE = 1,
  H5T_ORDER_VAX = 2,
  H5T_ORDER_MIXED = 3,
  H5T_ORDER_NONE = 4,
};
typedef enum H5T_sign_t H5T_sign_t;
enum H5T_sign_t {
  H5T_SGN_ERROR = -1,
  H5T_SGN_NONE = 0,
  H5T_SGN_2 = 1,
  H5T_NSGN = 2,
};
typedef enum H5T_norm_t H5T_norm_t;
enum H5T_norm_t {
  H5T_NORM_ERROR = -1,
  H5T_NORM_IMPLIED = 0,
  H5T_NORM_MSBSET = 1,
  H5T_NORM_NONE = 2,
};
typedef enum H5T_cset_t H5T_cset_t;
enum H5T_cset_t {
  H5T_CSET_ERROR = -1,
  H5T_CSET_ASCII = 0,
  H5T_CSET_UTF8 = 1,
  H5T_CSET_RESERVED_2 = 2,
  H5T_CSET_RESERVED_3 = 3,
  H5T_CSET_RESERVED_4 = 4,
  H5T_CSET_RESERVED_5 = 5,
  H5T_CSET_RESERVED_6 = 6,
  H5T_CSET_RESERVED_7 = 7,
  H5T_CSET_RESERVED_8 = 8,
  H5T_CSET_RESERVED_9 = 9,
  H5T_CSET_RESERVED_10 = 10,
  H5T_CSET_RESERVED_11 = 11,
  H5T_CSET_RESERVED_12 = 12,
  H5T_CSET_RESERVED_13 = 13,
  H5T_CSET_RESERVED_14 = 14,
  H5T_CSET_RESERVED_15 = 15,
};
typedef enum H5T_str_t H5T_str_t;
enum H5T_str_t {
  H5T_STR_ERROR = -1,
  H5T_STR_NULLTERM = 0,
  H5T_STR_NULLPAD = 1,
  H5T_STR_SPACEPAD = 2,
  H5T_STR_RESERVED_3 = 3,
  H5T_STR_RESERVED_4 = 4,
  H5T_STR_RESERVED_5 = 5,
  H5T_STR_RESERVED_6 = 6,
  H5T_STR_RESERVED_7 = 7,
  H5T_STR_RESERVED_8 = 8,
  H5T_STR_RESERVED_9 = 9,
  H5T_STR_RESERVED_10 = 10,
  H5T_STR_RESERVED_11 = 11,
  H5T_STR_RESERVED_12 = 12,
  H5T_STR_RESERVED_13 = 13,
  H5T_STR_RESERVED_14 = 14,
  H5T_STR_RESERVED_15 = 15,
};
typedef enum H5T_pad_t H5T_pad_t;
enum H5T_pad_t {
  H5T_PAD_ERROR = -1,
  H5T_PAD_ZERO = 0,
  H5T_PAD_ONE = 1,
  H5T_PAD_BACKGROUND = 2,
  H5T_NPAD = 3,
};
typedef enum H5T_cmd_t H5T_cmd_t;
enum H5T_cmd_t {
  H5T_CONV_INIT = 0,
  H5T_CONV_CONV = 1,
  H5T_CONV_FREE = 2,
};
typedef enum H5T_bkg_t H5T_bkg_t;
enum H5T_bkg_t {
  H5T_BKG_NO = 0,
  H5T_BKG_TEMP = 1,
  H5T_BKG_YES = 2,
};
typedef enum H5T_pers_t H5T_pers_t;
enum H5T_pers_t {
  H5T_PERS_DONTCARE = -1,
  H5T_PERS_HARD = 0,
  H5T_PERS_SOFT = 1,
};
typedef enum H5T_direction_t H5T_direction_t;
enum H5T_direction_t {
  H5T_DIR_DEFAULT = 0,
  H5T_DIR_ASCEND = 1,
  H5T_DIR_DESCEND = 2,
};
typedef enum H5T_conv_except_t H5T_conv_except_t;
enum H5T_conv_except_t {
  H5T_CONV_EXCEPT_RANGE_HI = 0,
  H5T_CONV_EXCEPT_RANGE_LOW = 1,
  H5T_CONV_EXCEPT_PRECISION = 2,
  H5T_CONV_EXCEPT_TRUNCATE = 3,
  H5T_CONV_EXCEPT_PINF = 4,
  H5T_CONV_EXCEPT_NINF = 5,
  H5T_CONV_EXCEPT_NAN = 6,
};
typedef enum H5T_conv_ret_t H5T_conv_ret_t;
enum H5T_conv_ret_t {
  H5T_CONV_ABORT = -1,
  H5T_CONV_UNHANDLED = 0,
  H5T_CONV_HANDLED = 1,
};
typedef struct H5T_cdata_t H5T_cdata_t;
struct H5T_cdata_t {
  H5T_cmd_t command;
  H5T_bkg_t need_bkg;
  hbool_t recalc;
  void *priv;
};
typedef struct hvl_t hvl_t;
struct hvl_t {
  size_t len;
  void *p;
};
static const int H5T_VARIABLE = -1;
static const int H5T_OPAQUE_TAG_MAX = 256;
extern hid_t H5T_IEEE_F32BE __asm__("H5T_IEEE_F32BE_g");
extern hid_t H5T_IEEE_F32LE __asm__("H5T_IEEE_F32LE_g");
extern hid_t H5T_IEEE_F64BE __asm__("H5T_IEEE_F64BE_g");
extern hid_t H5T_IEEE_F64LE __asm__("H5T_IEEE_F64LE_g");
extern hid_t H5T_STD_I8BE __asm__("H5T_STD_I8BE_g");
extern hid_t H5T_STD_I8LE __asm__("H5T_STD_I8LE_g");
extern hid_t H5T_STD_I16BE __asm__("H5T_STD_I16BE_g");
extern hid_t H5T_STD_I16LE __asm__("H5T_STD_I16LE_g");
extern hid_t H5T_STD_I32BE __asm__("H5T_STD_I32BE_g");
extern hid_t H5T_STD_I32LE __asm__("H5T_STD_I32LE_g");
extern hid_t H5T_STD_I64BE __asm__("H5T_STD_I64BE_g");
extern hid_t H5T_STD_I64LE __asm__("H5T_STD_I64LE_g");
extern hid_t H5T_STD_U8BE __asm__("H5T_STD_U8BE_g");
extern hid_t H5T_STD_U8LE __asm__("H5T_STD_U8LE_g");
extern hid_t H5T_STD_U16BE __asm__("H5T_STD_U16BE_g");
extern hid_t H5T_STD_U16LE __asm__("H5T_STD_U16LE_g");
extern hid_t H5T_STD_U32BE __asm__("H5T_STD_U32BE_g");
extern hid_t H5T_STD_U32LE __asm__("H5T_STD_U32LE_g");
extern hid_t H5T_STD_U64BE __asm__("H5T_STD_U64BE_g");
extern hid_t H5T_STD_U64LE __asm__("H5T_STD_U64LE_g");
extern hid_t H5T_STD_B8BE __asm__("H5T_STD_B8BE_g");
extern hid_t H5T_STD_B8LE __asm__("H5T_STD_B8LE_g");
extern hid_t H5T_STD_B16BE __asm__("H5T_STD_B16BE_g");
extern hid_t H5T_STD_B16LE __asm__("H5T_STD_B16LE_g");
extern hid_t H5T_STD_B32BE __asm__("H5T_STD_B32BE_g");
extern hid_t H5T_STD_B32LE __asm__("H5T_STD_B32LE_g");
extern hid_t H5T_STD_B64BE __asm__("H5T_STD_B64BE_g");
extern hid_t H5T_STD_B64LE __asm__("H5T_STD_B64LE_g");
extern hid_t H5T_STD_REF_OBJ __asm__("H5T_STD_REF_OBJ_g");
extern hid_t H5T_STD_REF_DSETREG __asm__("H5T_STD_REF_DSETREG_g");
extern hid_t H5T_UNIX_D32BE __asm__("H5T_UNIX_D32BE_g");
extern hid_t H5T_UNIX_D32LE __asm__("H5T_UNIX_D32LE_g");
extern hid_t H5T_UNIX_D64BE __asm__("H5T_UNIX_D64BE_g");
extern hid_t H5T_UNIX_D64LE __asm__("H5T_UNIX_D64LE_g");
extern hid_t H5T_C_S1 __asm__("H5T_C_S1_g");
extern hid_t H5T_FORTRAN_S1 __asm__("H5T_FORTRAN_S1_g");
extern hid_t H5T_INTEL_I8 __asm__("H5T_STD_I8LE_g");
extern hid_t H5T_INTEL_I16 __asm__("H5T_STD_I16LE_g");
extern hid_t H5T_INTEL_I32 __asm__("H5T_STD_I32LE_g");
extern hid_t H5T_INTEL_I64 __asm__("H5T_STD_I64LE_g");
extern hid_t H5T_INTEL_U8 __asm__("H5T_STD_U8LE_g");
extern hid_t H5T_INTEL_U16 __asm__("H5T_STD_U16LE_g");
extern hid_t H5T_INTEL_U32 __asm__("H5T_STD_U32LE_g");
extern hid_t H5T_INTEL_U64 __asm__("H5T_STD_U64LE_g");
extern hid_t H5T_INTEL_B8 __asm__("H5T_STD_B8LE_g");
extern hid_t H5T_INTEL_B16 __asm__("H5T_STD_B16LE_g");
extern hid_t H5T_INTEL_B32 __asm__("H5T_STD_B32LE_g");
extern hid_t H5T_INTEL_B64 __asm__("H5T_STD_B64LE_g");
extern hid_t H5T_INTEL_F32 __asm__("H5T_IEEE_F32LE_g");
extern hid_t H5T_INTEL_F64 __asm__("H5T_IEEE_F64LE_g");
extern hid_t H5T_ALPHA_I8 __asm__("H5T_STD_I8LE_g");
extern hid_t H5T_ALPHA_I16 __asm__("H5T_STD_I16LE_g");
extern hid_t H5T_ALPHA_I32 __asm__("H5T_STD_I32LE_g");
extern hid_t H5T_ALPHA_I64 __asm__("H5T_STD_I64LE_g");
extern hid_t H5T_ALPHA_U8 __asm__("H5T_STD_U8LE_g");
extern hid_t H5T_ALPHA_U16 __asm__("H5T_STD_U16LE_g");
extern hid_t H5T_ALPHA_U32 __asm__("H5T_STD_U32LE_g");
extern hid_t H5T_ALPHA_U64 __asm__("H5T_STD_U64LE_g");
extern hid_t H5T_ALPHA_B8 __asm__("H5T_STD_B8LE_g");
extern hid_t H5T_ALPHA_B16 __asm__("H5T_STD_B16LE_g");
extern hid_t H5T_ALPHA_B32 __asm__("H5T_STD_B32LE_g");
extern hid_t H5T_ALPHA_B64 __asm__("H5T_STD_B64LE_g");
extern hid_t H5T_ALPHA_F32 __asm__("H5T_IEEE_F32LE_g");
extern hid_t H5T_ALPHA_F64 __asm__("H5T_IEEE_F64LE_g");
extern hid_t H5T_MIPS_I8 __asm__("H5T_STD_I8BE_g");
extern hid_t H5T_MIPS_I16 __asm__("H5T_STD_I16BE_g");
extern hid_t H5T_MIPS_I32 __asm__("H5T_STD_I32BE_g");
extern hid_t H5T_MIPS_I64 __asm__("H5T_STD_I64BE_g");
extern hid_t H5T_MIPS_U8 __asm__("H5T_STD_U8BE_g");
extern hid_t H5T_MIPS_U16 __asm__("H5T_STD_U16BE_g");
extern hid_t H5T_MIPS_U32 __asm__("H5T_STD_U32BE_g");
extern hid_t H5T_MIPS_U64 __asm__("H5T_STD_U64BE_g");
extern hid_t H5T_MIPS_B8 __asm__("H5T_STD_B8BE_g");
extern hid_t H5T_MIPS_B16 __asm__("H5T_STD_B16BE_g");
extern hid_t H5T_MIPS_B32 __asm__("H5T_STD_B32BE_g");
extern hid_t H5T_MIPS_B64 __asm__("H5T_STD_B64BE_g");
extern hid_t H5T_MIPS_F32 __asm__("H5T_IEEE_F32BE_g");
extern hid_t H5T_MIPS_F64 __asm__("H5T_IEEE_F64BE_g");
extern hid_t H5T_VAX_F32 __asm__("H5T_VAX_F32_g");
extern hid_t H5T_VAX_F64 __asm__("H5T_VAX_F64_g");
extern hid_t H5T_NATIVE_CHAR __asm__("H5T_NATIVE_SCHAR_g");
extern hid_t H5T_NATIVE_SCHAR __asm__("H5T_NATIVE_SCHAR_g");
extern hid_t H5T_NATIVE_UCHAR __asm__("H5T_NATIVE_UCHAR_g");
extern hid_t H5T_NATIVE_SHORT __asm__("H5T_NATIVE_SHORT_g");
extern hid_t H5T_NATIVE_USHORT __asm__("H5T_NATIVE_USHORT_g");
extern hid_t H5T_NATIVE_INT __asm__("H5T_NATIVE_INT_g");
extern hid_t H5T_NATIVE_UINT __asm__("H5T_NATIVE_UINT_g");
extern hid_t H5T_NATIVE_LONG __asm__("H5T_NATIVE_LONG_g");
extern hid_t H5T_NATIVE_ULONG __asm__("H5T_NATIVE_ULONG_g");
extern hid_t H5T_NATIVE_LLONG __asm__("H5T_NATIVE_LLONG_g");
extern hid_t H5T_NATIVE_ULLONG __asm__("H5T_NATIVE_ULLONG_g");
extern hid_t H5T_NATIVE_FLOAT __asm__("H5T_NATIVE_FLOAT_g");
extern hid_t H5T_NATIVE_DOUBLE __asm__("H5T_NATIVE_DOUBLE_g");
extern hid_t H5T_NATIVE_LDOUBLE __asm__("H5T_NATIVE_LDOUBLE_g");
extern hid_t H5T_NATIVE_B8 __asm__("H5T_NATIVE_B8_g");
extern hid_t H5T_NATIVE_B16 __asm__("H5T_NATIVE_B16_g");
extern hid_t H5T_NATIVE_B32 __asm__("H5T_NATIVE_B32_g");
extern hid_t H5T_NATIVE_B64 __asm__("H5T_NATIVE_B64_g");
extern hid_t H5T_NATIVE_OPAQUE __asm__("H5T_NATIVE_OPAQUE_g");
extern hid_t H5T_NATIVE_HADDR __asm__("H5T_NATIVE_HADDR_g");
extern hid_t H5T_NATIVE_HSIZE __asm__("H5T_NATIVE_HSIZE_g");
extern hid_t H5T_NATIVE_HSSIZE __asm__("H5T_NATIVE_HSSIZE_g");
extern hid_t H5T_NATIVE_HERR __asm__("H5T_NATIVE_HERR_g");
extern hid_t H5T_NATIVE_HBOOL __asm__("H5T_NATIVE_HBOOL_g");
extern hid_t H5T_NATIVE_INT8 __asm__("H5T_NATIVE_INT8_g");
extern hid_t H5T_NATIVE_UINT8 __asm__("H5T_NATIVE_UINT8_g");
extern hid_t H5T_NATIVE_INT_LEAST8 __asm__("H5T_NATIVE_INT_LEAST8_g");
extern hid_t H5T_NATIVE_UINT_LEAST8 __asm__("H5T_NATIVE_UINT_LEAST8_g");
extern hid_t H5T_NATIVE_INT_FAST8 __asm__("H5T_NATIVE_INT_FAST8_g");
extern hid_t H5T_NATIVE_UINT_FAST8 __asm__("H5T_NATIVE_UINT_FAST8_g");
extern hid_t H5T_NATIVE_INT16 __asm__("H5T_NATIVE_INT16_g");
extern hid_t H5T_NATIVE_UINT16 __asm__("H5T_NATIVE_UINT16_g");
extern hid_t H5T_NATIVE_INT_LEAST16 __asm__("H5T_NATIVE_INT_LEAST16_g");
extern hid_t H5T_NATIVE_UINT_LEAST16 __asm__("H5T_NATIVE_UINT_LEAST16_g");
extern hid_t H5T_NATIVE_INT_FAST16 __asm__("H5T_NATIVE_INT_FAST16_g");
extern hid_t H5T_NATIVE_UINT_FAST16 __asm__("H5T_NATIVE_UINT_FAST16_g");
extern hid_t H5T_NATIVE_INT32 __asm__("H5T_NATIVE_INT32_g");
extern hid_t H5T_NATIVE_UINT32 __asm__("H5T_NATIVE_UINT32_g");
extern hid_t H5T_NATIVE_INT_LEAST32 __asm__("H5T_NATIVE_INT_LEAST32_g");
extern hid_t H5T_NATIVE_UINT_LEAST32 __asm__("H5T_NATIVE_UINT_LEAST32_g");
extern hid_t H5T_NATIVE_INT_FAST32 __asm__("H5T_NATIVE_INT_FAST32_g");
extern hid_t H5T_NATIVE_UINT_FAST32 __asm__("H5T_NATIVE_UINT_FAST32_g");
extern hid_t H5T_NATIVE_INT64 __asm__("H5T_NATIVE_INT64_g");
extern hid_t H5T_NATIVE_UINT64 __asm__("H5T_NATIVE_UINT64_g");
extern hid_t H5T_NATIVE_INT_LEAST64 __asm__("H5T_NATIVE_INT_LEAST64_g");
extern hid_t H5T_NATIVE_UINT_LEAST64 __asm__("H5T_NATIVE_UINT_LEAST64_g");
extern hid_t H5T_NATIVE_INT_FAST64 __asm__("H5T_NATIVE_INT_FAST64_g");
extern hid_t H5T_NATIVE_UINT_FAST64 __asm__("H5T_NATIVE_UINT_FAST64_g");
typedef herr_t (*H5T_conv_t)(hid_t, hid_t, H5T_cdata_t *, size_t, size_t, size_t, void *, void *, hid_t);
typedef H5T_conv_ret_t (*H5T_conv_except_func_t)(H5T_conv_except_t, hid_t, hid_t, void *, void *, void *);
hid_t H5Tcreate(H5T_class_t, size_t);
hid_t H5Tcopy(hid_t);
herr_t H5Tclose(hid_t);
htri_t H5Tequal(hid_t, hid_t);
herr_t H5Tlock(hid_t);
herr_t H5Tcommit(hid_t, const char *, hid_t, hid_t, hid_t, hid_t) __asm__("H5Tcommit2");
hid_t H5Topen(hid_t, const char *, hid_t) __asm__("H5Topen2");
herr_t H5Tcommit_anon(hid_t, hid_t, hid_t, hid_t);
hid_t H5Tget_create_plist(hid_t);
htri_t H5Tcommitted(hid_t);
herr_t H5Tencode(hid_t, void *, size_t *);
hid_t H5Tdecode(const void *);
herr_t H5Tinsert(hid_t, const char *, size_t, hid_t);
herr_t H5Tpack(hid_t);
hid_t H5Tenum_create(hid_t);
herr_t H5Tenum_insert(hid_t, const char *, const void *);
herr_t H5Tenum_nameof(hid_t, const void *, char *, size_t);
herr_t H5Tenum_valueof(hid_t, const char *, void *);
hid_t H5Tvlen_create(hid_t);
hid_t H5Tarray_create(hid_t, unsigned int, const hsize_t *) __asm__("H5Tarray_create2");
int H5Tget_array_ndims(hid_t);
int H5Tget_array_dims(hid_t, hsize_t *) __asm__("H5Tget_array_dims2");
herr_t H5Tset_tag(hid_t, const char *);
char *H5Tget_tag(hid_t);
hid_t H5Tget_super(hid_t);
H5T_class_t H5Tget_class(hid_t);
htri_t H5Tdetect_class(hid_t, H5T_class_t);
size_t H5Tget_size(hid_t);
H5T_order_t H5Tget_order(hid_t);
size_t H5Tget_precision(hid_t);
int H5Tget_offset(hid_t);
herr_t H5Tget_pad(hid_t, H5T_pad_t *, H5T_pad_t *);
H5T_sign_t H5Tget_sign(hid_t);
herr_t H5Tget_fields(hid_t, size_t *, size_t *, size_t *, size_t *, size_t *);
size_t H5Tget_ebias(hid_t);
H5T_norm_t H5Tget_norm(hid_t);
H5T_pad_t H5Tget_inpad(hid_t);
H5T_str_t H5Tget_strpad(hid_t);
int H5Tget_nmembers(hid_t);
char *H5Tget_member_name(hid_t, unsigned int);
int H5Tget_member_index(hid_t, const char *);
size_t H5Tget_member_offset(hid_t, unsigned int);
H5T_class_t H5Tget_member_class(hid_t, unsigned int);
hid_t H5Tget_member_type(hid_t, unsigned int);
herr_t H5Tget_member_value(hid_t, unsigned int, void *);
H5T_cset_t H5Tget_cset(hid_t);
htri_t H5Tis_variable_str(hid_t);
hid_t H5Tget_native_type(hid_t, H5T_direction_t);
herr_t H5Tset_size(hid_t, size_t);
herr_t H5Tset_order(hid_t, H5T_order_t);
herr_t H5Tset_precision(hid_t, size_t);
herr_t H5Tset_offset(hid_t, size_t);
herr_t H5Tset_pad(hid_t, H5T_pad_t, H5T_pad_t);
herr_t H5Tset_sign(hid_t, H5T_sign_t);
herr_t H5Tset_fields(hid_t, size_t, size_t, size_t, size_t, size_t);
herr_t H5Tset_ebias(hid_t, size_t);
herr_t H5Tset_norm(hid_t, H5T_norm_t);
herr_t H5Tset_inpad(hid_t, H5T_pad_t);
herr_t H5Tset_cset(hid_t, H5T_cset_t);
herr_t H5Tset_strpad(hid_t, H5T_str_t);
herr_t H5Tregister(H5T_pers_t, const char *, hid_t, hid_t, H5T_conv_t);
herr_t H5Tunregister(H5T_pers_t, const char *, hid_t, hid_t, H5T_conv_t);
H5T_conv_t H5Tfind(hid_t, hid_t, H5T_cdata_t **);
htri_t H5Tcompiler_conv(hid_t, hid_t);
herr_t H5Tconvert(hid_t, hid_t, size_t, void *, void *, hid_t);
static const int H5L_SAME_LOC = 0;
static const int H5L_LINK_CLASS_T_VERS = 0;
typedef enum H5L_type_t H5L_type_t;
enum H5L_type_t {
  H5L_TYPE_ERROR = -1,
  H5L_TYPE_HARD = 0,
  H5L_TYPE_SOFT = 1,
  H5L_TYPE_EXTERNAL = 64,
  H5L_TYPE_MAX = 255,
};
static const int H5L_TYPE_UD_MIN = 64;
typedef struct H5L_info_t H5L_info_t;
struct H5L_info_t {
  H5L_type_t type;
  hbool_t corder_valid;
  int64_t corder;
  H5T_cset_t cset;
  union {
    haddr_t address;
    size_t val_size;
  } u;
};
typedef herr_t (*H5L_create_func_t)(const char *, hid_t, const void *, size_t, hid_t);
typedef herr_t (*H5L_move_func_t)(const char *, hid_t, const void *, size_t);
typedef herr_t (*H5L_copy_func_t)(const char *, hid_t, const void *, size_t);
typedef herr_t (*H5L_traverse_func_t)(const char *, hid_t, const void *, size_t, hid_t);
typedef herr_t (*H5L_delete_func_t)(const char *, hid_t, const void *, size_t);
typedef ptrdiff_t (*H5L_query_func_t)(const char *, const void *, size_t, void *, size_t);
typedef struct H5L_class_t H5L_class_t;
struct H5L_class_t {
  int version;
  H5L_type_t id;
  const char *comment;
  H5L_create_func_t create_func;
  H5L_move_func_t move_func;
  H5L_copy_func_t copy_func;
  H5L_traverse_func_t trav_func;
  H5L_delete_func_t del_func;
  H5L_query_func_t query_func;
};
typedef herr_t (*H5L_iterate_t)(hid_t, const char *, const H5L_info_t *, void *);
typedef herr_t (*H5L_elink_traverse_t)(const char *, const char *, const char *, const char *, unsigned int *, hid_t, void *);
herr_t H5Lmove(hid_t, const char *, hid_t, const char *, hid_t, hid_t);
herr_t H5Lcopy(hid_t, const char *, hid_t, const char *, hid_t, hid_t);
herr_t H5Lcreate_hard(hid_t, const char *, hid_t, const char *, hid_t, hid_t);
herr_t H5Lcreate_soft(const char *, hid_t, const char *, hid_t, hid_t);
herr_t H5Ldelete(hid_t, const char *, hid_t);
herr_t H5Ldelete_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, hid_t);
herr_t H5Lget_val(hid_t, const char *, void *, size_t, hid_t);
herr_t H5Lget_val_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, void *, size_t, hid_t);
htri_t H5Lexists(hid_t, const char *, hid_t);
herr_t H5Lget_info(hid_t, const char *, H5L_info_t *, hid_t);
herr_t H5Lget_info_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, H5L_info_t *, hid_t);
ptrdiff_t H5Lget_name_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, char *, size_t, hid_t);
herr_t H5Literate(hid_t, H5_index_t, H5_iter_order_t, hsize_t *, H5L_iterate_t, void *);
herr_t H5Literate_by_name(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t *, H5L_iterate_t, void *, hid_t);
herr_t H5Lvisit(hid_t, H5_index_t, H5_iter_order_t, H5L_iterate_t, void *);
herr_t H5Lvisit_by_name(hid_t, const char *, H5_index_t, H5_iter_order_t, H5L_iterate_t, void *, hid_t);
herr_t H5Lcreate_ud(hid_t, const char *, H5L_type_t, const void *, size_t, hid_t, hid_t);
herr_t H5Lregister(const H5L_class_t *);
herr_t H5Lunregister(H5L_type_t);
htri_t H5Lis_registered(H5L_type_t);
herr_t H5Lunpack_elink_val(const void *, size_t, unsigned int *, const char **, const char **);
herr_t H5Lcreate_external(const char *, const char *, hid_t, const char *, hid_t, hid_t);
static const int H5O_COPY_SHALLOW_HIERARCHY_FLAG = 1;
static const int H5O_COPY_EXPAND_SOFT_LINK_FLAG = 2;
static const int H5O_COPY_EXPAND_EXT_LINK_FLAG = 4;
static const int H5O_COPY_EXPAND_REFERENCE_FLAG = 8;
static const int H5O_COPY_WITHOUT_ATTR_FLAG = 16;
static const int H5O_COPY_PRESERVE_NULL_FLAG = 32;
static const int H5O_COPY_MERGE_COMMITTED_DTYPE_FLAG = 64;
static const int H5O_COPY_ALL = 127;
static const int H5O_SHMESG_NONE_FLAG = 0;
static const int H5O_SHMESG_SDSPACE_FLAG = 2;
static const int H5O_SHMESG_DTYPE_FLAG = 8;
static const int H5O_SHMESG_FILL_FLAG = 32;
static const int H5O_SHMESG_PLINE_FLAG = 2048;
static const int H5O_SHMESG_ATTR_FLAG = 4096;
static const int H5O_SHMESG_ALL_FLAG = 6186;
static const int H5O_HDR_CHUNK0_SIZE = 3;
static const int H5O_HDR_ATTR_CRT_ORDER_TRACKED = 4;
static const int H5O_HDR_ATTR_CRT_ORDER_INDEXED = 8;
static const int H5O_HDR_ATTR_STORE_PHASE_CHANGE = 16;
static const int H5O_HDR_STORE_TIMES = 32;
static const int H5O_HDR_ALL_FLAGS = 63;
static const int H5O_SHMESG_MAX_NINDEXES = 8;
static const int H5O_SHMESG_MAX_LIST_SIZE = 5000;
typedef enum H5O_type_t H5O_type_t;
enum H5O_type_t {
  H5O_TYPE_UNKNOWN = -1,
  H5O_TYPE_GROUP = 0,
  H5O_TYPE_DATASET = 1,
  H5O_TYPE_NAMED_DATATYPE = 2,
  H5O_TYPE_NTYPES = 3,
};
typedef struct H5O_hdr_info_t H5O_hdr_info_t;
struct H5O_hdr_info_t {
  unsigned int version;
  unsigned int nmesgs;
  unsigned int nchunks;
  unsigned int flags;
  struct {
    hsize_t total;
    hsize_t meta;
    hsize_t mesg;
    hsize_t free;
  } space;
  struct {
    uint64_t present;
    uint64_t shared;
  } mesg;
};
typedef struct H5O_info_t H5O_info_t;
struct H5O_info_t {
  long unsigned int fileno;
  haddr_t addr;
  H5O_type_t type;
  unsigned int rc;
  long int atime;
  long int mtime;
  long int ctime;
  long int btime;
  hsize_t num_attrs;
  H5O_hdr_info_t hdr;
  struct {
    H5_ih_info_t obj;
    H5_ih_info_t attr;
  } meta_size;
};
typedef uint32_t H5O_msg_crt_idx_t;
typedef herr_t (*H5O_iterate_t)(hid_t, const char *, const H5O_info_t *, void *);
typedef enum H5O_mcdt_search_ret_t H5O_mcdt_search_ret_t;
typedef H5O_mcdt_search_ret_t (*H5O_mcdt_search_cb_t)(void *);
hid_t H5Oopen(hid_t, const char *, hid_t);
hid_t H5Oopen_by_addr(hid_t, haddr_t);
hid_t H5Oopen_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, hid_t);
htri_t H5Oexists_by_name(hid_t, const char *, hid_t);
herr_t H5Oget_info(hid_t, H5O_info_t *);
herr_t H5Oget_info_by_name(hid_t, const char *, H5O_info_t *, hid_t);
herr_t H5Oget_info_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, H5O_info_t *, hid_t);
herr_t H5Olink(hid_t, hid_t, const char *, hid_t, hid_t);
herr_t H5Oincr_refcount(hid_t);
herr_t H5Odecr_refcount(hid_t);
herr_t H5Ocopy(hid_t, const char *, hid_t, const char *, hid_t, hid_t);
herr_t H5Oset_comment(hid_t, const char *);
herr_t H5Oset_comment_by_name(hid_t, const char *, const char *, hid_t);
ptrdiff_t H5Oget_comment(hid_t, char *, size_t);
ptrdiff_t H5Oget_comment_by_name(hid_t, const char *, char *, size_t, hid_t);
herr_t H5Ovisit(hid_t, H5_index_t, H5_iter_order_t, H5O_iterate_t, void *);
herr_t H5Ovisit_by_name(hid_t, const char *, H5_index_t, H5_iter_order_t, H5O_iterate_t, void *, hid_t);
herr_t H5Oclose(hid_t);
typedef enum H5G_storage_type_t H5G_storage_type_t;
enum H5G_storage_type_t {
  H5G_STORAGE_TYPE_UNKNOWN = -1,
  H5G_STORAGE_TYPE_SYMBOL_TABLE = 0,
  H5G_STORAGE_TYPE_COMPACT = 1,
  H5G_STORAGE_TYPE_DENSE = 2,
};
typedef struct H5G_info_t H5G_info_t;
struct H5G_info_t {
  H5G_storage_type_t storage_type;
  hsize_t nlinks;
  int64_t max_corder;
  hbool_t mounted;
};
hid_t H5Gcreate(hid_t, const char *, hid_t, hid_t, hid_t) __asm__("H5Gcreate2");
hid_t H5Gcreate_anon(hid_t, hid_t, hid_t);
hid_t H5Gopen(hid_t, const char *, hid_t) __asm__("H5Gopen2");
hid_t H5Gget_create_plist(hid_t);
herr_t H5Gget_info(hid_t, H5G_info_t *);
herr_t H5Gget_info_by_name(hid_t, const char *, H5G_info_t *, hid_t);
herr_t H5Gget_info_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, H5G_info_t *, hid_t);
herr_t H5Gclose(hid_t);
typedef struct H5A_info_t H5A_info_t;
struct H5A_info_t {
  hbool_t corder_valid;
  H5O_msg_crt_idx_t corder;
  H5T_cset_t cset;
  hsize_t data_size;
};
typedef herr_t (*H5A_operator_t)(hid_t, const char *, const H5A_info_t *, void *);
hid_t H5Acreate(hid_t, const char *, hid_t, hid_t, hid_t, hid_t) __asm__("H5Acreate2");
hid_t H5Acreate_by_name(hid_t, const char *, const char *, hid_t, hid_t, hid_t, hid_t, hid_t);
hid_t H5Aopen(hid_t, const char *, hid_t);
hid_t H5Aopen_by_name(hid_t, const char *, const char *, hid_t, hid_t);
hid_t H5Aopen_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, hid_t, hid_t);
herr_t H5Awrite(hid_t, hid_t, const void *);
herr_t H5Aread(hid_t, hid_t, void *);
herr_t H5Aclose(hid_t);
hid_t H5Aget_space(hid_t);
hid_t H5Aget_type(hid_t);
hid_t H5Aget_create_plist(hid_t);
ptrdiff_t H5Aget_name(hid_t, size_t, char *);
ptrdiff_t H5Aget_name_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, char *, size_t, hid_t);
hsize_t H5Aget_storage_size(hid_t);
herr_t H5Aget_info(hid_t, H5A_info_t *);
herr_t H5Aget_info_by_name(hid_t, const char *, const char *, H5A_info_t *, hid_t);
herr_t H5Aget_info_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, H5A_info_t *, hid_t);
herr_t H5Arename(hid_t, const char *, const char *);
herr_t H5Arename_by_name(hid_t, const char *, const char *, const char *, hid_t);
herr_t H5Aiterate(hid_t, H5_index_t, H5_iter_order_t, hsize_t *, H5A_operator_t, void *) __asm__("H5Aiterate2");
herr_t H5Aiterate_by_name(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t *, H5A_operator_t, void *, hid_t);
herr_t H5Adelete(hid_t, const char *);
herr_t H5Adelete_by_name(hid_t, const char *, const char *, hid_t);
herr_t H5Adelete_by_idx(hid_t, const char *, H5_index_t, H5_iter_order_t, hsize_t, hid_t);
htri_t H5Aexists(hid_t, const char *);
htri_t H5Aexists_by_name(hid_t, const char *, const char *, hid_t);
static const int H5D_CHUNK_CACHE_NSLOTS_DEFAULT = -1;
static const int H5D_CHUNK_CACHE_NBYTES_DEFAULT = -1;
static const int H5D_CHUNK_CACHE_W0_DEFAULT = -1;
typedef enum H5D_layout_t H5D_layout_t;
enum H5D_layout_t {
  H5D_LAYOUT_ERROR = -1,
  H5D_COMPACT = 0,
  H5D_CONTIGUOUS = 1,
  H5D_CHUNKED = 2,
  H5D_NLAYOUTS = 3,
};
typedef enum H5D_chunk_index_t H5D_chunk_index_t;
enum H5D_chunk_index_t {
  H5D_CHUNK_BTREE = 0,
};
typedef enum H5D_alloc_time_t H5D_alloc_time_t;
enum H5D_alloc_time_t {
  H5D_ALLOC_TIME_ERROR = -1,
  H5D_ALLOC_TIME_DEFAULT = 0,
  H5D_ALLOC_TIME_EARLY = 1,
  H5D_ALLOC_TIME_LATE = 2,
  H5D_ALLOC_TIME_INCR = 3,
};
typedef enum H5D_space_status_t H5D_space_status_t;
enum H5D_space_status_t {
  H5D_SPACE_STATUS_ERROR = -1,
  H5D_SPACE_STATUS_NOT_ALLOCATED = 0,
  H5D_SPACE_STATUS_PART_ALLOCATED = 1,
  H5D_SPACE_STATUS_ALLOCATED = 2,
};
typedef enum H5D_fill_time_t H5D_fill_time_t;
enum H5D_fill_time_t {
  H5D_FILL_TIME_ERROR = -1,
  H5D_FILL_TIME_ALLOC = 0,
  H5D_FILL_TIME_NEVER = 1,
  H5D_FILL_TIME_IFSET = 2,
};
typedef enum H5D_fill_value_t H5D_fill_value_t;
enum H5D_fill_value_t {
  H5D_FILL_VALUE_ERROR = -1,
  H5D_FILL_VALUE_UNDEFINED = 0,
  H5D_FILL_VALUE_DEFAULT = 1,
  H5D_FILL_VALUE_USER_DEFINED = 2,
};
typedef herr_t (*H5D_operator_t)(void *, hid_t, unsigned int, const hsize_t *, void *);
typedef herr_t (*H5D_scatter_func_t)(const void **, size_t *, void *);
typedef herr_t (*H5D_gather_func_t)(const void *, size_t, void *);
hid_t H5Dcreate(hid_t, const char *, hid_t, hid_t, hid_t, hid_t, hid_t) __asm__("H5Dcreate2");
hid_t H5Dcreate_anon(hid_t, hid_t, hid_t, hid_t, hid_t);
hid_t H5Dopen(hid_t, const char *, hid_t) __asm__("H5Dopen2");
herr_t H5Dclose(hid_t);
hid_t H5Dget_space(hid_t);
herr_t H5Dget_space_status(hid_t, H5D_space_status_t *);
hid_t H5Dget_type(hid_t);
hid_t H5Dget_create_plist(hid_t);
hid_t H5Dget_access_plist(hid_t);
hsize_t H5Dget_storage_size(hid_t);
haddr_t H5Dget_offset(hid_t);
herr_t H5Dread(hid_t, hid_t, hid_t, hid_t, hid_t, void *);
herr_t H5Dwrite(hid_t, hid_t, hid_t, hid_t, hid_t, const void *);
herr_t H5Diterate(void *, hid_t, hid_t, H5D_operator_t, void *);
herr_t H5Dvlen_reclaim(hid_t, hid_t, hid_t, void *);
herr_t H5Dvlen_get_buf_size(hid_t, hid_t, hid_t, hsize_t *);
herr_t H5Dfill(const void *, hid_t, void *, hid_t, hid_t);
herr_t H5Dset_extent(hid_t, const hsize_t *);
herr_t H5Dscatter(H5D_scatter_func_t, void *, hid_t, hid_t, void *);
herr_t H5Dgather(hid_t, const void *, hid_t, size_t, void *, H5D_gather_func_t, void *);
herr_t H5Ddebug(hid_t);
typedef enum H5R_type_t H5R_type_t;
enum H5R_type_t {
  H5R_BADTYPE = -1,
  H5R_OBJECT = 0,
  H5R_DATASET_REGION = 1,
  H5R_MAXTYPE = 2,
};
typedef haddr_t hobj_ref_t;
typedef unsigned char hdset_reg_ref_t[12];
herr_t H5Rcreate(void *, hid_t, const char *, H5R_type_t, hid_t);
hid_t H5Rdereference(hid_t, H5R_type_t, const void *);
hid_t H5Rget_region(hid_t, H5R_type_t, const void *);
herr_t H5Rget_obj_type(hid_t, H5R_type_t, const void *, H5O_type_t *) __asm__("H5Rget_obj_type2");
ptrdiff_t H5Rget_name(hid_t, H5R_type_t, const void *, char *, size_t);
typedef int H5Z_filter_t;
static const int H5Z_FILTER_ERROR = -1;
static const int H5Z_FILTER_NONE = 0;
static const int H5Z_FILTER_DEFLATE = 1;
static const int H5Z_FILTER_SHUFFLE = 2;
static const int H5Z_FILTER_FLETCHER32 = 3;
static const int H5Z_FILTER_SZIP = 4;
static const int H5Z_FILTER_NBIT = 5;
static const int H5Z_FILTER_SCALEOFFSET = 6;
static const int H5Z_FILTER_RESERVED = 256;
static const int H5Z_FILTER_MAX = 65535;
static const int H5Z_FILTER_ALL = 0;
static const int H5Z_MAX_NFILTERS = 32;
static const int H5Z_FLAG_DEFMASK = 255;
static const int H5Z_FLAG_MANDATORY = 0;
static const int H5Z_FLAG_OPTIONAL = 1;
static const int H5Z_FLAG_INVMASK = 65280;
static const int H5Z_FLAG_REVERSE = 256;
static const int H5Z_FLAG_SKIP_EDC = 512;
static const int H5_SZIP_ALLOW_K13_OPTION_MASK = 1;
static const int H5_SZIP_CHIP_OPTION_MASK = 2;
static const int H5_SZIP_EC_OPTION_MASK = 4;
static const int H5_SZIP_NN_OPTION_MASK = 32;
static const int H5_SZIP_MAX_PIXELS_PER_BLOCK = 32;
static const int H5Z_SHUFFLE_USER_NPARMS = 0;
static const int H5Z_SHUFFLE_TOTAL_NPARMS = 1;
static const int H5Z_SZIP_USER_NPARMS = 2;
static const int H5Z_SZIP_TOTAL_NPARMS = 4;
static const int H5Z_SZIP_PARM_MASK = 0;
static const int H5Z_SZIP_PARM_PPB = 1;
static const int H5Z_SZIP_PARM_BPP = 2;
static const int H5Z_SZIP_PARM_PPS = 3;
static const int H5Z_NBIT_USER_NPARMS = 0;
static const int H5Z_SCALEOFFSET_USER_NPARMS = 2;
static const int H5Z_SO_INT_MINBITS_DEFAULT = 0;
typedef enum H5Z_SO_scale_type_t H5Z_SO_scale_type_t;
enum H5Z_SO_scale_type_t {
  H5Z_SO_FLOAT_DSCALE = 0,
  H5Z_SO_FLOAT_ESCALE = 1,
  H5Z_SO_INT = 2,
};
static const int H5Z_CLASS_T_VERS = 1;
typedef enum H5Z_EDC_t H5Z_EDC_t;
enum H5Z_EDC_t {
  H5Z_ERROR_EDC = -1,
  H5Z_DISABLE_EDC = 0,
  H5Z_ENABLE_EDC = 1,
  H5Z_NO_EDC = 2,
};
static const int H5Z_FILTER_CONFIG_ENCODE_ENABLED = 1;
static const int H5Z_FILTER_CONFIG_DECODE_ENABLED = 2;
typedef enum H5Z_cb_return_t H5Z_cb_return_t;
enum H5Z_cb_return_t {
  H5Z_CB_ERROR = -1,
  H5Z_CB_FAIL = 0,
  H5Z_CB_CONT = 1,
  H5Z_CB_NO = 2,
};
typedef H5Z_cb_return_t (*H5Z_filter_func_t)(H5Z_filter_t, void *, size_t, void *);
typedef struct H5Z_cb_t H5Z_cb_t;
struct H5Z_cb_t {
  H5Z_filter_func_t func;
  void *op_data;
};
typedef htri_t (*H5Z_can_apply_func_t)(hid_t, hid_t, hid_t);
typedef herr_t (*H5Z_set_local_func_t)(hid_t, hid_t, hid_t);
typedef size_t (*H5Z_func_t)(unsigned int, size_t, const unsigned int *, size_t, size_t *, void **);
typedef struct H5Z_class_t H5Z_class_t;
struct H5Z_class_t {
  int version;
  H5Z_filter_t id;
  unsigned int encoder_present;
  unsigned int decoder_present;
  const char *name;
  H5Z_can_apply_func_t can_apply;
  H5Z_set_local_func_t set_local;
  H5Z_func_t filter;
};
herr_t H5Zregister(const void *);
herr_t H5Zunregister(H5Z_filter_t);
htri_t H5Zfilter_avail(H5Z_filter_t);
herr_t H5Zget_filter_info(H5Z_filter_t, unsigned int *);
typedef void *(*H5MM_allocate_t)(size_t, void *);
typedef void (*H5MM_free_t)(void *, void *);
extern hid_t H5P_ROOT __asm__("H5P_CLS_ROOT_g");
extern hid_t H5P_OBJECT_CREATE __asm__("H5P_CLS_OBJECT_CREATE_g");
extern hid_t H5P_FILE_CREATE __asm__("H5P_CLS_FILE_CREATE_g");
extern hid_t H5P_FILE_ACCESS __asm__("H5P_CLS_FILE_ACCESS_g");
extern hid_t H5P_DATASET_CREATE __asm__("H5P_CLS_DATASET_CREATE_g");
extern hid_t H5P_DATASET_ACCESS __asm__("H5P_CLS_DATASET_ACCESS_g");
extern hid_t H5P_DATASET_XFER __asm__("H5P_CLS_DATASET_XFER_g");
extern hid_t H5P_FILE_MOUNT __asm__("H5P_CLS_FILE_MOUNT_g");
extern hid_t H5P_GROUP_CREATE __asm__("H5P_CLS_GROUP_CREATE_g");
extern hid_t H5P_GROUP_ACCESS __asm__("H5P_CLS_GROUP_ACCESS_g");
extern hid_t H5P_DATATYPE_CREATE __asm__("H5P_CLS_DATATYPE_CREATE_g");
extern hid_t H5P_DATATYPE_ACCESS __asm__("H5P_CLS_DATATYPE_ACCESS_g");
extern hid_t H5P_STRING_CREATE __asm__("H5P_CLS_STRING_CREATE_g");
extern hid_t H5P_ATTRIBUTE_CREATE __asm__("H5P_CLS_ATTRIBUTE_CREATE_g");
extern hid_t H5P_OBJECT_COPY __asm__("H5P_CLS_OBJECT_COPY_g");
extern hid_t H5P_LINK_CREATE __asm__("H5P_CLS_LINK_CREATE_g");
extern hid_t H5P_LINK_ACCESS __asm__("H5P_CLS_LINK_ACCESS_g");
extern hid_t H5P_FILE_CREATE_DEFAULT __asm__("H5P_LST_FILE_CREATE_g");
extern hid_t H5P_FILE_ACCESS_DEFAULT __asm__("H5P_LST_FILE_ACCESS_g");
extern hid_t H5P_DATASET_CREATE_DEFAULT __asm__("H5P_LST_DATASET_CREATE_g");
extern hid_t H5P_DATASET_ACCESS_DEFAULT __asm__("H5P_LST_DATASET_ACCESS_g");
extern hid_t H5P_DATASET_XFER_DEFAULT __asm__("H5P_LST_DATASET_XFER_g");
extern hid_t H5P_FILE_MOUNT_DEFAULT __asm__("H5P_LST_FILE_MOUNT_g");
extern hid_t H5P_GROUP_CREATE_DEFAULT __asm__("H5P_LST_GROUP_CREATE_g");
extern hid_t H5P_GROUP_ACCESS_DEFAULT __asm__("H5P_LST_GROUP_ACCESS_g");
extern hid_t H5P_DATATYPE_CREATE_DEFAULT __asm__("H5P_LST_DATATYPE_CREATE_g");
extern hid_t H5P_DATATYPE_ACCESS_DEFAULT __asm__("H5P_LST_DATATYPE_ACCESS_g");
extern hid_t H5P_ATTRIBUTE_CREATE_DEFAULT __asm__("H5P_LST_ATTRIBUTE_CREATE_g");
extern hid_t H5P_OBJECT_COPY_DEFAULT __asm__("H5P_LST_OBJECT_COPY_g");
extern hid_t H5P_LINK_CREATE_DEFAULT __asm__("H5P_LST_LINK_CREATE_g");
extern hid_t H5P_LINK_ACCESS_DEFAULT __asm__("H5P_LST_LINK_ACCESS_g");
static const int H5P_CRT_ORDER_TRACKED = 1;
static const int H5P_CRT_ORDER_INDEXED = 2;
typedef herr_t (*H5P_cls_create_func_t)(hid_t, void *);
typedef herr_t (*H5P_cls_copy_func_t)(hid_t, hid_t, void *);
typedef herr_t (*H5P_cls_close_func_t)(hid_t, void *);
typedef herr_t (*H5P_prp_cb1_t)(const char *, size_t, void *);
typedef herr_t (*H5P_prp_cb2_t)(hid_t, const char *, size_t, void *);
typedef herr_t (*H5P_prp_create_func_t)(const char *, size_t, void *);
typedef herr_t (*H5P_prp_set_func_t)(hid_t, const char *, size_t, void *);
typedef herr_t (*H5P_prp_get_func_t)(hid_t, const char *, size_t, void *);
typedef herr_t (*H5P_prp_delete_func_t)(hid_t, const char *, size_t, void *);
typedef herr_t (*H5P_prp_copy_func_t)(const char *, size_t, void *);
typedef int (*H5P_prp_compare_func_t)(const void *, const void *, size_t);
typedef herr_t (*H5P_prp_close_func_t)(const char *, size_t, void *);
typedef herr_t (*H5P_iterate_t)(hid_t, const char *, void *);
typedef enum H5D_mpio_actual_chunk_opt_mode_t H5D_mpio_actual_chunk_opt_mode_t;
enum H5D_mpio_actual_chunk_opt_mode_t {
  H5D_MPIO_NO_CHUNK_OPTIMIZATION = 0,
  H5D_MPIO_LINK_CHUNK = 1,
  H5D_MPIO_MULTI_CHUNK = 2,
};
typedef enum H5D_mpio_actual_io_mode_t H5D_mpio_actual_io_mode_t;
enum H5D_mpio_actual_io_mode_t {
  H5D_MPIO_NO_COLLECTIVE = 0,
  H5D_MPIO_CHUNK_INDEPENDENT = 1,
  H5D_MPIO_CHUNK_COLLECTIVE = 2,
  H5D_MPIO_CHUNK_MIXED = 3,
  H5D_MPIO_CONTIGUOUS_COLLECTIVE = 4,
};
typedef enum H5D_mpio_no_collective_cause_t H5D_mpio_no_collective_cause_t;
hid_t H5Pcreate_class(hid_t, const char *, H5P_cls_create_func_t, void *, H5P_cls_copy_func_t, void *, H5P_cls_close_func_t, void *);
char *H5Pget_class_name(hid_t);
hid_t H5Pcreate(hid_t);
herr_t H5Pregister(hid_t, const char *, size_t, void *, H5P_prp_create_func_t, H5P_prp_set_func_t, H5P_prp_get_func_t, H5P_prp_delete_func_t, H5P_prp_copy_func_t, H5P_prp_compare_func_t, H5P_prp_close_func_t) __asm__("H5Pregister2");
herr_t H5Pinsert(hid_t, const char *, size_t, void *, H5P_prp_set_func_t, H5P_prp_get_func_t, H5P_prp_delete_func_t, H5P_prp_copy_func_t, H5P_prp_compare_func_t, H5P_prp_close_func_t) __asm__("H5Pinsert2");
herr_t H5Pset(hid_t, const char *, void *);
htri_t H5Pexist(hid_t, const char *);
herr_t H5Pget_size(hid_t, const char *, size_t *);
herr_t H5Pget_nprops(hid_t, size_t *);
hid_t H5Pget_class(hid_t);
hid_t H5Pget_class_parent(hid_t);
herr_t H5Pget(hid_t, const char *, void *);
htri_t H5Pequal(hid_t, hid_t);
htri_t H5Pisa_class(hid_t, hid_t);
int H5Piterate(hid_t, int *, H5P_iterate_t, void *);
herr_t H5Pcopy_prop(hid_t, hid_t, const char *);
herr_t H5Premove(hid_t, const char *);
herr_t H5Punregister(hid_t, const char *);
herr_t H5Pclose_class(hid_t);
herr_t H5Pclose(hid_t);
hid_t H5Pcopy(hid_t);
herr_t H5Pset_attr_phase_change(hid_t, unsigned int, unsigned int);
herr_t H5Pget_attr_phase_change(hid_t, unsigned int *, unsigned int *);
herr_t H5Pset_attr_creation_order(hid_t, unsigned int);
herr_t H5Pget_attr_creation_order(hid_t, unsigned int *);
herr_t H5Pset_obj_track_times(hid_t, hbool_t);
herr_t H5Pget_obj_track_times(hid_t, hbool_t *);
herr_t H5Pmodify_filter(hid_t, H5Z_filter_t, unsigned int, size_t, const unsigned int *);
herr_t H5Pset_filter(hid_t, H5Z_filter_t, unsigned int, size_t, const unsigned int *);
int H5Pget_nfilters(hid_t);
H5Z_filter_t H5Pget_filter(hid_t, unsigned int, unsigned int *, size_t *, unsigned int *, size_t, char *, unsigned int *) __asm__("H5Pget_filter2");
herr_t H5Pget_filter_by_id(hid_t, H5Z_filter_t, unsigned int *, size_t *, unsigned int *, size_t, char *, unsigned int *) __asm__("H5Pget_filter_by_id2");
htri_t H5Pall_filters_avail(hid_t);
herr_t H5Premove_filter(hid_t, H5Z_filter_t);
herr_t H5Pset_deflate(hid_t, unsigned int);
herr_t H5Pset_fletcher32(hid_t);
herr_t H5Pget_version(hid_t, unsigned int *, unsigned int *, unsigned int *, unsigned int *);
herr_t H5Pset_userblock(hid_t, hsize_t);
herr_t H5Pget_userblock(hid_t, hsize_t *);
herr_t H5Pset_sizes(hid_t, size_t, size_t);
herr_t H5Pget_sizes(hid_t, size_t *, size_t *);
herr_t H5Pset_sym_k(hid_t, unsigned int, unsigned int);
herr_t H5Pget_sym_k(hid_t, unsigned int *, unsigned int *);
herr_t H5Pset_istore_k(hid_t, unsigned int);
herr_t H5Pget_istore_k(hid_t, unsigned int *);
herr_t H5Pset_shared_mesg_nindexes(hid_t, unsigned int);
herr_t H5Pget_shared_mesg_nindexes(hid_t, unsigned int *);
herr_t H5Pset_shared_mesg_index(hid_t, unsigned int, unsigned int, unsigned int);
herr_t H5Pget_shared_mesg_index(hid_t, unsigned int, unsigned int *, unsigned int *);
herr_t H5Pset_shared_mesg_phase_change(hid_t, unsigned int, unsigned int);
herr_t H5Pget_shared_mesg_phase_change(hid_t, unsigned int *, unsigned int *);
herr_t H5Pset_alignment(hid_t, hsize_t, hsize_t);
herr_t H5Pget_alignment(hid_t, hsize_t *, hsize_t *);
herr_t H5Pset_driver(hid_t, hid_t, const void *);
hid_t H5Pget_driver(hid_t);
void *H5Pget_driver_info(hid_t);
herr_t H5Pset_family_offset(hid_t, hsize_t);
herr_t H5Pget_family_offset(hid_t, hsize_t *);
herr_t H5Pset_multi_type(hid_t, H5FD_mem_t);
herr_t H5Pget_multi_type(hid_t, H5FD_mem_t *);
herr_t H5Pset_cache(hid_t, int, size_t, size_t, double);
herr_t H5Pget_cache(hid_t, int *, size_t *, size_t *, double *);
herr_t H5Pset_mdc_config(hid_t, H5AC_cache_config_t *);
herr_t H5Pget_mdc_config(hid_t, H5AC_cache_config_t *);
herr_t H5Pset_gc_references(hid_t, unsigned int);
herr_t H5Pget_gc_references(hid_t, unsigned int *);
herr_t H5Pset_fclose_degree(hid_t, H5F_close_degree_t);
herr_t H5Pget_fclose_degree(hid_t, H5F_close_degree_t *);
herr_t H5Pset_meta_block_size(hid_t, hsize_t);
herr_t H5Pget_meta_block_size(hid_t, hsize_t *);
herr_t H5Pset_sieve_buf_size(hid_t, size_t);
herr_t H5Pget_sieve_buf_size(hid_t, size_t *);
herr_t H5Pset_small_data_block_size(hid_t, hsize_t);
herr_t H5Pget_small_data_block_size(hid_t, hsize_t *);
herr_t H5Pset_libver_bounds(hid_t, H5F_libver_t, H5F_libver_t);
herr_t H5Pget_libver_bounds(hid_t, H5F_libver_t *, H5F_libver_t *);
herr_t H5Pset_elink_file_cache_size(hid_t, unsigned int);
herr_t H5Pget_elink_file_cache_size(hid_t, unsigned int *);
herr_t H5Pset_file_image(hid_t, void *, size_t);
herr_t H5Pget_file_image(hid_t, void **, size_t *);
typedef enum {
  H5FD_FILE_IMAGE_OP_NO_OP = 0,
  H5FD_FILE_IMAGE_OP_PROPERTY_LIST_SET = 1,
  H5FD_FILE_IMAGE_OP_PROPERTY_LIST_COPY = 2,
  H5FD_FILE_IMAGE_OP_PROPERTY_LIST_GET = 3,
  H5FD_FILE_IMAGE_OP_PROPERTY_LIST_CLOSE = 4,
  H5FD_FILE_IMAGE_OP_FILE_OPEN = 5,
  H5FD_FILE_IMAGE_OP_FILE_RESIZE = 6,
  H5FD_FILE_IMAGE_OP_FILE_CLOSE = 7,
} H5FD_file_image_op_t;
typedef struct {
  void *(*image_malloc)(size_t, H5FD_file_image_op_t, void *);
  void *(*image_memcpy)(void *, const void *, size_t, H5FD_file_image_op_t, void *);
  void *(*image_realloc)(void *, size_t, H5FD_file_image_op_t, void *);
  herr_t (*image_free)(void *, H5FD_file_image_op_t, void *);
  void *(*udata_copy)(void *);
  herr_t (*udata_free)(void *);
  void *udata;
} H5FD_file_image_callbacks_t;
herr_t H5Pset_file_image_callbacks(hid_t, H5FD_file_image_callbacks_t *);
herr_t H5Pget_file_image_callbacks(hid_t, H5FD_file_image_callbacks_t *);
herr_t H5Pset_layout(hid_t, H5D_layout_t);
H5D_layout_t H5Pget_layout(hid_t);
herr_t H5Pset_chunk(hid_t, int, const hsize_t *);
int H5Pget_chunk(hid_t, int, hsize_t *);
herr_t H5Pset_external(hid_t, const char *, long int, hsize_t);
int H5Pget_external_count(hid_t);
herr_t H5Pget_external(hid_t, unsigned int, size_t, char *, long int *, hsize_t *);
herr_t H5Pset_szip(hid_t, unsigned int, unsigned int);
herr_t H5Pset_shuffle(hid_t);
herr_t H5Pset_nbit(hid_t);
herr_t H5Pset_scaleoffset(hid_t, H5Z_SO_scale_type_t, int);
herr_t H5Pset_fill_value(hid_t, hid_t, const void *);
herr_t H5Pget_fill_value(hid_t, hid_t, void *);
herr_t H5Pfill_value_defined(hid_t, H5D_fill_value_t *);
herr_t H5Pset_alloc_time(hid_t, H5D_alloc_time_t);
herr_t H5Pget_alloc_time(hid_t, H5D_alloc_time_t *);
herr_t H5Pset_fill_time(hid_t, H5D_fill_time_t);
herr_t H5Pget_fill_time(hid_t, H5D_fill_time_t *);
herr_t H5Pset_chunk_cache(hid_t, size_t, size_t, double);
herr_t H5Pget_chunk_cache(hid_t, size_t *, size_t *, double *);
herr_t H5Pset_data_transform(hid_t, const char *);
ptrdiff_t H5Pget_data_transform(hid_t, char *, size_t);
herr_t H5Pset_buffer(hid_t, size_t, void *, void *);
size_t H5Pget_buffer(hid_t, void **, void **);
herr_t H5Pset_preserve(hid_t, hbool_t);
int H5Pget_preserve(hid_t);
herr_t H5Pset_edc_check(hid_t, H5Z_EDC_t);
H5Z_EDC_t H5Pget_edc_check(hid_t);
herr_t H5Pset_filter_callback(hid_t, H5Z_filter_func_t, void *);
herr_t H5Pset_btree_ratios(hid_t, double, double, double);
herr_t H5Pget_btree_ratios(hid_t, double *, double *, double *);
herr_t H5Pset_vlen_mem_manager(hid_t, H5MM_allocate_t, void *, H5MM_free_t, void *);
herr_t H5Pget_vlen_mem_manager(hid_t, H5MM_allocate_t *, void **, H5MM_free_t *, void **);
herr_t H5Pset_hyper_vector_size(hid_t, size_t);
herr_t H5Pget_hyper_vector_size(hid_t, size_t *);
herr_t H5Pset_type_conv_cb(hid_t, H5T_conv_except_func_t, void *);
herr_t H5Pget_type_conv_cb(hid_t, H5T_conv_except_func_t *, void **);
herr_t H5Pget_mpio_actual_chunk_opt_mode(hid_t, H5D_mpio_actual_chunk_opt_mode_t *);
herr_t H5Pget_mpio_actual_io_mode(hid_t, H5D_mpio_actual_io_mode_t *);
herr_t H5Pget_mpio_no_collective_cause(hid_t, uint32_t *, uint32_t *);
herr_t H5Pset_create_intermediate_group(hid_t, unsigned int);
herr_t H5Pget_create_intermediate_group(hid_t, unsigned int *);
herr_t H5Pset_local_heap_size_hint(hid_t, size_t);
herr_t H5Pget_local_heap_size_hint(hid_t, size_t *);
herr_t H5Pset_link_phase_change(hid_t, unsigned int, unsigned int);
herr_t H5Pget_link_phase_change(hid_t, unsigned int *, unsigned int *);
herr_t H5Pset_est_link_info(hid_t, unsigned int, unsigned int);
herr_t H5Pget_est_link_info(hid_t, unsigned int *, unsigned int *);
herr_t H5Pset_link_creation_order(hid_t, unsigned int);
herr_t H5Pget_link_creation_order(hid_t, unsigned int *);
herr_t H5Pset_char_encoding(hid_t, H5T_cset_t);
herr_t H5Pget_char_encoding(hid_t, H5T_cset_t *);
herr_t H5Pset_nlinks(hid_t, size_t);
herr_t H5Pget_nlinks(hid_t, size_t *);
herr_t H5Pset_elink_prefix(hid_t, const char *);
ptrdiff_t H5Pget_elink_prefix(hid_t, char *, size_t);
hid_t H5Pget_elink_fapl(hid_t);
herr_t H5Pset_elink_fapl(hid_t, hid_t);
herr_t H5Pset_elink_acc_flags(hid_t, unsigned int);
herr_t H5Pget_elink_acc_flags(hid_t, unsigned int *);
herr_t H5Pset_elink_cb(hid_t, H5L_elink_traverse_t, void *);
herr_t H5Pget_elink_cb(hid_t, H5L_elink_traverse_t *, void **);
herr_t H5Pset_copy_object(hid_t, unsigned int);
herr_t H5Pget_copy_object(hid_t, unsigned int *);
herr_t H5Padd_merge_committed_dtype_path(hid_t, const char *);
herr_t H5Pfree_merge_committed_dtype_paths(hid_t);
herr_t H5Pset_mcdt_search_cb(hid_t, H5O_mcdt_search_cb_t, void *);
herr_t H5Pget_mcdt_search_cb(hid_t, H5O_mcdt_search_cb_t *, void **);
typedef enum H5FD_mpio_xfer_t H5FD_mpio_xfer_t;
enum H5FD_mpio_xfer_t {
  H5FD_MPIO_INDEPENDENT = 0,
  H5FD_MPIO_COLLECTIVE = 1,
};
typedef enum H5FD_mpio_chunk_opt_t H5FD_mpio_chunk_opt_t;
enum H5FD_mpio_chunk_opt_t {
  H5FD_MPIO_CHUNK_DEFAULT = 0,
  H5FD_MPIO_CHUNK_ONE_IO = 1,
  H5FD_MPIO_CHUNK_MULTI_IO = 2,
};
typedef enum H5FD_mpio_collective_opt_t H5FD_mpio_collective_opt_t;
enum H5FD_mpio_collective_opt_t {
  H5FD_MPIO_COLLECTIVE_IO = 0,
  H5FD_MPIO_INDIVIDUAL_IO = 1,
};
herr_t H5Pset_fapl_mpio(hid_t, struct ompi_communicator_t *, struct ompi_info_t *);
herr_t H5Pget_fapl_mpio(hid_t, struct ompi_communicator_t **, struct ompi_info_t **);
herr_t H5Pset_dxpl_mpio(hid_t, H5FD_mpio_xfer_t);
herr_t H5Pget_dxpl_mpio(hid_t, H5FD_mpio_xfer_t *);
herr_t H5Pset_dxpl_mpio_collective_opt(hid_t, H5FD_mpio_collective_opt_t);
herr_t H5Pset_dxpl_mpio_chunk_opt(hid_t, H5FD_mpio_chunk_opt_t);
herr_t H5Pset_dxpl_mpio_chunk_opt_num(hid_t, unsigned int);
herr_t H5Pset_dxpl_mpio_chunk_opt_ratio(hid_t, unsigned int);
herr_t H5Pset_fapl_mpiposix(hid_t, struct ompi_communicator_t *, hbool_t);
herr_t H5Pget_fapl_mpiposix(hid_t, struct ompi_communicator_t **, hbool_t *);
]]

-- If the HDF5 library has been linked to the application, use HDF5
-- symbols from default, global namespace. Otherwise, dynamically load
-- the HDF5 library into its own, non-global C library namespace.
local C
if pcall(function() return ffi.C.H5open end) then
  C = ffi.C
else
  C = ffi.load("hdf5")
end
return C
