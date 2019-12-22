/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef THREADSAFE_H
#define THREADSAFE_H

/*------------*
 * Used units *
 *------------*/

#include "MyAssert.hpp"

#include <pthread.h>
#include <strings.h>

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 *
 * frame object for mutex support
 *
 * @author  Jean-Francois FABRE
 *
 */

class ThreadSafe
{
 public:
    typedef pthread_t ThreadId;

    /**
     * critical section start
     */

    void cs_start() const
    {
	pthread_mutex_lock(&m_creation_mutex);
    }

    /**
     * critical section end
     */

    void cs_end() const
    {
	pthread_mutex_unlock(&m_creation_mutex);
    }

    /**
     * me
     */

    inline ThreadId me() const { return pthread_self(); }

    /**
     * check if my id
     */

    bool is_me(const ThreadId id) const { return me() == id; }

    /**
     * @return number of items
     */

    int size() const
    {
	return m_size;
    }

    ~ThreadSafe()
    {
	pthread_mutex_destroy(&m_creation_mutex);
    }

 protected:
    ThreadSafe() : m_size(0)
    {
	bool mutex_init_failure = pthread_mutex_init(&m_creation_mutex,NULL) != 0;

	if (mutex_init_failure)
	{
	    // force assertion failure with an intelligible message
	    //
	    // note: if (x) { my_assert(!x); } construction needed
	    // instead of direct my_assert(!x); because of NDEBUG mode
	    // (my_assert = empty macro and thus x would be unused)

	    mutex_init_failure = false;
	    my_assert(mutex_init_failure);
	}
    }


    int m_size;

 private:
    mutable pthread_mutex_t m_creation_mutex;
};



#endif /* -- End of unit, add nothing after this #endif -- */
