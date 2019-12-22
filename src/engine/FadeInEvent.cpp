#include "FadeInEvent.hpp"


FadeInEvent::FadeInEvent(int duration)
{
    FadeEvent::init(0,duration);
}


void FadeInEvent::on_update(int )
{
    m_alpha = ((255 * m_elapsed) / m_duration);
    if (m_alpha > 255)
    {
        m_alpha = 255;
    }

}


