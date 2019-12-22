#ifndef FONTS_H_INCLUDED
#define FONTS_H_INCLUDED

#include "Abortable.hpp"
#include "MyMacros.hpp"
#include "ImageFrame.hpp"
#include "SDLRectangle.hpp"

#include <map>

/**
 * class used to write texts to the screen
 */

class Fonts : public Abortable
{
public:
  DEF_GET_STRING_TYPE(Fonts)
  Fonts(bool rotate_90=false);
  int get_height() const;
  int get_width() const;
  void load(const MyString &font_basename);

  //void get_monochrome_clone(Fonts &f, int monochrome_color) const;
  void write(Drawable &screen, int x, int y, const MyString &text,
	     bool multi_line = false, bool centered = false) const;

  SDLRectangle get_bounds(Drawable &screen, int x, int y,
			  const MyString &text, bool centered) const;

private:
  void write_line(Drawable &screen, int x, int y, const MyString &text, bool centered) const;
  typedef  std::map<char, int> LetterMap;
  LetterMap letters;
  ImageFrame m_pic;
  int m_tile_side;
  bool m_rotate_90;
  DEF_CLASS_COPY(Fonts); // no copy/affectation

};
#endif
