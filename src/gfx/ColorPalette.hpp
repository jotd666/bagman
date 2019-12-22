#ifndef COLORPALETTE_H_INCLUDED
#define COLORPALETTE_H_INCLUDED
#include <SDL/SDL.h>

#include "MyVector.hpp"
#include "Abortable.hpp"

class ColorPalette : public Abortable
{
    public:
    DEF_GET_STRING_TYPE(ColorPalette);
    void load(const MyString &filename);
    void append(const ColorPalette &other);

    const MyVector<SDL_Color> &get_colors() const
    {
        return m_colors;
    }

   void set_to(SDL_Surface *dest);

  ~ColorPalette();
  private:
  SDL_Palette m_palette;
  MyVector<SDL_Color> m_colors;
  void update();


};
#endif // COLORPALETTE_H_INCLUDED
