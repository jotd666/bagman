#include "SDLRectangle.hpp"


SDLRectangle::SDLRectangle()
{
    x = y = w = h = 0;
}

SDLRectangle::SDLRectangle(int x,int y,int w,int h)
{
    this->x = x;
    this->y = y;
    this->w = w;
    this->h = h;
}

#define CONTAINS(o,px,py) (((px) >= o.x) && ((py) >= o.y) && ((px) <= o.x+o.w) && ((py) <= o.y+o.h))

bool SDLRectangle::contains(int px, int py) const
{
    return CONTAINS((*this),px,py);
}
bool SDLRectangle::contains(const SDLRectangle &other) const
{
    return CONTAINS((*this),other.x,other.y) && CONTAINS((*this),other.x+other.w,other.y) &&
    CONTAINS((*this),other.x+other.w,other.y+other.h) && CONTAINS((*this),other.x,other.y+other.h);
}

bool SDLRectangle::intersects(const SDLRectangle &other) const
{
  return other.one_way_intersects(*this) || one_way_intersects(other);
}
inline bool SDLRectangle::one_way_intersects(const SDLRectangle &other) const
{
  return CONTAINS(other,x+1,y+1) || CONTAINS(other,x+w-1,y+1) ||
  CONTAINS(other,x+1,y+h-1) || CONTAINS(other,x+w-1,y+h-1);
}
