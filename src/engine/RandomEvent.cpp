#include "RandomEvent.hpp"
#include <stdlib.h>

void RandomEvent::on_timeout()
{
    // perform random generation

    int v = rand();
    m_has_event = v < m_probability;
    // reload
    init(0,m_period);
}

bool RandomEvent::has_event()
{
    bool rval = m_has_event;
    m_has_event = false;
    return rval;
}

RandomEvent::RandomEvent(int period, double probability)
{
   m_probability = (int)(probability * RAND_MAX);
   m_period = period;
   m_has_event = false;
}

