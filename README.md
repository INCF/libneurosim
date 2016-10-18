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
