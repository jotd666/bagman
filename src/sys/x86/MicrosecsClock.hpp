/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef MICROSECSCLOCK_H
#define MICROSECSCLOCK_H

/*------------*
 * Used units *
 *------------*/

#include "Long64.hpp"

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 * microseconds real time clock interface
 *
 * @author  Jean-Francois FABRE
 *
 */

class MicrosecsClock
{
 public:
    typedef ulong64_t Tick;
    /**
     * returns time in microseconds since 1970 in a 64-bit number
     */
    
    static Tick get_time();

    /**
     * waits until a given date
     */
    
    static void wait_until(Tick date);
    
    static const Tick one_million;
};



#endif /* -- End of unit, add nothing after this #endif -- */
