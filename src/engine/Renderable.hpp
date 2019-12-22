#ifndef RENDERABLE_H_INCLUDED
#define RENDERABLE_H_INCLUDED

class Drawable;

#include "Locatable.hpp"

class Renderable : public Locatable
{
    public:
     virtual void render(Drawable &screen) const = 0;

};

#endif
