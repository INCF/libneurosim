## Process this file with Automake to create Makefile.in

lib_LTLIBRARIES =
if HAVE_PYTHON
lib_LTLIBRARIES += libpyneurosim.la
endif

libpyneurosim_la_SOURCES = \
  $(srcdir)/pyneurosim.cpp \
  $(srcdir)/pyneurosim.h

libpyneurosim_la_HEADERS = \
  $(srcdir)/pyneurosim.h

libpyneurosim_la_CXXFLAGS = -I@PYTHON_INCLUDE@ -I../libneurosim/conngen

libpyneurosim_ladir = $(includedir)/neurosim
