/********************************************************
 *
 *  SDL image manipulation utilities
 *
 *  Written by JOTD 2008-2010
 *
 * The point of this file is to provide routines as compatible as
 * possible with various screenmodes (not only 24 bits, which is easy)
 *
 * 8 bits screenmodes are supported and it works. Most of hacks found on
 * the internet don't :)
 *
 **************************************************************/

#include "ImageUtil.hpp"
#include <SDL/SDL.h>
#include "MyAssert.hpp"
#include "DisplayDepth.hpp"   // sets required display mode
#include "ScaleSize.hpp"
#include "MemoryEntryMap.hpp"

#ifdef __amigaos
#include "sdl_emu.hpp"
#endif

/*#if SCALE_SIZE != 1
  #include <SDL_Image.h>
  #endif*/

#include <string.h>

SDL_Surface *ImageUtil::load_image(const MyString &image_file)
{

  printf("load image %s\n",image_file.c_str());

  SDL_Surface *temp_image = SDL_LoadBMP(image_file.c_str());


  // SDL image version: can handle PNG files, and more: here disabled
  //SDL_Surface *temp_image = IMG_Load(image_file.c_str());
#ifndef __amigaos__
  if (temp_image != 0)
    {
      LOGGED_MANUAL_ALLOC(temp_image);

      // get rid of any exotic format from the loaded file: convert to the same format

      SDL_Surface *temp_image_2 = SDL_DisplayFormat(temp_image);
      LOGGED_MANUAL_ALLOC(temp_image_2);

      LOGGED_MANUAL_DELETE(temp_image);
      SDL_FreeSurface(temp_image);
      temp_image = temp_image_2;
    }
  #endif

  return temp_image;
}

SDL_Surface *ImageUtil::replace_color(const SDL_Surface *src, int old_color, int new_color, bool )
{
  SDL_Surface *rval = create_image_like(src);
  SDL_BlitSurface((SDL_Surface *)src,0,rval,0);


  replace_color_in_place(rval,old_color,new_color);



  return rval;
}


void ImageUtil::rotate_90(const SDL_Surface *input, SDL_Surface *output, bool positive)
{
  // sanity checks
  int iw = input->w;
  int ih = input->h;
  my_assert(iw == output->h);
  my_assert(ih == output->w);

  int rgb;

  for ( int y=0 ; y < ih ; y++ )
    {
      for ( int x=0 ; x < iw ; x++ )
	{
	  rgb = get_pixel(input,x,y);
	  if (positive)
	    {
	      set_pixel(output,y,iw-x-1,rgb);
	    }
	  else
	    {
	      set_pixel(output,ih-y-1,x,rgb);
	    }
	}
    }
}


SDL_Color ImageUtil::rgb2color(Uint32 rgb)
{
  SDL_Color rval;
  rval.r = (rgb & 0xFF0000) >> 16;
  rval.g = (rgb & 0xFF00) >> 8;
  rval.b = (rgb & 0xFF);
  return rval;
}

Uint32 ImageUtil::color2rgb(const SDL_Color &c)
{
  return ((int)c.r << 16) + ((int)c.g << 8) + c.b;
}

void ImageUtil::replace_color_in_place(SDL_Surface *rval, int old_color, int new_color)
{

  // caution: alpha channel is not masked


  for ( int y=0 ; y<rval->h ; y++ )
    {

      for ( int x=0 ; x<rval->w ; x++ )
	{
	  int rgb_img = (int)get_pixel(rval,x,y);

	  if (rgb_img == old_color)
	    {
	      set_pixel(rval,x,y,new_color);
	    }

	}
    }
}

SDL_Surface *ImageUtil::mirror(const SDL_Surface *source)
{

  // create image with same dimensions
  SDL_Surface *dest = create_image_like(source);
  // copy transparency from original image
  SDL_SetColorKey( dest, SDL_RLEACCEL | SDL_SRCCOLORKEY, source->format->colorkey );
  // render it backwards

  mirror(source,dest);

  return dest;

}

SDL_Surface *ImageUtil::flip(const SDL_Surface *source)
{
  // create image with same dimensions
  SDL_Surface *dest = create_image_like(source);
  // copy transparency from original image
  SDL_SetColorKey( dest, SDL_RLEACCEL | SDL_SRCCOLORKEY, source->format->colorkey );
  // render it backwards
  flip(source,dest);
  return dest;

}


void ImageUtil::flip(const SDL_Surface *source, SDL_Surface *dest)
{
  // this routine works whatever plane depth (24, 16, 8)

  const int sh = source->h;
  for ( int y=0 ; y< sh ; y++ )
    {

      for ( int x=0 ; x<source->w ; x++ )
	{
	  Uint32 c = get_pixel(source,x,y);
	  set_pixel ( dest , x , sh-1-y , c );
	}
    }

}



SDL_Palette *ImageUtil::get_palette(SDL_Surface *source)
{
  return source->format->palette;
}

void ImageUtil::set_palette(const SDL_Surface *source, SDL_Surface *dest)
{
  SDL_Palette *p = source->format->palette;

  SDL_SetColors(dest, p->colors, 0, p->ncolors);
}


void ImageUtil::set_transparency(SDL_Surface *image,int rgb)
{
  Uint32 colorkey = SDL_MapRGB( image->format,
			       (rgb & 0xFF0000) >> 16,
			       (rgb & 0xFF00) >> 8 , rgb & 0xFF );

  SDL_SetColorKey( image, SDL_RLEACCEL | SDL_SRCCOLORKEY, colorkey );
}

void ImageUtil::render_half_size(const SDL_Surface *source, SDL_Surface *dest,
				 int src_x_offset, int src_y_offset,
				 int dest_x_offset, int dest_y_offset)
{
  for ( int y=0 ; y<source->h ; y += 2 )
    {
      for ( int x=0 ; x<source->w ; x += 2 )
	{
	  Uint32 c = get_pixel(source,x+src_x_offset,y+src_y_offset);
	  set_pixel ( dest , x/2 + dest_x_offset , y/2 + dest_y_offset , c );
	}

    }
}


SDL_Surface *ImageUtil::resize(SDL_Surface *source, int ratio)
{
  my_assert(ratio > 0);
  SDL_Surface *dest = source;
  if (ratio != 100)
    {
      int dest_w = (source->w * ratio)/100;
      int dest_h = (source->h * ratio)/100;

      dest = create_image(dest_w, dest_h);
      SDL_SetColorKey( dest, SDL_RLEACCEL | SDL_SRCCOLORKEY, source->format->colorkey );


      for ( int y=0 ; y<dest->h ; y++ )
	{
	  int src_y = (y * 100)/ratio;
	  int dst_y = y;



	  for ( int x=0 ; x<dest->w; x++ )
	    {
	      int src_x = (x * 100)/ ratio;
	      int dst_x = x;
	      Uint32 rgb = get_pixel(source,src_x,src_y);
	      set_pixel(dest,dst_x,dst_y,rgb);
	    }
	}

      LOGGED_MANUAL_DELETE(source);
      SDL_FreeSurface(source);

    }
  return dest;
}


/*
   void ImageUtil::render_half_size(const SDL_Surface *source, SDL_Surface *dest)
   {

    my_assert(source->format->BytesPerPixel == DISPLAY_DEPTH/8);
    my_assert(dest->format->BytesPerPixel == DISPLAY_DEPTH/8);

    my_assert(dest->w * 2 >= source->w);
    my_assert(dest->h * 2 >= source->h);

    const Uint8 *imp = 0;
    Uint8 *imp_dest = 0;


    for ( int y=0 ; y<source->h ; y+=2 )
    {
	imp = (const Uint8 *)source->pixels + y * source->pitch;
	imp_dest = (Uint8 *)dest->pixels + y/2 * dest->pitch;

	for ( int x=0 ; x<source->w ; x+= 2 )
	{
	    memcpy(imp_dest,imp, DISPLAY_DEPTH/8);

	    imp += DISPLAY_DEPTH/16;  // 2
	    imp_dest += DISPLAY_DEPTH/8; // 4
	}
    }

   }*/

