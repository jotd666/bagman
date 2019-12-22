#ifndef FONTLETTER_H_INCLUDED
#define FONTLETTER_H_INCLUDED

#include "Renderable.hpp"

class Fonts;

class FontLetter : public Renderable
{
public:
    FontLetter(char c,const Fonts *fonts, const Locatable &start,
           const Locatable & aim);

    virtual bool is_done() const = 0;
    void render(Drawable &d) const;
    virtual bool update(int elapsed_time) = 0;
    const MyString &get_value() const
    {
        return m_c;
    }
protected:
    MyString m_c;
    const Fonts *m_fonts;
    Locatable m_start;
    Locatable m_aim;
    int m_elapsed;

};

#endif
