/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef THREADPOSITIVECOUNTER_H
#define THREADPOSITIVECOUNTER_H

/*------------*
 * Used units *
 *------------*/

#include "ThreadCondition.hpp"

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 *
 * thread-protected positive counter
 *
 * cannot go below 0 (condition wait until > 0)
 *
 * limitation: if counter goes above INT_MAX, behaviour is not
 * guaranteed (guaranteed that it will fail, actually)
 *
 * @author  Jean-Francois FABRE
 *
 */

class ThreadPositiveCounter : protected ThreadCondition
{
 public:
    ThreadPositiveCounter(int initial_value = 0) :
    m_counter(initial_value)
    {}
    
    operator int() const { return m_counter; }

    ThreadPositiveCounter &operator++(int)
    {
	lock();
	// no restrictions for incrementing the value
	m_counter++;
	broadcast(); // tell the other(s) that counter has changed
	unlock();

	return *this;
    }
    ThreadPositiveCounter &operator--()
    {
	lock();
	if (m_counter <= 0) // could be == 0
	{
	    wait();
	}
	m_counter--;
	unlock();

	return *this;
    }
 private:	
    int m_counter;
};



#endif /* -- End of unit, add nothing after this #endif -- */
