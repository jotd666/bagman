/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef FUNCTIONTIMER_H
#define FUNCTIONTIMER_H

/*------------*
 * Used units *
 *------------*/

#include "Long64.hpp"


/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 * profiling/timing utility class
 *
 * @author  Jean-Francois FABRE
 *
 */

class FunctionTimer
{
 public:
    /**
     * default constructor
     */
    FunctionTimer();

    /**
     * declare function start, measures CPU & elapsed start times
     */
    
    void in();
    
    /**
     * declare function stop, measures CPU & elapsed end times
     */
    
    
    void out();

    /**
     * @return number of times the function has been called
     */
    
    ulong64_t get_call_count() const { return m_call_count; }

    /**
     * @return elapsed microseconds
     */
    
    ulong64_t get_elapsed_microsecs() const { return m_elapsed_microsecs; }

    /**
     * @return microseconds granted by the system to perform the computation
     */
    
    ulong64_t get_computed_microsecs() const { return m_computed_microsecs; }

    /**
     * add contents of another timer to the current one
     */
    
    FunctionTimer &operator+=(const FunctionTimer &other);

    /**
     * compare elapsed times between timers (for a sorted display)
     */
    
    bool operator<(const FunctionTimer &other) const;


 protected:

 private:
    ulong64_t m_elapsed_microsecs; ///< elapsed time (including other processes)
    ulong64_t m_computed_microsecs; ///< actual computation time
    ulong64_t m_call_count; ///< number of times that the function is called
};



#endif /* -- End of unit, add nothing after this #endif -- */
