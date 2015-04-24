/*
 * Query soname of HDF5 library.
 * Copyright © 2013–2015 Peter Colberg.
 * Distributed under the MIT license. (See accompanying file LICENSE.)
 */

#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <libgen.h>
#include <stdlib.h>
#include <string.h>

#include <hdf5.h>
#define sym H5open

/* This program must be compiled as a position-independent executable. */

#define error(fmt, ...) fprintf(stderr, "%s: "fmt"\n", argv[0], ##__VA_ARGS__)

int main(int argc, const char *const *argv)
{
  Dl_info info;
  if (dladdr(sym, &info) == 0) {
    error("%s", dlerror());
    return 1;
  }
  if (info.dli_saddr != sym) {
    error("mismatching symbol '%s'", info.dli_sname);
    return 1;
  }
  char *buf = strdup(info.dli_fname);
  printf("%s\n", basename(buf));
  free(buf);
  return 0;
}
