#ifndef IMAGEFRAME_H_INCLUDED
#define IMAGEFRAME_H_INCLUDED

#include "Drawable.hpp"

/**
 * wraps SDL images (SDL_Surface)
 * the interesting thing is that they can be copied, put in lists, etc...
 * without danger of memory leaks/double frees
 */

class ImageFrame : public Drawable
{
public:

  DEF_GET_STRING_TYPE(ImageFrame);

  /**
   * create from source surface
   * @warn source is destroyed upon class deletion
   */

  ImageFrame(SDL_Surface *source = 0, bool alpha = false);

  void init(SDL_Surface *source, bool alpha);
  void set_alpha(int alpha);

  bool get_alpha() const
  {
    return m_alpha;
  }

  /**
   * initialize from image file
   * @param image_file path to image
   * @param scale 100 for 100% scale
   */

  void load(const MyString &image_file, int scale = 100);

  /**
   * save image to file
   * @param image_file path to save to
   */

  void save(const MyString &image_file) const;

  /**
   * create a blank image with given descriptions
   * @param alpha true enables alpha channel
   */
  void create_like(const ImageFrame &model);

  DEF_CLASS_COPY(ImageFrame);

  int get_pixel(int x, int y) const;
  void set_pixel(int x, int y, Uint32 value);

  ImageFrame get_rotated_90(bool positive) const;
  void rotate_90(bool positive); // in-place

  void render_mirror(Drawable &target) const;
  void render_flip(Drawable &target) const;
  void replace_color(int old_argb, int new_argb);
  void set_palette_to(Drawable &target);

  ~ImageFrame();

  /**
   * set transparent color
   * @param rgb transparent RGB value
   */

  void set_transparency(int rgb);

  // this isn't compatible with blitted images on amiga
  void create(int w, int h, bool alpha = false);

private:
  void destroy();
  bool m_alpha;
  void copy_from(const ImageFrame &other);

};

#endif // IMAGEFRAME_H_INCLUDED
