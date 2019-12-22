#ifndef SDLCOLORPALETTE_H_INCLUDED
#define SDLCOLORPALETTE_H_INCLUDED

#include <SDL/SDL.h>
#include "MyVector.hpp"
#include "Drawable.hpp"
#include "DisplayDepth.hpp"

class SdlColorPalette
{
    #if DISPLAY_DEPTH == 8
    public:
        void copy_from_source(Drawable &d);
        void set_to_target(Drawable &d);
        /**
        * @param rgb_to_mix: leave to 0 for fadein/fadeout
        */

        void set_to_target(Drawable &d, int percent, int rgb_to_mix = 0);
        int get_nb_colors() const
        {
            return m_colors.size();
        }
        int get_rgb(int index) const;
        void set_rgb(int index, int value);
    private:
       MyVector<SDL_Color> m_colors;
       MyVector<SDL_Color> m_colors_temp;
    #endif

};

#endif // SDLCOLORPALETTE_H_INCLUDED
