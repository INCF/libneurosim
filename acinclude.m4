dnl DO NOT USE cvs/rcs keyword replacement here!!
dnl
dnl @synopsis NS_SET_CXXFLAGS
dnl
dnl Set flags for various C++ compilers.
dnl Each compiler has a different set of options
dnl so we try to identify the compiler and set the
dnl corresponding options.
dnl Moreover, some compilers like to handle the AR stage of
dnl static library creation (SUN and SGI CC). This is also handled
dnl here.
dnl
dnl Please do not handle C flags here, use
dnl NS_SET_CFLAGS below for this purpose.
dnl here.
dnl
dnl @author Marc-Oliver Gewaltig
dnl rewritten: 2002-11-15

AC_DEFUN([NS_SET_CXXFLAGS],\
[
# Find which compiler C++ compiler we have to switch compiler flags
# add more conditionals for further compilers:
# However, things are slightly more complicated, since compilers
# on different systems might have the same name (e.g. CC on Irix and Solaris)
# Thus, we first check whether a GNU compiler was diagnosed. If not,
# we assume that the Proprietary compiler is presents by checking the
# OS-name
#
#
#   -ansi removed from C compilation because of problem with GSL
#   Diesmann, 23.08.02 
#

NS_CXXBACKEND=
NS_cxxflags=
NS_threadflags=

# conditional default, 19.11.04 MD
#

if (! test "$CXX_AR") ; then
 CXX_AR="ar cru"
fi

##
## Section for general flags.
##
# compressed target lists ?
if test "$NS_compression" = yes ; then
 NS_cxxflags="-DCOMPR_CONMAT"
fi

# We first branch for the plaform and then branch on the compiler.
# Thus, it is possible to enable platform specific optimizations
# even if GCC is used.
echo "Platform: ${host}"
 case ${host} in
   *linux*)
     if test "$GXX" = "yes"; then
       compversion=`$CXX --version`
       if test "${compversion:0:4}" = "icpc"; then
         # Intel compiler pretending to be g++
	 echo "Compiler : icpc"
         if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
           NS_debugflags="-g -inline-debug-info"
         fi
         if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
           NS_warningflags="-w1"
         fi
         if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
           NS_optimizeflags="-O3 -mp"
         fi
       else
         #real g++
         echo "Compiler : g++"
         if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
           NS_debugflags="-g"
         fi
         if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
           NS_warningflags="-W -Wall -pedantic -Wno-long-long"
         fi
         if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
           NS_optimizeflags="-O3"
         fi
       fi
     fi
     if test "x$enable_bluegene" = xyes; then
	  echo "Compiling for the Blue Gene using compilers specified by CC and CXX environment variables"
	  if test "$NS_debug" = "set"; then
            NS_debugflags=" "
          fi
          if test "$NS_warning" = "set"; then
            NS_warningflags=" "
          fi
          if test "$NS_optimize" = "set"; then
            NS_optimizeflags=" "
          fi
     fi
   ;;
   sparc*-sun-solaris2.*)
     NS_forte=`$CXX -V 2>&1 | grep Forte`
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2 -mcpu=v9"
       fi
     fi
     if test -n "$NS_forte"; then
       echo "Compiler : $NS_forte"
       CXX_AR="$CXX -xar -o"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="+w"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-fast"
       fi
       if test -z "$NS_threadflags"; then 
         NS_threadflags="-mt"
       fi
     else # Version 8 is no longer called Forte, but Sun C++
       NS_forte=`$CXX -V 2>&1 | grep Sun`

       if test -n "$NS_forte"; then	
         echo "Compiler : $NS_forte"
         CXX_AR="$CXX -xar -o"
         if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
           NS_debugflags="-g"
         fi
         if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
           NS_warningflags="+w"
         fi
         if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
           NS_optimizeflags="-fast"
         fi
         if test -z "$NS_threadflags"; then 
           NS_threadflags="-mt"
         fi
       fi
      fi
     ;;
   *-hp-hpux*)
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       NS_cxxflags="${NS_cxxflags} -AA"
     fi
     ;;
   mips-sgi-irix*)
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       NS_cxxflags="${NS_cxxflags} -LANG:std"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags=""
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-64 -mips4"
       fi
     fi
   ;;
   *-dec-osf*)
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O3 -mieee"
       fi
     else
       echo "Compiler: $CXX"
       NS_cxxflags="${NS_cxxflags} -std strict_ansi -ieee -denorm -underflow_to_zero -nofp_reorder -pthread -lm -ptr ../cxx_r"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-fast -arch host -tune host "
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-std strict_ansi"
       fi
     fi
   ;;
   hppa1.1-hitachi-hiuxwe2*)
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       echo "Compiler: $CXX"
       NS_CXXBACKEND="--backend -loopfuse --backend -noparallel"
       CXX_AR="KCC -o"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O3 -lp64"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags=""
       fi
     fi
   ;;
   powerpc-ibm-aix5.1*)
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       echo "Compiler: $CXX"
       NS_cxxflags="${NS_cxxflags} -qrtti=all"

       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags=""
       fi
     fi
   ;;
   *)
     ## For all other OS, we just check for the GNU compiler.
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic -Wno-long-long"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O3"
       fi
     fi		
     ;;
 esac

