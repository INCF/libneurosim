## Process this file with Automake to create Makefile.in

AUTOMAKE_OPTIONS = subdir-objects

lib_LTLIBRARIES =
if HAVE_PYTHON
lib_LTLIBRARIES += libpyneurosim.la
endif

libpyneurosim_la_SOURCES = \
  pyneurosim.cpp \
  pyneurosim.h \
  pycsa.cpp \
  pycsa.h

libpyneurosim_la_HEADERS = \
  pyneurosim.h

libpyneurosim_la_CXXFLAGS = -I@PYTHON_INCLUDE@ -I$(srcdir)/../libneurosim/conngen

libpyneurosim_la_LDFLAGS = $(top_builddir)/libneurosim/libneurosim.la

libpyneurosim_ladir = $(includedir)/neurosim
