#include "Drawable.hpp"
#include "ImageUtil.hpp"

Drawable::Drawable(SDL_Surface *source) : m_buffer(source), m_x_translation(0), m_y_translation(0), m_scale(1), m_rotate_90(false)
{

}
void Drawable::render_half_size(Drawable &target) const
{
  ImageUtil::render_half_size(m_buffer,target.data(),m_x_translation,m_y_translation,
			      target.m_x_translation,target.m_y_translation);
}


void Drawable::init(SDL_Surface *buffer)
{
  m_buffer = buffer;
}


inline void Drawable::compute_dst_rect(const Drawable &target, const SDL_Rect *dst_rect, SDL_Rect &local_dst_rect, bool image_blit) const
{
  // different behaviour image vs rectfill: w & h must be scaled & swapped when calling this function
  // because images are already scaled (so completely transparent here)
  // but rectangles are not


  if (dst_rect == nullptr)
    {
      local_dst_rect.x = 0;
      local_dst_rect.y = 0;
      local_dst_rect.w = target.get_w();
      local_dst_rect.h = target.get_h();
    }
  else
    {
      local_dst_rect = *dst_rect;
    }

  if (!image_blit)
    {
      if (target.m_rotate_90)
	{
	  int sw = local_dst_rect.h * target.m_scale;
	  local_dst_rect.h = local_dst_rect.w * target.m_scale;
	  local_dst_rect.w = sw;
	}
      else
	{
	  local_dst_rect.w *= target.m_scale;
	  local_dst_rect.h *= target.m_scale;
	}
    }

  local_dst_rect.x += target.m_x_translation;
  local_dst_rect.y += target.m_y_translation;

  local_dst_rect.x *= target.m_scale;
  local_dst_rect.y *= target.m_scale;


  if (target.m_rotate_90)
    {
      int ysav = local_dst_rect.x;
      local_dst_rect.x = local_dst_rect.y;
      int th = target.get_h();

      local_dst_rect.y = th - ysav - local_dst_rect.h;
    }

}


void Drawable::fill_rect(const SDL_Rect *clip, int rgb)
{
  my_assert(m_buffer != 0);
  SDL_Rect local_dst_rect;

  compute_dst_rect(*this,clip,local_dst_rect,false);
  SDL_FillRect(m_buffer,&local_dst_rect,rgb);
}

void Drawable::render(Drawable &target, const SDL_Rect *src_rect, const SDL_Rect *dst_rect) const
{
  my_assert(m_buffer != 0);


  SDL_Rect local_dst_rect;

  compute_dst_rect(target,dst_rect,local_dst_rect,true);

  SDL_BlitSurface((SDL_Surface *)m_buffer,(SDL_Rect*)src_rect,target.data(),&local_dst_rect);
}

void Drawable::render(Drawable &target, int x, int y, int w, int h) const
{
  // create dest rectangle
  SDL_Rect source_rect,dest_rect;
  source_rect.x = 0;
  source_rect.y = 0;
  source_rect.w = w == -1 ? m_buffer->w : w;
  source_rect.h = h == -1 ? m_buffer->h : h;
  dest_rect.x = x;
  dest_rect.y = y;
  // call the render function using the clip
  render(target,&source_rect,&dest_rect);
}
