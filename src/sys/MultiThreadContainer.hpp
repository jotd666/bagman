/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef MULTITHREADCONTAINER_H
#define MULTITHREADCONTAINER_H

/*------------*
 * Used units *
 *------------*/

#include "ThreadSafe.hpp"


/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 *
 * global list, protected access with mutexes methods
 *
 * methods with p_ prefixes are mutex protected
 * methods without prefixes are NOT mutex protected,
 *
 * cs_start() & cs_end() MUST be called to ensure protection
 *
 * @param T base item
 * @param CNT standard library alike container type
 * (must contain T-type items, and basic C++ lib methods such as insert...
 * ex: set<T>, list<T> ...)
 *
 * @author  Jean-Francois FABRE
 *
 */

template <class T, class CNT >
class MultiThreadContainer : public ThreadSafe
{
 public:
    typedef CNT ContainerType;
    typedef typename CNT::const_iterator const_iterator;
    typedef typename CNT::iterator iterator;
    
    /**
     * protected list insert method
     */

    template <class T2>
    void p_insert(const T2 &item)
    {
	cs_start();
	m_list.insert(item);
	m_size++;
	cs_end();
    }

    /**
     * protected list remove method
     */
    
    bool p_remove(const T &item)
    {
	cs_start();
	bool rval = m_list.remove(item);
	m_size = m_list.size();
	cs_end();

	return rval;
    }
    
    /**
     * unprotected list clear
     */
    
    void clear()
    {
	m_list.clear();
	m_size = 0;
    }

    

    /**
     * unprotected start iterator. use cs_start/cs_end
     * to protect the begin/end loop
     */

    const_iterator begin() const
    {
	return m_list.begin();
    }
    
    /**
     * unprotected end iterator. use cs_start/cs_end
     * to protect the begin/end loop
     */

    const_iterator end() const
    {
	return m_list.end();
    }
    /**
     * unprotected start iterator. use cs_start/cs_end
     * to protect the begin/end loop
     */

    iterator begin()
    {
	return m_list.begin();
    }
    
    /**
     * unprotected end iterator. use cs_start/cs_end
     * to protect the begin/end loop
     */

    iterator end()
    {
	return m_list.end();
    }
    
 protected:
    ContainerType m_list;
};



#endif /* -- End of unit, add nothing after this #endif -- */
