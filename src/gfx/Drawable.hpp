#ifndef DRAWABLE_H_INCLUDED
#define DRAWABLE_H_INCLUDED

#include "Abortable.hpp"
#include "SDL/SDL.h"
#include "MyAssert.hpp"

class Drawable : public Abortable
{
public:
  DEF_GET_STRING_TYPE(Drawable);

  Drawable(SDL_Surface *source = 0);

  virtual ~Drawable() {}

  virtual void init(SDL_Surface *buffer);
  void render(Drawable &target, int x, int y, int w = -1, int h = -1) const;
  void render(Drawable &target, const SDL_Rect *src = nullptr,const SDL_Rect *dest = nullptr) const;
  void render_half_size(Drawable &target) const;

  int get_w() const
  {
    my_assert(m_buffer != 0);
    return m_buffer->w;
  }
  int get_h() const
  {
    my_assert(m_buffer != 0);
    return m_buffer->h;
  }
  SDL_Palette *get_palette()
  {
    return m_buffer->format->palette;
  }

  inline SDL_Surface *data() const
  {
    return m_buffer;
  }
  inline void set_affine_transformation(int scale, bool rotate_90, int x_trans = 0,int y_trans = 0)
  {
    m_x_translation = x_trans;
    m_y_translation = y_trans;
    m_scale = scale;
    m_rotate_90 = rotate_90;
  }
  void fill_rect(const SDL_Rect *clip = 0, int rgb = 0);

  int get_x_translation() const
  {
    return m_x_translation;
  }
   int get_y_translation() const
  {
    return m_y_translation;
  }

protected:
  SDL_Surface *m_buffer;

private:
  int m_x_translation;
  int m_y_translation;
  int m_scale;
  bool m_rotate_90;

  void compute_dst_rect(const Drawable &target, const SDL_Rect *dst_rect, SDL_Rect &local_dst_rect,bool image_blit) const;

};
#endif
