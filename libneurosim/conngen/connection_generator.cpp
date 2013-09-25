/*
 *  connection_generator.cpp
 *
 *  This file is part of libneurosim.
 *
 *  Copyright (C) 2013 INCF
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

#include "connection_generator.h"

#include <iostream>
#include <ltdl.h>

ConnectionGenerator::~ConnectionGenerator ()
{}


void
ConnectionGenerator::setMask (Mask& mask)
{
  std::vector<Mask> m;
  m.push_back (mask);
  setMask (m, 0);
}


void
ConnectionGenerator::setMask (std::vector<Mask>&, int)
{}

/**
 * Default implementation of size ()
 */
int ConnectionGenerator::size ()
{
  start ();
  int i, j;
  double* vals = new double[arity ()];
  int n;
  for (n = 0; next (i, j, vals); ++n);
  delete[] vals;
  return n;
}

#ifdef CONNECTION_GENERATOR_DEBUG
/**
 * Default implementation of size ()
 */
class DummyGenerator : public ConnectionGenerator {
public:
  int arity () { return 2; }
  void setMask (std::vector<Mask>&, int) { }
  void start () { }
  bool next (int&, int&, double*) { return false; }
};

ConnectionGenerator* makeDummyConnectionGenerator ()
{
  return new DummyGenerator ();
}

#endif

// The following implementation is INCOMPLETE

void
ConnectionGenerator::selectCGImplementation (std::string tag,
					     std::string library)
{
  static bool dlInitialized;
  if (!dlInitialized)
    {
      if (lt_dlinit ())
	{
	  std::cerr << "Couldn't initialize libltdl" << std::endl;
	  abort ();
	}
      dlInitialized = true;
    }
  lt_dlhandle dl = lt_dlopen (library.c_str ());

  if (!dl)
    {
      //*fixme* Add proper error handling
      std::cerr << "Couldn't load library " << library << std::endl;
      abort ();
    }

}

struct CGImplementation {
  CGImplementation (ParseCGFunc pcg, ParseCGCFunc pcgc)
    : CGFromXML (pcg), CGCFromXML (pcgc) { }
  ParseCGFunc CGFromXML;
  ParseCGCFunc CGCFromXML;
};

typedef std::vector<CGImplementation> CGImplementationsT;

static CGImplementationsT CGImplementations;

ConnectionGenerator*
ConnectionGenerator::fromXML (std::string xml)
{
  ParseCGFunc parseCG = CGImplementations[0].CGFromXML;
  return parseCG (xml);
}

ConnectionGeneratorClosure*
ConnectionGeneratorClosure::fromXML (std::string xml)
{
  return 0;
}

void
registerConnectionGeneratorLibrary (std::string library,
				    ParseCGFunc pcg,
				    ParseCGCFunc pcgc)
{
  CGImplementations.push_back (CGImplementation (pcg, pcgc));
}
