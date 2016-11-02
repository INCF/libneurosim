/*
 *  genex1.h
 *
 *  Copyright (C) 2016 Mikael Djurfeldt <mikael@djurfeldt.com>
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

#ifndef GENEX1_H
#define GENEX1_H

#include <neurosim/connection_generator.h>

class AllToAllWD : public ConnectionGenerator {
  Mask mask_;
  int source_;
  int target_;
  IntervalSet::iterator sourceIval_;
  IntervalSet::iterator targetIval_;
public:
  int arity () { return 2; }

  using ConnectionGenerator::setMask; // no overloading between scopes
  
  void setMask (std::vector<Mask>& masks, int local)
  {
    mask_ = masks[local];
  }

  void start ()
  {
    sourceIval_ = mask_.sources.begin ();
    source_ = sourceIval_->first;
    targetIval_ = mask_.targets.begin ();
    target_ = targetIval_->first;
  }

  bool next (int& source_r, int& target_r, double* value)
  {
    if (source_ <= sourceIval_->last)
      {
      again:
	source_r = source_;
	target_r = target_;
	value[0] = 1.0;
	value[1] = 1e-3;
	source_ += mask_.sources.skip ();
	return true;
      }
    ++sourceIval_;
    if (sourceIval_ != mask_.sources.end ())
      {
	source_ = sourceIval_->first;
	goto again;
      }
    target_ += mask_.targets.skip ();
    if (target_ <= targetIval_->last)
      goto again2;
    ++targetIval_;
    if (targetIval_ == mask_.targets.end ())
      return false;
    target_ = targetIval_->first;
  again2:
    sourceIval_ = mask_.sources.begin ();
    source_ = sourceIval_->first;
    goto again;
  }
};

// Local Variables:
// mode:c++
// End:

#endif /* #ifndef GENEX1_H */
