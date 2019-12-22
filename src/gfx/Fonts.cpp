#include "Fonts.hpp"
#include "SDL/SDL.h"
#include "ImageUtil.hpp"
#include "DirectoryBase.hpp"
#include "ScaleSize.hpp"

Fonts::Fonts(bool rotate_90) : m_rotate_90(rotate_90)
{
}


/*void Fonts::get_monochrome_clone(Fonts &dest, int monochrome_color) const
  {
  LetterMap::const_iterator it;

  FOREACH(it,letters)
  {
    SDL_Surface *img = ImageUtil::make_bicolor(it->second.data(),0,monochrome_color,false);
    dest.letters.insert(std::make_pair(it->first,ImageFrame(img)));
  }

  dest.m_tile_side = m_tile_side;

  }*/

void Fonts::load(const MyString &font_basename)
{
  ENTRYPOINT(load);
  static const char *c ="ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:0123456789 ";

  letters.clear();


  MyString s = DirectoryBase::get_images_path() / font_basename + DirectoryBase::get_images_extension();

  m_pic.load(s,100*SCALE_SIZE);
  m_pic.set_transparency(0);
  m_tile_side = 8*SCALE_SIZE;

  int nb_cols = m_pic.get_w() / m_tile_side;

  SDL_Rect src_clip;
  src_clip.w = m_tile_side;
  src_clip.h = m_tile_side;
  src_clip.y = 0;

  //int nb_tiles = nb_rows * nb_cols;

  // create tiles

  int k = 0;

  src_clip.x = 0;

  for (int j = 0; j < nb_cols; j++)
    {
      // create the entry and get the created image
      letters.insert(std::make_pair(c[k++],src_clip.x));
      // get the reference and manipulate it now (thus avoiding heavy memory copies)


      src_clip.x += m_tile_side;

    }

  EXITPOINT;
}

SDLRectangle Fonts::get_bounds(Drawable &screen, int x, int y,
			       const MyString &text, bool centered) const
{
  SDLRectangle rval;

  rval.y = y;
  rval.x = x;
  rval.h = m_tile_side;
  rval.w = m_tile_side * text.size();

  if (centered)
    {
      rval.x += (screen.get_w() - text.size() * m_tile_side)/2;
    }

  /*if (multi_line)
    {
      MyVector<MyString> lines = text.split('\n');
      rval.h = m_tile_side * lines.size();
    }*/

  return rval;
}

void Fonts::write(Drawable &screen, int x, int y,
		  const MyString &text, bool multi_line, bool centered) const
{
  if (multi_line)
    {
      MyVector<MyString> lines = text.split('\n');

      int y_pos = y;

      for (auto &line : lines)
	{
	  write_line(screen, x, y_pos,line, centered);
	  y_pos += m_tile_side;
	}
    }
  else
    {
      write_line(screen,x,y,text,centered);
    }
}

void Fonts::write_line(Drawable &screen, int x, int y,
		       const MyString &text, bool x_centered) const
{


  SDL_Rect src_clip,img_clip;
  src_clip.w = m_tile_side;
  src_clip.h = m_tile_side;
  img_clip = src_clip;
  img_clip.y = 0;
  src_clip.x = x+8; // amiga needs 8 ..
  src_clip.y = y;
  if (x_centered)
    {
      src_clip.x += (screen.get_w() - text.size() * m_tile_side)/2;
      //src_clip.y += screen->h/2;
    }

  for (auto c : text)
    {

      LetterMap::const_iterator it = letters.find(c);

      if (it != letters.end())
	{

	  img_clip.x = it->second;
	  m_pic.render(screen, &img_clip, &src_clip);
	  //SDL_SetAlpha(it->second.data(),SDL_SRCALPHA,m_alpha);

	}

      src_clip.x += m_tile_side/SCALE_SIZE;

    }


}
int Fonts::get_height() const
{
  return m_tile_side;
}
int Fonts::get_width() const
{
  return m_tile_side;
}
