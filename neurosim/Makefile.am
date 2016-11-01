## Process this file with Automake to create Makefile.in

AUTOMAKE_OPTIONS = subdir-objects

SUBDIRS = . examples

lib_LTLIBRARIES = libneurosim.la

libneurosim_la_SOURCES = \
  connection_generator.cpp \
  connection_generator.h \
  connection_generator_V2_0.cpp \
  connection_generator_V2_0.h \
  version.c version.h

libneurosim_la_HEADERS = \
  connection_generator.h \
  connection_generator_V2_0.h \
  version.h

libneurosim_la_LIBADD= @LIBLTDL@ @LIBADD_DL@ @MPI_LIBS@

libneurosim_ladir = $(includedir)/neurosim

AM_CPPFLAGS= -I$(top_srcdir) @INCLTDL@ @MPI_INCLUDE@