##
## Now compose the automake Macro.
## 
## CXXFLAGS now appended instead of prepended, so that it can 
## override default values.
AM_CXXFLAGS="$NS_threadflags $NS_cxxflags $NS_warningflags $NS_debugflags $NS_optimizeflags $NS_SAVE_CXXFLAGS" 

echo "Using AM_CXXFLAGS= $AM_CXXFLAGS"
AC_SUBST(NS_CXXBACKEND)
AC_SUBST(AM_CXXFLAGS)
AC_SUBST(CXX_AR)
])

dnl @synopsis NS_SET_CFLAGS
dnl
dnl Set flags for various C-compilers.
dnl Each compiler has a different set of options
dnl so we try to identify the compiler and set the
dnl corresponding options.
dnl
dnl Please do not handle C++ flags here, use
dnl NS_SET_CXXFLAGS for this purpose.
dnl here.
dnl
dnl @author Marc-Oliver Gewaltig
dnl rewritten: 2002-11-15

AC_DEFUN([NS_SET_CFLAGS],\
[
# Find which compiler C we have to switch compiler flags
# add more conditionals for further compilers:
# However, things are slightly more complicated, since compilers
# on different systems might have the same name (e.g. CC on Irix and Solaris)
# Thus, we first check whether a GNU compiler was diagnosed. If not,
# we assume that the Proprietary compiler is presents by checking the
# OS-name
#
#
NS_cflags=

# commented emptying CFLAGS, 19.11.04 MD
#
#CFLAGS=

##
## Section for general flags.
##
# compressed target lists ?

if test "$NS_compression" = yes ; then
 NS_cflags="-DCOMPR_CONMAT"
fi

# We first branch for the plaform and then branch on the compiler.
# Thus, it is possible to enable platform specific optimizations
# even if GCC is used.
echo "Platform: ${host}"
 case ${host} in
   *linux*)
     if test "$GCC" = "yes"; then
       compversion=`$CC --version`
       if test "${compversion:0:3}" = "icc"; then
         # Intel compiler pretending to be gcc
	 echo "Compiler : icc"
         if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
           NS_debugflags="-g -inline-debug-info"
         fi
         if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
           NS_warningflags="-w1"
         fi
         if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
           NS_optimizeflags="-O3 -mp"
         fi
       else
         #real g++
         echo "Compiler : gcc"
         if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
           NS_debugflags="-g"
         fi
         if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
           NS_warningflags="-W -Wall -pedantic -Wno-long-long"
         fi
         if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
           NS_optimizeflags="-O3"
         fi
       fi
     fi
     if test "x$enable_bluegene" = xyes; then
	 echo "Compiling for the Blue Gene using compilers specified by CC and CXX environment variables"	
       	  if test "$NS_debug" = "set"; then
            NS_debugflags=" "
          fi
          if test "$NS_warning" = "set"; then
            NS_warningflags=" "
          fi
          if test "$NS_optimize" = "set"; then
            NS_optimizeflags=" "
          fi
      fi
   ;;
   sparc*-sun-solaris2.*)
     NS_forte=`$CC -V 2>&1 | grep Forte`
     if test "$GCC" = "yes"; then
       echo "Compiler : gcc"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2 -mcpu=v9"
       fi
     fi
    if test -n "$NS_forte"; then
       echo "Compiler: $NS_forte"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="+w"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-fast"
        fi
       if test -z "$NS_threadflags"; then 
         NS_threadflags="-mt"
       fi
    fi
    ;;
   *-hp-hpux*)
     if test "$GCC" = "yes"; then
       echo "Compiler: gcc"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       NS_cflags="-AA"
     fi
   ;;
   mips-sgi-irix*)
     if test "$GCC" = "yes"; then
       echo "Compiler: gcc"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags=""
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-64 -mips4"
       fi
     fi
   ;;
   *-dec-osf*)
     if test "$GCC" = "yes"; then
       echo "Compiler: gcc"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O3 -mieee"
       fi
     else
       echo "Compiler: $CC"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-fast -arch host -tune host -ieee -nofp_reorder "
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags=""
       fi
     fi
   ;;
   hppa1.1-hitachi-hiuxwe2*)
     if test "$GCC" = "yes"; then
       echo "Compiler: gcc"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       echo "Compiler: $CC"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O3 -lp64"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags=""
       fi
     fi
   ;;
   powerpc-ibm-aix5.1*)
     if test "$GCC" = "yes"; then
       echo "Compiler : gcc"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
     else
       echo "Compiler: $CC"

       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O2"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags=""
       fi
     fi
   ;;
   *)
     ## For all other OS, we just check for the GNU compiler.
     if test "$GXX" = "yes"; then
       echo "Compiler : g++"
       if test "$NS_debug" = "set" -a -z "$NS_debugflags"; then
         NS_debugflags="-g"
       fi
       if test "$NS_warning" = "set" -a -z "$NS_warningflags"; then 
         NS_warningflags="-W -Wall -pedantic -Wno-long-long"
       fi
       if test "$NS_optimize" = "set" -a -z "$NS_optimizeflags"; then 
         NS_optimizeflags="-O3"
       fi
     fi		
     ;;
 esac

