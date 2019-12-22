#ifndef IMAGEUTIL_H_INCLUDED
#define IMAGEUTIL_H_INCLUDED

#include "MyString.hpp"
#include "string.h"
#include "SDL/SDL.h"

class ImageUtil
{
public:
  static SDL_Surface *load_image(const MyString &image_file);
  static void set_transparency(SDL_Surface *image, int rgb);

  //static SDL_Surface *make_bicolor(const SDL_Surface *image, int background, int new_foreground, bool alpha);
  static void replace_color_in_place(SDL_Surface *image, int old_color, int new_color);
  static SDL_Surface *replace_color(const SDL_Surface *src, int old_color, int new_color, bool alpha);
  static SDL_Surface *create_image_like(const SDL_Surface *src);
  static SDL_Surface *create_image(int w, int h);
  static SDL_Surface *create_alpha_image(int w, int h);
  static SDL_Surface *mirror(const SDL_Surface *source);
  static void mirror(const SDL_Surface *source, SDL_Surface *dest);
  static SDL_Surface *flip(const SDL_Surface *source);
  static void flip(const SDL_Surface *source, SDL_Surface *dest);
  static SDL_Surface *clone_image(const SDL_Surface* image);
  static void render_half_size(const SDL_Surface *source, SDL_Surface *dest,int src_x_offset, int src_y_offset,
			       int dest_x_offset, int dest_y_offset);
  static void rotate_90(const SDL_Surface *input, SDL_Surface *output, bool positive);
  static SDL_Color rgb2color(Uint32 rgb);
  static Uint32 color2rgb(const SDL_Color &c);
  static void set_palette(const SDL_Surface *source, SDL_Surface *dest);
  static SDL_Palette *get_palette(SDL_Surface *source);
  static SDL_Surface *resize(SDL_Surface *source, int ratio);

  static bool is_transparent(const SDL_Surface *source);

  /*
      static inline void set_pixel_slow( SDL_Surface* pSurface , int x , int y , SDL_Color color )
      {
	  //convert color
	  Uint32 col = SDL_MapRGB ( pSurface->format , color.r , color.g , color.b ) ;

	  SDL_Rect dstrect;
	  dstrect.x = x;
	  dstrect.y = y;
	  dstrect.w = 1;
	  dstrect.h = 1;


	  // copy pixel data the legal way

	  SDL_FillRect(pSurface, &dstrect, col);

      }
   */

  static void set_pixel( SDL_Surface* pSurface , int x , int y , Uint32 rgb);



  static Uint32 get_pixel( const SDL_Surface* pSurface , int x , int y );

private:
  ~ImageUtil() {}
};
#endif // IMAGEUTIL_H_INCLUDED
