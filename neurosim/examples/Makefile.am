## Process this file with Automake to create Makefile.in

noinst_PROGRAMS = runiter2

runiter2_SOURCES = \
  runiter2.cpp genex2.h \
  simulator-model.h simulator-model.cpp

runiter2_LDADD = $(top_builddir)/neurosim/libneurosim.la

AM_CPPFLAGS = -I$(top_srcdir)
