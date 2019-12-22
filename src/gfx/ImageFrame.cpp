#include "ImageFrame.hpp"
#include "MyAssert.hpp"

#include "ImageUtil.hpp"

void ImageFrame::load(const MyString &image_file, int scale)
{
  ENTRYPOINT(load);

  destroy();
  m_buffer = ImageUtil::load_image(image_file);

  if (m_buffer == 0)
    {
      abort_run("cannot load %q: %s",image_file,SDL_GetError());
    }


  m_buffer = ImageUtil::resize(m_buffer,scale);

  m_alpha = ImageUtil::is_transparent(m_buffer);


  EXITPOINT;
}

int ImageFrame::get_pixel(int x, int y) const
{
  my_assert(x >=0 and x < get_w());
  my_assert(y >=0 and y < get_h());
  return ImageUtil::get_pixel(m_buffer,x,y);

}
void ImageFrame::set_pixel(int x, int y, Uint32 value)
{
  my_assert(x >=0 and x < get_w());
  my_assert(y >=0 and y < get_h());
  ImageUtil::set_pixel(m_buffer,x,y,value);

}
void ImageFrame::save(const MyString &image_file) const
{
  if (m_buffer != 0)
    {
      SDL_SaveBMP(m_buffer,image_file.c_str());
    }
}


void ImageFrame::set_palette_to(Drawable &target)
{
  SDL_Palette *p = m_buffer->format->palette;
  my_assert(p != 0);
  SDL_SetColors(target.data(), p->colors, 0, p->ncolors);

}
void ImageFrame::rotate_90(bool positive)
{
  ENTRYPOINT(rotate_90);
  SDL_Surface *new_buffer = ImageUtil::create_image(get_h(),get_w());
  ImageUtil::rotate_90(m_buffer,new_buffer,positive);
  destroy();
  m_buffer = new_buffer;
  EXITPOINT;
}

ImageFrame ImageFrame::get_rotated_90(bool positive) const
{
  ImageFrame rval;
  ENTRYPOINT(get_rotated_90);
  rval.create(get_w(),get_h(),m_alpha);

  ImageUtil::rotate_90(m_buffer,rval.m_buffer,positive);
  EXITPOINT;
  return rval;
}
ImageFrame::ImageFrame(SDL_Surface *source, bool alpha)
{
  init(source,alpha);
}
ImageFrame::ImageFrame(const ImageFrame &other) : Drawable()
{
  copy_from(other);
}
ImageFrame &ImageFrame::operator=(const ImageFrame &other)
{
  if (&other != this)
    {
      copy_from(other);
    }
  return *this;
}




void ImageFrame::copy_from(const ImageFrame &other)
{
  destroy();

  m_alpha = other.m_alpha;

  if (other.data() != 0)
    {
      m_buffer = ImageUtil::clone_image(other.data());
      if (m_buffer == 0)
	{
	  abort_run("Cannot clone image: %s",SDL_GetError());
	}
    }


}

ImageFrame::~ImageFrame()
{
  destroy();
}

void ImageFrame::create(int w, int h, bool alpha)
{
  ENTRYPOINT(create);

  destroy();

  if (alpha)
    {
      m_buffer = ImageUtil::create_alpha_image(w, h);
    }
  else
    {
      m_buffer = ImageUtil::create_image(w, h);
    }
  if (m_buffer == 0)
    {
      abort_run("Cannot create image w=%d, h=%d: %s",w,h,SDL_GetError());
    }
  m_alpha = alpha;
  EXITPOINT;
}
void ImageFrame::set_alpha(int alpha)
{
  my_assert(m_buffer != 0);
  //my_assert(m_alpha == false); // no effect
  SDL_SetAlpha(m_buffer,SDL_SRCALPHA,alpha);
}

void ImageFrame::init(SDL_Surface *source, bool alpha)
{
  destroy();
  m_buffer = source;
  m_alpha = alpha;
}

void ImageFrame::destroy()
{
  ENTRYPOINT(destroy);
  if (m_buffer != 0)
    {
      // LOGGED_MANUAL_DELETE(m_buffer);
      SDL_FreeSurface(m_buffer);
      m_buffer = 0;
    }
  EXITPOINT;
}

void ImageFrame::replace_color(int old_argb, int new_argb)
{
  ImageUtil::replace_color_in_place(m_buffer,old_argb,new_argb);
}

void ImageFrame::render_mirror(Drawable &target) const
{
  ImageUtil::mirror(m_buffer,target.data());
}

void ImageFrame::render_flip(Drawable &target) const
{
  ImageUtil::flip(m_buffer,target.data());
}


void ImageFrame::set_transparency(int rgb)
{
  ImageUtil::set_transparency(m_buffer,rgb);
}
