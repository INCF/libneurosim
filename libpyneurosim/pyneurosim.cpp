/*
 *  pyneurosim.cpp
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

#include "pyneurosim.h"

#include <vector>

namespace PNS {

  struct ConnGenType {
    ConnGenType (CheckFuncT checkFunc, UnpackFuncT unpackFunc)
      : isConnectionGenerator (checkFunc),
	unpackConnectionGenerator (unpackFunc) { }
    CheckFuncT isConnectionGenerator;
    UnpackFuncT unpackConnectionGenerator;
  };

  typedef std::vector<ConnGenType> ConnGenTypes;

  static ConnGenTypes connGenTypes;

  bool
  isConnectionGenerator (PyObject* pObj)
  {
    for (ConnGenTypes::iterator type = connGenTypes.begin ();
	 type != connGenTypes.end ();
	 ++type)
      if (type->isConnectionGenerator (pObj))
	return true;
    return false;
  }

  ConnectionGenerator*
  unpackConnectionGenerator (PyObject* pObj)
  {
    for (ConnGenTypes::iterator type = connGenTypes.begin ();
	 type != connGenTypes.end ();
	 ++type)
      if (type->isConnectionGenerator (pObj))
	return type->unpackConnectionGenerator (pObj);
    //*fixme* Add proper error handling
    return 0;
  }

  void
  registerConnectionGeneratorType (CheckFuncT checkFunc, UnpackFuncT unpackFunc)
  {
    connGenTypes.push_back (ConnGenType (checkFunc, unpackFunc));
  }

}