##
## Now compose the automake Macro.
##
## CFLAGS now appended instead of prepended, so that it can 
## override default values.

AM_CFLAGS="$NS_threadflags $NS_cflags $NS_warningflags $NS_debugflags $NS_optimizeflags $NS_SAVE_CFLAGS" 
echo "Using AM_CFLAGS= $AM_CFLAGS"
AC_SUBST(AM_CFLAGS)
])


dnl @synopsis NS_SET_LDFLAGS
dnl
dnl @author Mikael Djurfeldt
dnl written: 2016-10-18

AC_DEFUN([NS_SET_LDFLAGS],\
[
AM_LDFLAGS="$NS_SAVE_LDFLAGS"
echo "Using AM_LDFLAGS= $AM_LDFLAGS"
])


# configure use of MPI
#
# 0. Must be run after GSL_CFLAGS and GSL_LIBS have their final values.
# 1. We may have a compiler wrapper that fixes everything for us.
#    Thus, test first if an mpi program links out of the box.
# 2. If not, try various compiler and linker flags.
#    If successful, test final setup.
# 3. If all tests pass, export HAVE_MPI, MPI_INCLUDE, MPI_LIBS
# Modified from HEP 2007-01-03
AC_DEFUN([NS_NEW_PATH_MPI],
[
  NS_mpi_include=""
  NS_mpi_libs=""

  # In particular GSL may introduce -L flags that upset which MPI libs
  # are loaded. To catch such cases, we need to compile our tests with
  # GSL_CFLAGS and GSL_LIBS.
  tmpcxx=$CXXFLAGS
  tmpld=$LDFLAGS
  CXXFLAGS="$AM_CXXFLAGS $GSL_CFLAGS"
  LDFLAGS="$AM_LDFLAGS $GSL_LIBS"

  # initial test, detects working wrappers
  AC_MSG_CHECKING([whether $CXX links MPI programs out of the box])
  AC_TRY_LINK([
#include <mpi.h>
 ],[int* a=0; char*** b=0; MPI_Init(a,b);], 
   NS_mpi_link_ok=yes,
   NS_mpi_link_ok=no)
  AC_MSG_RESULT($NS_mpi_link_ok)

  CXXFLAGS=$tmpcxx
  LDFLAGS=$tmpld

  if test $NS_mpi_link_ok != yes ; then

    # try to find a candidate setup
    NS_have_mpi_candidate=no

    if test $NS_mpi_prefix = unset ; then
      AC_CHECK_LIB(mpi,MPI_Init, NS_mpi_libs="-lmpi_cxx -lmpi" \
	           NS_have_mpi_candidate=yes, 
                   [                  

                   # nothing found in default location, try via mpirun
                   AC_MSG_CHECKING(for MPI location using mpirun)

                   # Do not test "which" results for emptyness, many shells return
                   # diagnostic messages if no program is found. Rather, check 
                   # that the result is an executable file. 
                   # Redirect diagnostic output from which to /dev/null
                   # HEP 2006-06-30
                   e=`which mpirun 2> /dev/null`
                   if test -n "$e" && test -x $e ; then
                     p=${e:0:${#e}-11}
                     AC_MSG_RESULT($p) 

                     tmpcxx=$CXXFLAGS
                     tmpld=$LDFLAGS
                     CXXFLAGS="$AM_CXXFLAGS $GSL_CFLAGS $rp -I$p/include"
                     LDFLAGS="$AM_LDFLAGS $GSL_LIBS -L$p/lib64 -L$p/lib -lmpi_cxx -lmpi"
                     AC_CHECK_LIB(mpi,MPI_Init, 
                                  NS_mpi_include="$rp -I$p/include" \
                                  NS_mpi_libs="-L$p/lib64 -L$p/lib -lmpi_cxx -lmpi" \
  	                          NS_have_mpi_candidate=yes)
                     CXXFLAGS=$tmpcxx
                     LDFLAGS=$tmpld
                    fi
                   ]
                  )

    else

      tmpcxx=$CXXFLAGS
      tmpld=$LDFLAGS
      CXXFLAGS="$AM_CXXFLAGS $GSL_CFLAGS $rp -I${NS_mpi_prefix}/include"
      LDFLAGS="$AM_LDFLAGS $GSL_LIBS -L${NS_mpi_prefix}/lib64 -L${NS_mpi_prefix}/lib -lmpi_cxx -lmpi"
      AC_CHECK_LIB(mpi,MPI_Init, \
                   NS_mpi_include="$rp -I${NS_mpi_prefix}/include" \
                   NS_mpi_libs="-L${NS_mpi_prefix}/lib64 -L${NS_mpi_prefix}/lib -lmpi_cxx -lmpi" \
                   NS_have_mpi_candidate=yes)
      CXXFLAGS=$tmpcxx
      LDFLAGS=$tmpld

    fi
   
    if test $NS_have_mpi_candidate = no ; then
      AC_MSG_ERROR(No sensible MPI setup found. Check your installation!)
    fi 

    # we now have a candidat setup, test it
    AC_MSG_CHECKING([whether MPI candidate $CXX $NS_mpi_include $NS_mpi_libs works])

    tmpcxx=$CXXFLAGS
    tmpld=$LDFLAGS
    CXXFLAGS="$AM_CXXFLAGS $GSL_CFLAGS $NS_mpi_include"
    LDFLAGS="$AM_LDFLAGS $GSL_LIBS $NS_mpi_libs"
    NS_mpi_link_ok=no

    AC_TRY_LINK([
#include <mpi.h>
    ],[int* a=0; char*** b=0; MPI_Init(a,b);], 
    NS_mpi_link_ok=yes,
    [
      # Brute force attempt to salvage things
      # according to mpicc, the repetition -lmpich -lpmpich -lmpich is required
      # it also says that on IRIX this may fail
      #
      # MPICH uses non-standard C++ long long
      # gcc-3.3.1 with -pedantic reports this as an error.
      # -Wno-long-long prohibits the generation of an error.
      # Sep 23. 2003, Diesmann
      CXXFLAGS="${CXXFLAGS} -Wno-long-long"
      if test $NS_mpi_prefix = unset ; then
        retest_ld="-lmpich -lpmpich -lmpich" 
      else
        retest_ld="-L${NS_mpi_prefix}/lib -lmpich -lpmpich -lmpich" 
      fi
      LDFLAGS="${AM_LDFLAGS} $GSL_LIBS ${retest_ld}"
      AC_TRY_LINK([
#include <mpi.h>
      ],[int* a=0; char*** b=0; MPI_Init(a,b);], 
      NS_mpi_link_ok=yes \
      NS_mpi_include="${NS_mpi_include} -Wno-long-long" \
      NS_mpi_libs="$retest_ld")
      ])
    AC_MSG_RESULT($NS_mpi_link_ok)

    CXXFLAGS=$tmpcxx
    LDFLAGS=$tmpld

  fi

  if test $NS_mpi_link_ok = yes ; then
    AC_DEFINE(HAVE_MPI,1, [MPI is available.])
    AC_SUBST(HAVE_MPI)
    MPI_INCLUDE=$NS_mpi_include
    AC_SUBST(MPI_INCLUDE)
    MPI_LIBS=$NS_mpi_libs
    AC_SUBST(MPI_LIBS)
  else
    AC_MSG_ERROR(The MPI candidate did not work. Check your installation!)
  fi 
])



# configure use of MPI for Blue Gene
#
#    We require a compiler wrapper that links the correct libraries
#    therefore, mpi programs should link out of the box.
# AM 2008-05-15
AC_DEFUN([BLUEGENE_MPI],
[
 
  # detect C++ wrapper
  AC_MSG_CHECKING([whether $CXX links MPI programs out of the box])
  AC_LINK_IFELSE([AC_LANG_PROGRAM(
  [[#include <mpi.h>]],
  [int* a=0; char*** b=0; MPI_Init(a,b);])], 
  [BG_CXX_mpi_link_ok=yes],
  [BG_CXX_mpi_link_ok=no])
  AC_MSG_RESULT($BG_CXX_mpi_link_ok)	
 
  if test $BG_CXX_mpi_link_ok = yes ; then
    AC_DEFINE(HAVE_MPI,1, [MPI is available.])
    AC_SUBST(HAVE_MPI)
  else
    AC_MSG_ERROR(Your CXX environment variable must be set to a valid wrapper script to compile C++ programs on Blue Gene.)
  fi 
])
