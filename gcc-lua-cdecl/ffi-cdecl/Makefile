CC = gcc
CPPFLAGS =
CFLAGS = -Wall -pedantic -O2
GCCLUA = $(CURDIR)/../../gcc-lua/gcc/gcclua.so

all: C.lua

%.lua: %.c %.lua.in
	$(CC) -S $< $(CPPFLAGS) $(CFLAGS) -fplugin=$(GCCLUA) -fplugin-arg-gcclua-script=$@.in -fplugin-arg-gcclua-output=$@

clean:
	$(RM) C.lua

.PHONY: clean
