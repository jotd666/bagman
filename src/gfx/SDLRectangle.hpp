#ifndef SDLRECTANGLE_H_INCLUDED
#define SDLRECTANGLE_H_INCLUDED

#include "SDL/SDL.h"

/**
* inherits SDL_Rect class only to add intersection methods
**/

class SDLRectangle : public SDL_Rect
{
public:
    SDLRectangle();
    SDLRectangle(int x,int y,int w,int h);
    bool contains(int x, int y) const;
    bool intersects(const SDLRectangle &other) const;
    bool contains(const SDLRectangle &other) const;

private:
    bool one_way_intersects(const SDLRectangle &other) const;
};

#endif
