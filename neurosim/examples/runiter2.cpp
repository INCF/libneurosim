/*
 *  runiter2.cpp
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

#include <string>
#include <iostream>
#include "simulator-model.h"
#include "genex2.h"

class Iterable : public CGEN::SourceFirstIterable<double, double> {
  SIM::Simulator& sim_;
  int remappedTarget_;
public:
  Iterable (SIM::Simulator& sim) : sim_ {sim} { }
  void target (int target)
  {
    remappedTarget_ = sim_.remap (target);
  }
	    
  void connection (int source, int target, double weight, double delay)
  {
    (void) target;
    sim_.connect (sim_.remap (source), remappedTarget_, weight, delay);
  }
};

int
main (int argc, char* argv[])
{
  (void) argc;
  
  int end = std::stoi (argv[1]);

  SIM::Simulator sim;
  auto cg = new AllToAllWD ();
  
  CGEN::Mask mask;
  mask.sources.insert (0, end);
  mask.targets.insert (0, end);

  auto connections = cg->connections (mask);

  Iterable iterable (sim);
  connections->iterate (&iterable);

  delete cg;
}
