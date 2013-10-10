dnl Process this file with autoconf to produce configure.
AC_INIT(libneurosim, 1.0.0)
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER([config.h])
AM_MAINTAINER_MODE

LT_PATH_LD
LT_CONFIG_LTDL_DIR([libltdl])
_LTDL_CONVENIENCE                 ## put libltdl into a convenience library
LT_INIT([dlopen])                 ## use libtool
m4_pattern_allow([LT_LIBEXT])     ## supress false positive message by autoconf

if test "x$BUILD_SHARED" != xno ; then
  if test "x$LIBLTDL" != x ; then
    AC_DEFINE(HAVE_LIBLTDL, 1, [Havel libltdl, can load dynamic modules])
  fi
fi

AC_CONFIG_SUBDIRS(libltdl)        ## also configure subdir containing libltdl
AC_PROG_CXX
AC_PROG_LIBTOOL

AM_PATH_PYTHON
AM_CONDITIONAL([HAVE_PYTHON], [test "$PYTHON" != [:]])
if test $PYTHON != [:]; then
  PYTHON_INCLUDE=`$PYTHON -c 'from distutils import sysconfig;\
  			      print (sysconfig.get_python_inc ())'`
fi

AC_SUBST(PYTHON_INCLUDE)
AC_SUBST(INCLTDL)
AC_SUBST(LIBLTDL)
AC_SUBST(HAVE_LIBLTDL)
AC_SUBST(LIBADD_DL)

AC_CONFIG_FILES([
  Makefile
  libneurosim/Makefile
  libneurosim/version.h
  libpyneurosim/Makefile
])

AC_OUTPUT

dnl Local Variables:
dnl comment-start: "dnl "
dnl comment-end: ""
dnl comment-start-skip: "\\bdnl\\b\\s *"
dnl End:
