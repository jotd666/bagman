#pragma once
#include "SDL/SDL.h"

extern void SDL_SetPixel( SDL_Surface* pSurface , int x , int y , Uint32 fake_rgb);
extern Uint32 SDL_GetPixel( const SDL_Surface* pSurface , int x , int y );

#define NB_PLANES 4

class SDL_Amiga_Surface : public SDL_Surface
{
public:
  virtual ~SDL_Amiga_Surface() {}
  int nb_planes = 0;
  enum ImageType {
    // blittable at any x. contains 16 extra pixels at each row end
    SHIFTABLE_BOB = 0,
    // same as shiftable bob, but contains an extra bitplane which is the mask for cookie cut blit
    SHIFTABLE_TRANSPARENT_BOB = 1,
    // simple bob, only blittable at positions multiple of 16 in x
    // ideal for full screen backgrounds
    BOB = 2};

  ImageType image_type = SHIFTABLE_BOB;
  ULONG plane_size = 0;
  ULONG buffer_size = 0;
  UBYTE *mask = nullptr;
  //UWORD actual_width = 0; // ==w unless image type is SHIFTABLE_BOB
};
