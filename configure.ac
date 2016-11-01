dnl Process this file with autoconf to produce configure.
AC_INIT(libneurosim, 1.0.0)
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER([config.h])
AM_MAINTAINER_MODE

# Obtain host system type
AC_CANONICAL_HOST

# Debug level
# Note, $NS_debug is used in acinclude.m4
NS_debug="set"
# Flags depend on platform and compiler and will be set later
NS_debugflags=""

# Optimization level
# Note, $NS_optimize is used in acinclude.m4
NS_optimize="set"
# Flags depend on platform and compiler and will be set later
NS_optimizeflags=""

# Warning level
# Note, $NS_warning is used in acinclude.m4
NS_warning="set"
# Flags depend on platform and compiler and will be set later
NS_warningflags=""

bluegene_architecture="none"
configure_bluegene="no"
AC_MSG_CHECKING(whether we are configuring for Blue Gene)
AC_ARG_ENABLE([bluegene],
	[AS_HELP_STRING([--enable-bluegene],
	[Configure for Blue Gene; the specific BG model must be given as argument (=L/P/Q).])],
	[if test "x$enableval" != "xno" ; then
	   configure_bluegene="yes"
	   enableval_uc=`echo ${enableval} | awk {'print toupper($_)'}`
	   if test "x$enableval_uc" = xL || test "x$enableval_uc" = xP || test "x$enableval_uc" = xQ; then
	     bluegene_architecture="$enableval_uc"
           else
             echo
	     AC_MSG_ERROR([Only L, P, or Q are valid arguments for --enable-bluegene.])
           fi
         fi],[])

if test "x$configure_bluegene" = xno ; then
  AC_MSG_RESULT(no)
else
  AC_MSG_RESULT([yes ($bluegene_architecture)])
fi

# register variable IS_BLUEGENE to be visible in Makefile.am
AM_CONDITIONAL(IS_BLUEGENE, test "x$configure_bluegene" != xno)


# Manually activate MPI, allow to specify directory containing MPI
#
# Modified from H. E. Plesser, 2007-01-05
NS_distributed="unset"
NS_mpi_prefix="unset"
NS_mpi_option="no"

if test "x$configure_bluegene" = xyes ; then
  NS_distributed=set
  NS_mpi_option=yes
  if test "x$bluegene_architecture" = xL; then
    AC_DEFINE(IS_BLUEGENE_L, 1, [Configuring for Blue Gene/L])
    bluegene_dynamic_libs=no # no dynamic libs on BG/L
  elif test "x$bluegene_architecture" = xP; then
    AC_DEFINE(IS_BLUEGENE_P, 1, [Configuring for Blue Gene/P])
    bluegene_dynamic_libs=yes
  elif test "x$bluegene_architecture" = xQ ; then
    AC_DEFINE(IS_BLUEGENE_Q, 1, [Configuring for Blue Gene/Q])
    bluegene_dynamic_libs=yes
  fi
else
  AC_ARG_WITH(mpi,[  --with-mpi[[=directory]]	Request compilation with MPI; optionally give directory with MPI installation.],
  [
    if test "$withval" = "yes" ; then
      NS_distributed="set"
      NS_mpi_option="yes"
    elif test "$withval" != "no" ; then
      NS_distributed="set"
      NS_mpi_prefix=`echo ${withval} | sed 's/\/*$//'` # remove trailing slashes
      NS_mpi_option="yes"
    fi
  ])
fi

# Set the platform-dependent compiler flags based on the canonical
# host string.  These flags are placed in AM_{C,CXX}FLAGS.  If
# {C,CXX}FLAGS are given as environment variables, then they are
# appended to the set of automatically chosen flags.  After
# {C,CXX}FLAGS have been read out, they must be cleared, since
# system-dependent defaults will otherwise be placed into the
# Makefiles.  HEP 2004-12-20.

# Before we can determine the proper compiler flags, we must know
# which compiler we are using.  Since the pertaining AC macros run the
# compiler and set CFLAGS, CXXFLAGS to system-dependent values, we
# need to save command line/enviroment settings of these variables
# first. AC_AIX must run before the compiler is run, so we must run it
# here.
# HEP 2004-12-21

