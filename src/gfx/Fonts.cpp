#include "Fonts.hpp"
#include "SDL/SDL.h"
#include "ImageUtil.hpp"
#include "DirectoryBase.hpp"
#include "ScaleSize.hpp"

Fonts::Fonts(bool rotate_90) : m_rotate_90(rotate_90)
{
}


void Fonts::replace_color(int start_color, int end_color)
{
  LetterMap::iterator it;


  FOREACH(it,letters)
  {
    ImageUtil::replace_color_in_place(it->second.data(),start_color,end_color);
  }

}
void Fonts::load(const MyString &font_basename)
{
  ENTRYPOINT(load);
  static const char *c ="ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:0123456789 ";

  letters.clear();

  ImageFrame img;
  MyString s = DirectoryBase::get_images_path() / font_basename + DirectoryBase::get_images_extension();

  img.load(s,100*SCALE_SIZE);
  img.set_transparency(0);
  m_tile_side = 8*SCALE_SIZE;

  int nb_rows = img.get_h() / m_tile_side;
  int nb_cols = img.get_w() / m_tile_side;

  SDL_Rect src_clip;
  src_clip.w = m_tile_side;
  src_clip.h = m_tile_side;
  src_clip.y = 0;

  //int nb_tiles = nb_rows * nb_cols;

  // create tiles

  int k = 0;

  for (int i = 0; i < nb_rows; i++)
    {
      src_clip.x = 0;

      for (int j = 0; j < nb_cols; j++)
	{
	  // create the entry and get the created image
	  std::map<char,ImageFrame>::iterator p = letters.insert(std::make_pair(c[k++],ImageFrame())).first;
	  // get the reference and manipulate it now (thus avoiding heavy memory copies)
	  ImageFrame &d = p->second;
	  d.create(m_tile_side, m_tile_side);

	  d.set_transparency(0xFF00FF);  // magenta => no transparency here

	  img.render(d, &src_clip, 0);
	  if (m_rotate_90)
	    {
	      d.rotate_90(true);
	    }

	  src_clip.x += m_tile_side;

	}
      src_clip.y += m_tile_side;
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
      MyVector<MyString>::const_iterator it;
      int y_pos = y;

      for (it = lines.begin(); it != lines.end(); it++)
	{
	  write_line(screen, x, y_pos, *it, centered);
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

  const char *t = text.c_str();

  SDL_Rect src_clip;
  src_clip.w = m_tile_side;
  src_clip.h = m_tile_side;
  src_clip.x = x;
  src_clip.y = y;
  if (x_centered)
    {
      src_clip.x += (screen.get_w() - text.size() * m_tile_side)/2;
      //src_clip.y += screen->h/2;
    }

  for (unsigned int i = 0; i < text.size(); i++)
    {
      char c = t[i];

      LetterMap::const_iterator it = letters.find(c);

      if (it != letters.end())
	{
	  //SDL_SetAlpha(it->second.data(),SDL_SRCALPHA,m_alpha);
	  it->second.render(screen, 0, &src_clip);
	}

      src_clip.x += m_tile_side/SCALE_SIZE;

    }


}
int Fonts::get_height() const
{
  return letters.begin()->second.get_h();
}
int Fonts::get_width() const
{
  return letters.begin()->second.get_w();
}
