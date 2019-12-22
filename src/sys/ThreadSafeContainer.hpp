/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef THREADSAFECONTAINER_H
#define THREADSAFECONTAINER_H

/*------------*
 * Used units *
 *------------*/


#include <map>
#include "ThreadSafe.hpp"

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 *
 * thread-safe object
 *
 * declare one static object ThreadSafeContainer<MyObject>, which is the
 * global, thread-protected container for the MyObject objects
 *
 * there is 1 and only 1 MyObject object per thread
 *
 * @author  Jean-Francois FABRE
 *
 */

template <class CNT>
class ThreadSafeContainer : public ThreadSafe
{
 public:
    typedef typename ThreadSafe::ThreadId ThreadId;
    typedef std::map<void *,CNT> ContainerType;
    typedef typename ContainerType::const_iterator const_iterator;

    /**
     * protected per-thread access method
     */

    CNT &get()
    {
	return find_or_create();
    }

    /**
     * protected per-thread access method (constant)
     */

    const CNT &get() const
    {
	ThreadSafeContainer *nonconst_hack = (ThreadSafeContainer*)this;

	return nonconst_hack->find_or_create();
    }

    /**
     * unprotected start iterator. use cs_start/cs_end
     * to protect the begin/end loop
     */

    const_iterator begin() const
    {
	return m_map.begin();
    }

    /**
     * unprotected end iterator. use cs_start/cs_end
     * to protect the begin/end loop
     */

    const_iterator end() const
    {
	return m_map.end();
    }


 private:


    CNT &find_or_create()
    {
	const ThreadId myid = me();

	cs_start();

	typename ContainerType::iterator rval = m_map.find((void*)myid);
	if (rval == m_map.end())
	{
	    // not found (first call to get() from this thread): create one
	    // in thread safe mode (list is shared by all threads)


	    std::pair<typename ContainerType::iterator, bool> success =
	    m_map.insert(std::make_pair((void*)myid,CNT()));

	    // update size while in thread protected context

	    m_size = m_map.size();

	    rval = success.first;

	}

	cs_end();

	return rval->second;
    }


    mutable ContainerType m_map;
};



#endif /* -- End of unit, add nothing after this #endif -- */
