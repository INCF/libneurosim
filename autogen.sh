#!/bin/sh

[ -f autogen.sh ] || {
  echo "autogen.sh: run this command only at the top of the source tree."
  exit 1
}

if test -z "$AUTOMAKE" ; then
 for each in automake ; do
   AUTOMAKE=$each
   if test -n "`which $each 2>/dev/null`" ; then break ; fi
 done
fi

if [ `uname -s` = Darwin ] ; then
# libtoolize is glibtoolize on OSX
  LIBTOOLIZE=glibtoolize
else  
  LIBTOOLIZE=libtoolize
fi

./aclocal.sh &&
echo $LIBTOOLIZE --force --copy --automake --ltdl &&
$LIBTOOLIZE --force --copy --automake --ltdl &&
echo autoheader &&
autoheader &&
echo autoconf &&
autoconf &&
echo $AUTOMAKE --foreign --copy --add-missing &&
$AUTOMAKE --foreign --copy --add-missing &&
echo Now run configure and make.
