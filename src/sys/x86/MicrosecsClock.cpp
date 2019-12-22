/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   MicrosecsClock.C
 *
 * @brief  .
 *
 * @author  Jean-Francois FABRE
 *
 */

/*------------*
 * Used units *
 *------------*/

#include "MicrosecsClock.hpp"

const MicrosecsClock::Tick MicrosecsClock::one_million = 1000000UL;

#define ONE_THOUSAND 1000
#define RESOLUTION_IN_USECS 40000

#ifndef _WIN32
#include <sys/time.h> // gettimeofday()
#include <unistd.h>
#include <ctime>


static const timespec ts = { 0, RESOLUTION_IN_USECS*ONE_THOUSAND };


MicrosecsClock::Tick MicrosecsClock::get_time()
{
    timeval tv;    
    gettimeofday(&tv, 0);

    return tv.tv_sec * one_million + tv.tv_usec;
}

void MicrosecsClock::wait_until(Tick date)
{
    Tick current;
    bool out = false;
    
    do
    {
	current = get_time();

	// don't get the time twice if we are sure that waiting once
	// will be enough
	out = (current < date-(RESOLUTION_IN_USECS/2));

	if (current < date)
	{
	    nanosleep(&ts,NULL);
	}
    }
    while (out || current <= date);
    
}

#else

// Windows implementation

#include "MyAssert.hpp"
#include <sys/types.h>
#include <sys/timeb.h>
#include <windows.h>

MicrosecsClock::Tick MicrosecsClock::get_time()
{
    struct _timeb tstruct;
	_ftime(&tstruct);
	Tick rval = tstruct.millitm * ONE_THOUSAND + tstruct.time;
	return rval;
}
void MicrosecsClock::wait_until(Tick date)
{
    static const Tick resolution = RESOLUTION_IN_USECS/ONE_THOUSAND; // 40 milliseconds
    
    Tick current;

    do
    {
	current = get_time();
	
	if (current < date-(resolution*500))
	{
	    Sleep(resolution);
	}
    }
    while(current <= date);
    
}

#endif