SDL_Surface *ImageUtil::clone_image(const SDL_Surface* image)
{
  // clone image using the format used for display
  SDL_Surface *rval = SDL_DisplayFormat((SDL_Surface*)image);
  LOGGED_MANUAL_ALLOC(rval);

  // copy transparency (don't use set_transparency() as colorkey is NOT rgb)
  SDL_SetColorKey( (SDL_Surface*)image, SDL_RLEACCEL | SDL_SRCCOLORKEY, image->format->colorkey );

  return rval;
}


// amiga versions are defined in sdl_emu.cpp
#ifdef __amigaos__
bool ImageUtil::is_transparent(const SDL_Surface *source)
{
  auto *src =(const SDL_Amiga_Surface *)(source);
  return src->mask != nullptr;

}



void ImageUtil::mirror(const SDL_Surface *source, SDL_Surface *dest)
{
  // SDL_UpperBlit((SDL_Surface *)source,0,dest,0);
  //  return;

  auto *amiga_source =(const SDL_Amiga_Surface *)(source);

  // ignore last 16 pixels. Blitter needs a blank area for shifting

  for ( int y=0 ; y<source->h ; y++ )
    {
      for ( int x=amiga_source->w ; x<amiga_source->iw ; x++ )
	{

	  set_pixel ( dest , x , y , 0 );
	}
    }

  int sw = source->w;
  for ( int y=0 ; y<source->h ; y++ )
    {
      for ( int x=0 ; x<sw ; x++ )
	{
	  Uint32 c = get_pixel(source,x,y);
	  set_pixel ( dest , sw-1-x , y , c );
	}
    }


}



SDL_Surface *ImageUtil::create_image_like(const SDL_Surface *source)
{
  auto *src = (const SDL_Amiga_Surface *)(source);


  SDL_Surface *rval = (src->mask != nullptr) ? create_alpha_image(src->iw, src->h) : create_image(src->iw, src->h);
  // adjust logical width
  auto *rvala = (SDL_Amiga_Surface *)(rval);
  rvala->w -= src->dw;
  rvala->dw = src->dw;

  return rval;
}

SDL_Surface *ImageUtil::create_image(int w, int h)
{

  SDL_Surface *rval = SDL_CreateRGBSurface
    (SDL_HWSURFACE, w, h, 0, /* depth is hardcoded by raw image format / screen */
    0,0,0,0);
  LOGGED_MANUAL_ALLOC(rval);

  return rval;
}

SDL_Surface *ImageUtil::create_alpha_image(int w, int h)
{
  SDL_Surface *rval = SDL_CreateRGBSurface
    (SDL_HWSURFACE|SDL_SRCALPHA, w, h, 0, /* depth is hardcoded by raw image format / screen */
    0,0,0,0);
  LOGGED_MANUAL_ALLOC(rval);

  return rval;
}

/*SDL_Surface *ImageUtil::make_bicolor(const SDL_Surface *image, int background, int new_foreground, bool alpha)
  {
  // NOT DONE!!
  SDL_Surface *rval = clone_image(image);
  return rval;
  }*/



void ImageUtil::set_pixel( SDL_Surface* pSurface , int x , int y , Uint32 rgb)
{
  SDL_SetPixel(pSurface,x,y,rgb);
}
Uint32 ImageUtil::get_pixel( const SDL_Surface* pSurface , int x , int y )
{
  return SDL_GetPixel( pSurface ,  x ,  y );
}

#else

bool ImageUtil::is_transparent(const SDL_Surface *)
{
  return false; // doesn't matter here
}

