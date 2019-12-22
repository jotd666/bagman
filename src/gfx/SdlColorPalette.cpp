#include "SdlColorPalette.hpp"
#include "ImageUtil.hpp"

#if DISPLAY_DEPTH == 8
#include <stdlib.h>


void SdlColorPalette::copy_from_source(Drawable &d)
{
    m_colors.clear();
    SDL_Palette *p = d.get_palette();
    int ncolors = p->ncolors;
    m_colors.resize(ncolors);
    m_colors_temp.resize(ncolors);

    memcpy(m_colors.raw_data(),p->colors,sizeof(SDL_Color)*ncolors);

}

int SdlColorPalette::get_rgb(int index) const
{
    const SDL_Color &c = m_colors[index];
    return ImageUtil::color2rgb(c);
}

void SdlColorPalette::set_rgb(int index, int value)
{
    m_colors[index] = ImageUtil::rgb2color(value);
}


void SdlColorPalette::set_to_target(Drawable &d)
{
    SDL_SetPalette(d.data(),SDL_PHYSPAL,m_colors.raw_data(),0,m_colors.size());
}

void SdlColorPalette::set_to_target(Drawable &d, int percent, int rgb_to_mix)
{
    int ncolors = m_colors.size();
    int percent_complement = 100 - percent;
    int r_to_mix = (rgb_to_mix >> 16) * percent_complement;
    int g_to_mix = ((rgb_to_mix >> 8) & 0xff) * percent_complement;
    int b_to_mix = (rgb_to_mix & 0xff) * percent_complement;

    for (int i = 0; i < ncolors; i++)
    {
        SDL_Color &c = m_colors_temp[i];
        const SDL_Color &sc = m_colors[i];

        c.r = ((sc.r * percent) + r_to_mix) / 100;
        c.g = ((sc.g * percent) + g_to_mix) / 100;
        c.b = ((sc.b * percent) + b_to_mix) / 100;
    }

    // only change physical palette, not logical palette, thus allowing effects
    // like fadein/fadeout

    SDL_SetPalette(d.data(),SDL_PHYSPAL,m_colors_temp.raw_data(),0,ncolors);
}

#endif

