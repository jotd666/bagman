#include "FadeEvent.hpp"
#include "SDL/SDL.h"

#include "MyAssert.hpp"

FadeEvent::FadeEvent()
{
    init(0,0);
}

void FadeEvent::init(int start_time, int duration)
{
    TimerEvent::init(start_time,duration);
    m_alpha = 0;
    m_second_chance_timeout = false;
    m_timeout_reached = false;
}

int FadeEvent::get_final_value() const
{
    return 255;
}

void FadeEvent::on_timeout()
{
    m_alpha = get_final_value();
    if (!m_second_chance_timeout)
    {
        // we want to force the last update with full value specially in paletted mode
        // (or else colors are not 100% the targeted ones!!)
        //
        // so when the timeout is reached, reset the timeout flag once to be sure that the
        // last call to get_alpha() will return max value (because is_running() will be true once more
        // with max value in alpha)
        //
        // if we don't do that, on fadein timers we would have to check for is_timeout_reached()
        // and set full value to palette at this moment but this is not optimal
        // unless we define another flag to do it only once... this is much better with this little
        // local "hack"

        m_timeout_reached = false;
        m_second_chance_timeout = true;
    }
}

