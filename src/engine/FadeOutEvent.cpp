#include "FadeOutEvent.hpp"
#include "SDL/SDL.h"



FadeOutEvent::FadeOutEvent() // make it not running if not initialized
{
    FadeEvent::init(0, 0);
}

void FadeOutEvent::on_update(int )
{
    m_alpha = 255 - (255 * (m_elapsed - m_start_time)) / m_duration;
    if (m_alpha < 0)
    {
        m_alpha = 0;
    }
}

int FadeOutEvent::get_final_value() const
{
    return 0;
}


