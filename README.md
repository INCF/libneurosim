## What is libneurosim?

libneurosim is a general library that provides interfaces and common
utility code for neuronal simulators.

Currently it provides the ConnectionGenerator interface.

The ConnectionGenerator API is a standard interface supporting
efficient generation of network connectivity during model setup in
neuronal network simulators. It is intended as an abstraction
isolating both sides of the API: any simulator can use a given
connection generator and a given simulator can use any library
providing the ConnectionGenerator interface. It was initially
developed to support the use of libcsa from NEST.

## Using python

libpyneurosim is a library provided to support the usage of connection
generators written in Python from a neuronal simulator written in
C++. That is, it is *not* an extension library to the Python scripting
language. In order to simultaneously support the use of Python 2 and
3, the library is installed with names libpy2neurosim and
libpy3neurosim.

To build libpyneurosim (provided for backward compatibility) and
libpy2neurosim, which link with Python version 2, add the configure
option

  --with-python=2

To build libpy3neurosim, which links with Python version 3, configure
with

  --with-python=3

You can only build for one Python version at a time, but libraries can
be installed in parallel.

## Required external packages

libneurosim can be linked to MPI if it will be linked to a parallel
simulator.

## Where to find more information

The ConnectionGenerator API is described in
[Djurfeldt et al. (2014)](http://dx.doi.org/10.3389/fninf.2014.00043).

## Submitting bug reports

Bug reports can be filed as issues on GitHub.

## Contributions welcome!

Currently, libneurosim is only supported by the
[NEST](http://github.com/nest/nest-simulator) simulator and only
provides the Connection Generator Interface.

This should change.

If you are developing algorithms that are usable by different
simulators, we would be happy if you'd send us a pull request.
