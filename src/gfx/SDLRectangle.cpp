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


#define CONTAINS_POINT(o,px,py) (((px) >= o.x) && ((py) >= o.y) && ((px) <= o.x+o.w) && ((py) <= o.y+o.h))

/*
   bool SDLRectangle::contains(int px, int py) const
   {
   return CONTAINS_POINT((*this),px,py);
   }
   bool SDLRectangle::contains(const SDLRectangle &other) const
   {
   auto xplusw = other.x+other.w+WOFFSET;

   return CONTAINS_POINT((*this),other.x,other.y) && CONTAINS_POINT((*this),xplusw,other.y) &&
   CONTAINS_POINT((*this),xplusw,other.y+other.h) && CONTAINS_POINT((*this),other.x,other.y+other.h);
   }*/

bool SDLRectangle::intersects(const SDLRectangle &other) const
{
  return other.one_way_intersects(*this) or one_way_intersects(other);
}
inline bool SDLRectangle::one_way_intersects(const SDLRectangle &other) const
{
  auto xplusw_minus1 = x+w-1;
  auto yplush_minus1 = y+h-1;
  return CONTAINS_POINT(other,x+1,y+1) || CONTAINS_POINT(other,xplusw_minus1,y+1) ||
  CONTAINS_POINT(other,x+1,yplush_minus1) || CONTAINS_POINT(other,xplusw_minus1,yplush_minus1);
}
