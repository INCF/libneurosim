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
#include <map>
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

static lt_dlhandle
loadLibrary (std::string library)
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

  return dl;
}

struct CGImplementation {
  CGImplementation (ParseCGFunc pcg,
		    ParseCGFunc pcgFile, 
		    ParseCGCFunc pcgc,
		    ParseCGCFunc pcgcFile)
    : CGFromXML (pcg),
      CGFromXMLFile (pcgFile),
      CGCFromXML (pcgc),
      CGCFromXMLFile (pcgcFile){ }
  CGImplementation () { }
  ParseCGFunc CGFromXML;
  ParseCGFunc CGFromXMLFile;
  ParseCGCFunc CGCFromXML;
  ParseCGCFunc CGCFromXMLFile;
};

typedef std::map<std::string, CGImplementation> tagRegistryT;

static tagRegistryT tagRegistry;

typedef std::map<std::string, CGImplementation> libraryRegistryT;

static libraryRegistryT libraryRegistry;

void
ConnectionGenerator::selectCGImplementation (std::string tag,
					     std::string library)
{
  loadLibrary (library);

  if (libraryRegistry.find (library) == libraryRegistry.end ())
    {
      std::cerr << "Library " << library << " not registered" << std::endl;
      abort ();
    }
  tagRegistry.insert (std::make_pair(tag, libraryRegistry[library]));
}

ConnectionGenerator*
ConnectionGenerator::fromXML (std::string xml)
{
  // Jochen: Parse outer xml expression and retrieve tag:
  std::string tag = "CSA"; // direct assignment for now
  tagRegistryT::iterator pos = tagRegistry.find (tag);
  if (pos == tagRegistry.end ())
    {
      std::cerr << "fromXML: implementation for tag " << tag << " not selected"
		<< std::endl;
      abort ();
    }
  ParseCGFunc parseCG = pos->second.CGFromXML;
  return parseCG (xml);
}

ConnectionGenerator*
ConnectionGenerator::fromXMLFile (std::string fname)
{
  // Jochen: Parse outer xml expression and retrieve tag:
  std::string tag = "CSA"; // direct assignment for now
  tagRegistryT::iterator pos = tagRegistry.find (tag);
  if (pos == tagRegistry.end ())
    {
      std::cerr << "fromXMLFile: implementation for tag " << tag
		<< " not selected" << std::endl;
      abort ();
    }
  ParseCGFunc parseCG = pos->second.CGFromXMLFile;
  return parseCG (fname);
}

ConnectionGeneratorClosure*
ConnectionGeneratorClosure::fromXML (std::string xml)
{
  return 0;
}

ConnectionGeneratorClosure*
ConnectionGeneratorClosure::fromXMLFile (std::string fname)
{
  return 0;
}

void
registerConnectionGeneratorLibrary (std::string library,
				    ParseCGFunc pcg,
				    ParseCGFunc pcgFile,
				    ParseCGCFunc pcgc,
				    ParseCGCFunc pcgcFile)
{
  libraryRegistry.insert (std::make_pair (library,
					  CGImplementation (pcg,
							    pcgFile,
							    pcgc,
							    pcgcFile)));
}
