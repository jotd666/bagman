/*---------------------------------------------------------------------------*
 *           (C) 2004-2008  -  JFF Software           *
 *---------------------------------------------------------------------------*/

/**
* @file MyMacros.H
* @brief C preprocessor macros used in the project
*
* @author Jean-Francois FABRE .
*/

#ifndef MYMACROS_H
#define MYMACROS_H

#include "MemoryEntryMap.hpp"

#define ARRAY_NB_ITEMS(a) (sizeof(a)/sizeof(a[0]))

/** deletes an object (if it its pointer is not 0, delete does
 * nothing, refer to C++ documentation)
 * and sets the pointer to 0 afterwards
 * @param obj pointer on the object to delete
 */

/*#define SAFE_DELETE(obj) \
    delete(obj);obj = NULL*/


/** deletes an object
 *  and sets the pointer to 0 afterwards
 * @param obj pointer on the array to delete
 */

/*#define SAFE_DELETE_ARRAY(obj) \
  delete [] obj;obj = NULL*/

/**
* useful macros to define copy constructor & affectation on the class
* or to prevent their usage when called in the private section of the class declaration
*/

#define DEF_CLASS_COPY(cname) \
  cname &operator=(const cname &); \
  cname(const cname &)


/** loops through a vector, list, etc...
 * @param it iterator, or const_iterator
 * @param list vector to loop on
 */

#define FOREACH(it, list) \
	for (it = (list).begin();it != (list).end();it++)


/** loops through a vector, with a stop condition
 * @param it iterator, or const_iterator
 * @param list vector to loop on
 * @param cond continue condition
 */

#define FOREACH_COND(it, list, cond) \
	for (it = (list).begin();(it != (list).end())&&(cond);it++)

/** outputs a variable name + value to the screen (for debug)
 */

#define TRACE_VAR(varexpr) \
cout << __FILE__ << ':' \
 << __LINE__ << ": "#varexpr"= [" << (varexpr) << "]" << endl

/**
 * swap 2 values
 * @param a value 1
 * @param b value 2
 * @param t type of @a a and @a b
 */

#define SWAP(a, b, t) { register t swp; swp = a; a = b; b = swp; }

/**
 * define a clone method for an object with copy constructor
 */

#define DEF_CLONE(typ,baseclass) \
baseclass *clone() const { baseclass *bc; LOGGED_NEW(bc,typ(*this)); return bc; }

#define DEF_EMPTY_CLONE(typ,baseclass) \
baseclass *clone() const { baseclass *bc; LOGGED_NEW(bc,typ()); return bc; }

#define DEF_ABSTRACT_CLONE(baseclass) \
virtual baseclass *clone() const = 0

#endif /* -- end of unit, add nothing after this #endif -- */
