/*
 *  connection_generator.h
 *
 *  This file is part of libneurosim.
 *
 *  Copyright (C) 2016 INCF
 *
 *  libneurosim is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  libneurosim is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#ifndef CONNECTION_GENERATOR_V2_0_H
#define CONNECTION_GENERATOR_V2_0_H

#include <vector>
#include <string>
#include <memory>

#include <neurosim/config.h>

#if NEUROSIM_HAVE_MPI
#include <mpi.h>
#endif

#if _OPENMP
#include <omp.h>
#endif

namespace CGEN {

  inline
  namespace V2_0 {

    /**
     * An Interval [FROM, TO) represents integers from FROM to, but
     * not including, TO.
     */
    class Interval {
      int from_;
      int to_;
    public:
      Interval (const int from, const int to) : from_ (from), to_ (to) { }

      /**
       * @return FROM element of Interval.
       */
      int from () const { return from_; }

      /**
       * @return TO of Interval (last element + 1).
       */
      int to () const { return to_; }

      /**
       * @return size of Interval.
       */
      int size () const { return to_ - from_; }

      /**
       * Set FROM element of Interval.
       */
      void setFrom (const int from) { from_ = from; }

      /**
       * Set TO of Interval.
       */
      void setTo (const int to) { to_ = to; }

      class const_iterator {
	int i_;
      public:
	const_iterator (int i) : i_ {i} { }
	operator int () const { return i_; }
	int operator* () const { return i_; }
	bool operator!= (const_iterator other) const { return i_ != other.i_; };
	const_iterator operator++ () { return const_iterator (++i_); }
	const_iterator operator+= (int skip) {
	  return const_iterator (i_ += skip);
	}
      };

      const_iterator begin () const { return const_iterator (from_); }
      const const_iterator end () const { return const_iterator (to_); }
    };

    /**
     * An IntervalSet represents a set of integers described by an
     * ordered set of Interval:s and a SKIP. The SKIP is a positive
     * integer (default value 1) describing the offset between members
     * (with first element of each Interval FROM) such that, e.g.:
     *
     * The IntervalSet {[0, 8), [16, 24)]} with SKIP 4 has members
     * {0, 4, 16, 20}
     *
     * An IntervalSet is guaranteed to be a subclass of
     * std::vector<Interval>.
     */
    class IntervalSet : public std::vector<Interval> {
      int skip_;
    public:
      IntervalSet (const int skip = 1) : skip_ (skip) { }
      int skip () const { return skip_; }
      void setSkip (const int skip) { skip_ = skip; }
      void insert (const int from, const int to) {
	push_back (Interval (from, to));
      }
    };

    class Mask {
    public:
      Mask (const int sourceSkip = 1, const int targetSkip = 1)
	: sources (sourceSkip), targets (targetSkip) { }
      IntervalSet sources;
      IntervalSet targets;
    };

    template <typename... Types>
    class SourceFirstIterable {
    public:
      virtual ~SourceFirstIterable () { }
      virtual void target (int target) { (void) target; }
      virtual void connection (int source, int target, Types...) = 0;
    };


    /*
     * The Context object should be created and configured by a single
     * thread, and the same instance should be shared between threads.
     */
    class Context {
      int threadsPerProcess_;
#if NEUROSIM_HAVE_MPI
      MPI_Comm communicator_;
#endif
    public:
#if NEUROSIM_HAVE_MPI
      Context ()
	: Context (1, MPI_COMM_NULL) { };
      Context (int threadsPerProcess, MPI_Comm communicator)
	: threadsPerProcess_ {threadsPerProcess},
	  communicator_ {communicator} { };
#else
      Context ()
	: Context (1) { };
      Context (int threadsPerProcess)
	: threadsPerProcess_ {threadsPerProcess} { };
#endif
      virtual ~Context () { }
      int threadsPerProcess () { return threadsPerProcess_; }
#if NEUROSIM_HAVE_MPI
      MPI_Comm communicator () { return communicator_; }
#endif
      /*
       * These functions should be used by connection generators for
       * thread support. The default implementation throws errors.
       */
      struct Lock { };
      virtual void initLock (Lock* lock);
      virtual void lock (Lock* lock);
      virtual void unlock (Lock* lock);
      virtual void destroyLock (Lock* lock);
      /* All threads must reach the barrier before any can proceed. */
      virtual void barrier ();
    };

    
#if _OPENMP
    class OpenMPContext : public Context {
    public:
      struct OpenMPLock : Lock {
	omp_lock_t lock;
      };
      void initLock (Lock* lock);
      void lock (Lock* lock);
      void unlock (Lock* lock);
      void destroyLock (Lock* lock);
      /* All threads must reach the barrier before any can proceed. */
      void barrier ();
    };
#endif

    
    /**
     * Pure abstract base class representing connections to iterate over
     */
    template <typename... Types>
    class Connections {
    public:
      virtual ~Connections () { }
      virtual void iterate (SourceFirstIterable<Types...>* iterable) = 0;
    };

    
    /**
     * Pure abstract base class for connection generators.
     *
     * TODO: Extend with a means of specifying the order of iteration
     * (sources or targets first)
     */
    class ConnectionGenerator {
    public:

      virtual ~ConnectionGenerator () { }

      /**
       * Return the number of values associated with this generator
       */
      virtual int arity () const = 0;

      static void selectCGImplementation (std::string tag, std::string library);

      static ConnectionGenerator* fromXML (std::string xml);

      static ConnectionGenerator* fromXMLFile (std::string fileName);

    private:

      /**
       * Parse an XML file or string and return the first tag's name. This
       * function skips the opening tag (<?xml ...>) and comments (<!--
       * ... -->) up to the first "real" tag and returns the name of
       * that. If there are no tags other than comments and the start tag,
       * the function returns an empty string as a result.
       */
      static std::string ParseXML(std::stringstream& xmlStream);
    };

    template <typename... Types>
    class ConnectionGeneratorT : public ConnectionGenerator {
    public:

      virtual std::shared_ptr<Connections<Types...>>
      connections (CGEN::Mask& mask,
		   int threadNum = 0,
		   std::shared_ptr<Context> par
		   = std::make_shared<Context> ()) = 0;

    };

#ifdef CONNECTION_GENERATOR_DEBUG
    ConnectionGenerator* makeDummyConnectionGenerator ();
#endif

    class ConnectionGeneratorClosure {
    public:
      static ConnectionGeneratorClosure* fromXML (std::string xml);
      static ConnectionGeneratorClosure* fromXMLFile (std::string fname);
      virtual ConnectionGenerator* operator() (...) { return 0; }
    };
    
    typedef ConnectionGenerator* (*ParseCGFunc) (std::string);
    
    typedef ConnectionGeneratorClosure* (*ParseCGCFunc) (std::string);

    void registerConnectionGeneratorLibrary (std::string library,
					     ParseCGFunc pcg,
					     ParseCGFunc pcgFile,
					     ParseCGCFunc pcgc,
					     ParseCGCFunc pcgcFile);
  }
}
	   
// Local Variables:
// mode:c++
// End:

#endif /* #ifndef CONNECTION_GENERATOR_V2_0_H */
