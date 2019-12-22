/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef THREADSAFECOUNTER_H
#define THREADSAFECOUNTER_H

/*------------*
 * Used units *
 *------------*/

#include "ThreadSafe.hpp"

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 *
 * thread-protected counter
 *
 * @author  Jean-Francois FABRE
 *
 */

class ThreadSafeCounter : protected ThreadSafe
{
 public:
    ThreadSafeCounter(int initial_value = 0) : ThreadSafe(), m_counter(initial_value)
    {}
    
    operator int() const { return m_counter; }

    ThreadSafeCounter &operator++()
    {
	cs_start();
	m_counter++;
	cs_end();

	return *this;
    }
    ThreadSafeCounter &operator--()
    {
	cs_start();
	m_counter--;
	cs_end();

	return *this;
    }
 private:	
    int m_counter;
};



#endif /* -- End of unit, add nothing after this #endif -- */
