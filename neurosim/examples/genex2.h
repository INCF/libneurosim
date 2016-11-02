/*
 *  genex.h
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

#ifndef GENEX2_H
#define GENEX2_H

#include <neurosim/connection_generator.h>

class AllToAllWD : public CGEN::ConnectionGeneratorT<double, double> {
  class Connections : public CGEN::Connections<double, double> {
  private:
    CGEN::Mask mask_;
  public:
    Connections (CGEN::Mask& mask,
		 int threadNum = 0,
		 std::shared_ptr<CGEN::Parameters> par
		 = std::make_shared<CGEN::Parameters> ())
      : mask_ (mask)
    {
      (void) threadNum;
      (void) par;
    }
    
    void iterate (CGEN::SourceFirstIterable<double, double>* iterable)
    {
      for (auto ival : mask_.targets)
	for (auto target = ival.begin ();
	     target != ival.end ();
	     target += mask_.targets.skip ())
	  {
	    iterable->target (target);
	    for (auto ival : mask_.sources)
	      for (auto source = ival.begin ();
		   source != ival.end ();
		   source += mask_.sources.skip ())
		iterable->connection (source, target, 1.0, 1e-3);
	  }
    }
  };
public:
  int arity () const { return 2; }
    
  std::unique_ptr<CGEN::Connections<double, double>>
    connections (CGEN::Mask& mask,
		 int threadNum = 0,
		 std::shared_ptr<CGEN::Parameters> par
		 = std::make_shared<CGEN::Parameters> ())
  {
    std::unique_ptr<CGEN::Connections<double, double>> c
    { new Connections (mask, threadNum, par) };
    return c;
  }
};

// Local Variables:
// mode:c++
// End:

#endif /* #ifndef GENEX2_H */