SDL_Surface *ImageUtil::create_alpha_image(int w, int h)
{
  SDL_Surface *rval = 0;
  int rmask,gmask,bmask,amask;
  /* SDL interprets each pixel as a 32-bit number, so our masks must depend
     on the endianness (byte order) of the machine */
#if DISPLAY_DEPTH == 32
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  rmask = 0xff000000;
  gmask = 0x00ff0000;
  bmask = 0x0000ff00;
  amask = 0x000000ff;
#else
  rmask = 0x000000ff;
  gmask = 0x0000ff00;
  bmask = 0x00ff0000;
  amask = 0xff000000;
#endif
#else
  rmask = 0x000000;
  gmask = 0x000000;
  bmask = 0x000000;
  amask = 0x000000;
#endif



  rval = SDL_CreateRGBSurface
    (SDL_HWSURFACE|SDL_SRCALPHA, w, h, DISPLAY_DEPTH,
    rmask,gmask,bmask,amask);
  LOGGED_MANUAL_ALLOC(rval);

  return rval;
}

SDL_Surface *ImageUtil::create_image(int w, int h)
{

  int rmask,gmask,bmask;
  /* SDL interprets each pixel as a 32-bit number, so our masks must depend
     on the endianness (byte order) of the machine */

#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  rmask = 0xff000000;
  gmask = 0x00ff0000;
  bmask = 0x0000ff00;
#else
  rmask = 0x000000ff;
  gmask = 0x0000ff00;
  bmask = 0x00ff0000;
#endif

  // always create a temporary surface of 8 bits, and convert it with DisplayFormat
  // to avoid all sort of color problems

  SDL_Surface *rval_temp = SDL_CreateRGBSurface
    (SDL_HWSURFACE, w, h, 8,
    rmask,gmask,bmask,0);
  LOGGED_MANUAL_ALLOC(rval_temp);

  SDL_Surface *rval = SDL_DisplayFormat(rval_temp);
  LOGGED_MANUAL_ALLOC(rval);
  LOGGED_MANUAL_DELETE(rval_temp);
  SDL_FreeSurface(rval_temp);

  return rval;
}
// chunky real SDL routine
void ImageUtil::set_pixel( SDL_Surface* pSurface , int x , int y , Uint32 rgb)
{
  my_assert(x < pSurface->w);
  my_assert(y < pSurface->h);
  my_assert(x >= 0);
  my_assert(y >= 0);
  //convert color
  //Uint32 rgb = SDL_MapRGB ( pSurface->format , color.r , color.g , color.b ) ;

  //determine position
  char* pPosition = ( char* ) pSurface->pixels ;

  //offset by y
  pPosition += ( pSurface->pitch * y ) ;

  //offset by x
  pPosition += ( pSurface->format->BytesPerPixel * x ) ;

  // copy pixel data: the only memcpy function here: not clean, but the only way to do it quickly
  // I think this works only in little endian architecture
  memcpy ( pPosition , &rgb ,pSurface->format->BytesPerPixel ) ;

}

SDL_Surface *ImageUtil::create_image_like(const SDL_Surface *src)
{
  return create_image(src->w, src->h);
}


Uint32 ImageUtil::get_pixel( const SDL_Surface* pSurface , int x , int y )
{
  Uint32 col = 0 ;

  //determine position
  const char* pPosition = ( const char* ) pSurface->pixels ;

  //offset by y
  pPosition += ( pSurface->pitch * y ) ;

  //offset by x
  pPosition += ( pSurface->format->BytesPerPixel * x ) ;

  //copy pixel data: the only memcpy function here: not clean, but the only way to do it
  memcpy ( &col , pPosition , pSurface->format->BytesPerPixel ) ;

  //convert color
  //SDL_GetRGB ( col , pSurface->format , &color.r , &color.g , &color.b ) ;
  return col;
}

void ImageUtil::mirror(const SDL_Surface *source, SDL_Surface *dest)
{
  // this routine works whatever plane depth (24, 16, 8)

  for ( int y=0 ; y<source->h ; y++ )
    {

      for ( int x=0 ; x<source->w ; x++ )
	{
	  Uint32 c = get_pixel(source,x,y);
	  set_pixel ( dest , source->w-1-x , y , c );
	}
    }


}


#endif
