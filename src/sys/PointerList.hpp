/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef POINTERLIST_H
#define POINTERLIST_H

/*------------*
 * Used units *
 *------------*/

#include "PointerContainer.hpp"
#include <list>

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 * container used to contain derived classes of an abstract class
 *
 * insert items using insert() or push_back() calling new T(...)
 * list is protected against copy/affectation
 * list contents are deleted on destructor call
 *
 * @author  Jean-Francois FABRE
 *
 */

#include "PointerContainer.hpp"
#include <list>

template <class T, bool delete_memory=true>
class PointerList : public PointerContainer<T, std::list<T *>, delete_memory >
{
 public:
    typedef PointerContainer<T,std::list<T *>,delete_memory > Parent;

    typedef typename Parent::ListType ListType;
    typedef typename ListType::const_iterator const_iterator;
    typedef typename ListType::iterator iterator;
    typedef typename ListType::reverse_iterator reverse_iterator;
    typedef typename ListType::const_reverse_iterator const_reverse_iterator;

    void push_back(T * item)
    {
        Parent::m_items.push_back(item);
    }

    void insert(const_iterator it,T *item)
    {
	Parent::m_items.insert(it,item);
    }

 protected:


};



#endif /* -- End of unit, add nothing after this #endif -- */
