## Process this file with Automake to create Makefile.in

AUTOMAKE_OPTIONS = subdir-objects

lib_LTLIBRARIES =
if HAVE_PYTHON
lib_LTLIBRARIES += libpyneurosim.la
endif

libpyneurosim_la_SOURCES = \
  $(srcdir)/pyneurosim.cpp \
  $(srcdir)/pyneurosim.h \
  $(srcdir)/pycsa.cpp \
  $(srcdir)/pycsa.h

libpyneurosim_la_HEADERS = \
  $(srcdir)/pyneurosim.h

libpyneurosim_la_CXXFLAGS = -I@PYTHON_INCLUDE@ -I$(srcdir)/../libneurosim/conngen

libpyneurosim_la_LDFLAGS = $(top_builddir)/libneurosim/libneurosim.la

libpyneurosim_ladir = $(includedir)/neurosim
