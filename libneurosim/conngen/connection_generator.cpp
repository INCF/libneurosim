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

ConnectionGenerator*
ConnectionGenerator::fromXML (std::string xml)
{
  return 0;
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
}
