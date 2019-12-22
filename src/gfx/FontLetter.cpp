#include "FontLetter.hpp"
#include "Fonts.hpp"

FontLetter::FontLetter(char c,const Fonts *fonts, const Locatable &start,
                               const Locatable &aim) : m_c(c), m_fonts(fonts), m_start(start), m_aim(aim),
        m_elapsed(0)
{
    set_location(m_start);
}

void FontLetter::render(Drawable &d) const
{
    if (m_c[0] != ' ')
    {
        m_fonts->write(d, get_x(), get_y(), m_c);
    }
}

