# Current tools are eepmake and eepdump

CC ?= gcc
CFLAGS ?= -Wall -Wextra
prefix ?= /usr/local
exec_prefix = ${prefix}

kwstool: tool.c
	$(CC) $(CFLAGS) tool.c -o kwsproductiontool

install:
	install kwsproductiontool $(DESTDIR)$(prefix)/bin/

uninstall:
	rm -f $(DESTDIR)$(prefix)/bin/kwsproductiontool

clean:
	rm -f kwsproductiontool
