/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   function_timer.cc
 *
 * @brief  .
 *
 * @author  Jean-Francois FABRE
 *
 */

/*------------*
 * Used units *
 *------------*/

#include "FunctionTimer.hpp"
#include "MicrosecsClock.hpp"

#include <time.h>     // clock()

FunctionTimer::FunctionTimer() : m_elapsed_microsecs(0UL),m_computed_microsecs(0UL),m_call_count(0UL)
{

}
void FunctionTimer::in()
{
    m_call_count++;

    // get used CPU time
    
    m_computed_microsecs = clock();
    
    // get absolute start time
    m_elapsed_microsecs = MicrosecsClock::get_time();
}

void FunctionTimer::out()
{
    // compute end time only if in() was called (or else times are
    // irrelevant since previous value is 0 and means the epoch)

    if (m_elapsed_microsecs != 0)
    {
	m_elapsed_microsecs = MicrosecsClock::get_time() - m_elapsed_microsecs;
	m_computed_microsecs = clock() - m_computed_microsecs;
    }

}


FunctionTimer &FunctionTimer::operator+=(const FunctionTimer &other)
{
    m_call_count += other.get_call_count();
    m_elapsed_microsecs += other.get_elapsed_microsecs();
    m_computed_microsecs += other.get_computed_microsecs();

    return *this;
   
}


bool FunctionTimer::operator<(const FunctionTimer &other) const
{
    return m_elapsed_microsecs < other.get_elapsed_microsecs();
}
