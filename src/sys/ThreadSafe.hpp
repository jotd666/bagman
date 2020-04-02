/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef THREADSAFE_H
#define THREADSAFE_H

/*------------*
 * Used units *
 *------------*/

#include "SDL/SDL.h"
#include "MyAssert.hpp"

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
    typedef Uint32 ThreadId;

    /**
     * critical section start
     */

    void cs_start() const
    {
	SDL_LockMutex(m_creation_mutex);
    }

    /**
     * critical section end
     */

    void cs_end() const
    {
	SDL_UnlockMutex(m_creation_mutex);
    }

    /**
     * me
     */

    inline ThreadId me() const { return SDL_ThreadID(); }

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
	SDL_DestroyMutex(m_creation_mutex);
    }

 protected:
    ThreadSafe() : m_size(0)
    {
        m_creation_mutex = SDL_CreateMutex();
	bool mutex_init_failure = m_creation_mutex == 0;

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
    mutable SDL_mutex *m_creation_mutex;
};



#endif /* -- End of unit, add nothing after this #endif -- */
