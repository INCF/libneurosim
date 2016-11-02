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

#include "simulator-model.h"
#include "genex1.h"

int
main (int argc, char* argv[])
{
  (void) argc;
  
  int end = std::stoi (argv[1]);

  SIM::Simulator sim;
  auto cg = new AllToAllWD ();
  
  ConnectionGenerator::Mask mask;
  mask.sources.insert (0, end - 1);
  mask.targets.insert (0, end - 1);

  cg->setMask (mask);

  cg->start ();
  
  int source;
  int target;
  double params[2];
  while (cg->next (source, target, &params[0]))
    {
      sim.connect (sim.remap (source),
		   sim.remap (target),
		   params[0],
		   params [1]);
    }

  delete cg;
}
