## Process this file with Automake to create Makefile.in

AUTOMAKE_OPTIONS = subdir-objects

lib_LTLIBRARIES = libneurosim.la

libneurosim_la_SOURCES = \
  conngen/connection_generator.cpp \
  conngen/connection_generator.h \
  version.c version.h

libneurosim_la_HEADERS = \
  conngen/connection_generator.h \
  version.h

libneurosim_la_LIBADD= @LIBLTDL@ @LIBADD_DL@ @MPI_LIBS@

libneurosim_ladir = $(includedir)/neurosim

AM_CPPFLAGS= @INCLTDL@ @MPI_INCLUDE@
