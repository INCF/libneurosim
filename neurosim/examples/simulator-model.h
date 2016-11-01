/*
 *  simulator-model.h
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

#ifndef SIMULATOR_MODEL_H
#define SIMULATOR_MODEL_H

namespace SIM {
  
  class Simulator {
  public:
    int remap (int gid); // Emulate remapping of gid
    void connect (int source, int target, double weight, double delay);
  };

}

// Local Variables:
// mode:c++
// End:

#endif /* #ifndef SIMULATOR_MODEL_H */
