## Process this file with Automake to create Makefile.in

AUTOMAKE_OPTIONS = subdir-objects

pyexec_LTLIBRARIES =
if HAVE_PYTHON
if PY3
pyexec_LTLIBRARIES += libpy3neurosim.la
libpy3neurosim_la_SOURCES = \
  pyneurosim.cpp \
  pyneurosim.h

libpy3neurosim_la_HEADERS = \
  pyneurosim.h

libpy3neurosim_la_CXXFLAGS = -I@PYTHON_INCLUDE@ -I$(srcdir)/../libneurosim/conngen
libpy3neurosim_la_LDFLAGS = -avoid-version -module $(top_builddir)/libneurosim/libneurosim.la
libpy3neurosim_ladir = $(includedir)/neurosim
else
pyexec_LTLIBRARIES += libpy2neurosim.la libpyneurosim.la
libpy2neurosim_la_SOURCES = \
  pyneurosim.cpp \
  pyneurosim.h

libpy2neurosim_la_HEADERS = \
  pyneurosim.h

libpy2neurosim_la_CXXFLAGS = -I@PYTHON_INCLUDE@ -I$(srcdir)/../libneurosim/conngen
libpy2neurosim_la_LDFLAGS = -avoid-version -module $(top_builddir)/libneurosim/libneurosim.la
libpy2neurosim_ladir = $(includedir)/neurosim
# generate versionless version for backwards compatibility
libpyneurosim_la_SOURCES = \
  pyneurosim.cpp \
  pyneurosim.h

libpyneurosim_la_HEADERS = \
  pyneurosim.h

libpyneurosim_la_CXXFLAGS = -I@PYTHON_INCLUDE@ -I$(srcdir)/../libneurosim/conngen
libpyneurosim_la_LDFLAGS = -avoid-version -module $(top_builddir)/libneurosim/libneurosim.la
libpyneurosim_ladir = $(includedir)/neurosim
endif
endif
