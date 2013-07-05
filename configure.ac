dnl Process this file with autoconf to produce configure.
AC_INIT(libneurosim, 1.0.0)
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER([config.h])
AM_MAINTAINER_MODE

AC_PROG_CXX
AC_PROG_LIBTOOL

AM_PATH_PYTHON
AM_CONDITIONAL([HAVE_PYTHON], [test "$PYTHON" != [:]])
if test $PYTHON != [:]; then
  PYTHON_INCLUDE=`$PYTHON -c 'from distutils import sysconfig;\
  			      print (sysconfig.get_python_inc ())'`
fi

AC_SUBST(PYTHON_INCLUDE)

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