# Compiler selection:
# - C compiler is chosen using AC_PROG_CC. C code occurs only in a
#   few files in librandom. None of that code is MPI related.
#
# - C++ compiler is chosen as follows if distributed simulation is
#   chosen:
#
#   1. If simulation is not distributed, use AC_PROC_CXX.
#   2. Otherwise, if no prefix is given, search for mpiCC or equivalent
#      using AC_PROG_CXX(mpiCC).
#      Search order can be influenced by setting PATH before calling
#      configure.
#   3. If distributed simulation is requested and a prefix given, use
#      standard compiler from AC_PROG_CXX and check for libraries in
#      prefix directory.
#   4. Setting CXX overrides compiler selection brute force. AC_PROG_CXX
#      handles this.
#   5. The final configuration is tested for if it works.
#
# HEP 2007-01-03

NS_SAVE_CFLAGS="$CFLAGS"
NS_SAVE_CXXFLAGS="$CXXFLAGS"
NS_SAVE_LDFLAGS="$LDFLAGS"

AC_AIX

AC_PROG_CC

if test "$NS_distributed" = unset ; then

  # no-distributed simulation
  AC_PROG_CXX

else

  # Here we assume that the wrappers work. If an
  # explicit mpi-path is given, we add its bin to PATH first, then
  # test, and then redefine the compiler variables to full path
  # names. This is necessary since AC_PROG_CXX internally searches
  # through the entire PATH; since AC_PROG_CXX contains many checks
  # in addition to the search, we cannot simply write our own
  # absolute-path version.
  #
  # Search for MPI C++ compiler wrapper:
  # 1. Search for mpicxx, since mpicc and mpiCC are the same file
  #    on non-case-sensitive file systems (most OSX filesystems).
  # 2. Search for mpiCC, which is MPICH standard

  if test "$NS_mpi_prefix" = unset ; then
    AC_PROG_CXX(mpicxx mpiCC)
  else
    NS_SAVE_PATH=$PATH
    # add /bin, avoiding duplicate //
    mpi_bin=${NS_mpi_prefix}/bin

    PATH=${mpi_bin}:$PATH
    AC_PROG_CXX(mpicxx mpiCC)

    # If mpicxx or mpiCC are chosen, we check if they exists in the prefix
    # path. If so, we add the prefix path. Otherwise, we leave CXX untouched.
    if test $CXX = mpicxx -o $CXX = mpiCC ; then
      if test -x ${mpi_bin}/$CXX ; then
        CXX=$mpi_bin/$CXX
        ac_ct_CXX=$CXX
        ac_cv_prog_ac_ct_CXX=$CXX
      fi
    fi
    PATH=$NS_SAVE_PATH
  fi

fi
# further processing of distributed case below (see NS_NEW_PATH_MPI)

AM_PATH_PYTHON
AM_CONDITIONAL([HAVE_PYTHON], [test "$PYTHON" != [:]])
if test $PYTHON != [:]; then
  PYTHON_INCLUDE=`$PYTHON -c 'from distutils import sysconfig;\
  			      print (sysconfig.get_python_inc ())'`
fi

NS_SET_CFLAGS
CFLAGS=
NS_SET_CXXFLAGS
CXXFLAGS=
NS_SET_LDFLAGS
LDFLAGS=

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
AC_PROG_LIBTOOL

#-- Set the language to C++
AC_LANG_CPLUSPLUS

# For a description of MPI detection, see comment on compiler selection.
if test "$NS_distributed" = "set"; then
  if test "x$configure_bluegene" = xyes ; then
    BLUEGENE_MPI
  else
    NS_NEW_PATH_MPI
  fi
  AC_DEFINE(HAVE_MPI, 1, [Compile for MPI])
fi

AC_SUBST(MPI_LIBS)
AC_SUBST(MPI_INCLUDE)
AC_SUBST(PYTHON_INCLUDE)
AC_SUBST(INCLTDL)
AC_SUBST(LIBLTDL)
AC_SUBST(HAVE_LIBLTDL)
AC_SUBST(LIBADD_DL)

AC_CONFIG_FILES([
  Makefile
  neurosim/Makefile
  neurosim/version.h
  neurosim/examples/Makefile
  libpyneurosim/Makefile
])

AC_OUTPUT

dnl Local Variables:
dnl comment-start: "dnl "
dnl comment-end: ""
dnl comment-start-skip: "\\bdnl\\b\\s *"
dnl End:
