#include "ColorPalette.hpp"
#include <fstream>

void ColorPalette::load(const MyString &filename)
{
    // little endian only!!

    std::ifstream file(filename.c_str(), std::ios::in|std::ios::binary);
    if (file.fail())
    {
        abort_run("cannot load palette file %s",filename);
    }
    file.seekg(4+4+4+4+4 + 2, std::ios::beg); // skip unrelevant stuff


// read in number of colors in the palette
    unsigned short numcolors;
    file.read((char *)&numcolors, 2); // need to read into unsigned short and assign because ncolors is an unsigned int!
    m_palette.ncolors= numcolors;

    if (!m_palette.ncolors)
    {
        m_palette.ncolors= 256; // sanity check
    }
    m_colors.resize(m_palette.ncolors);

    update();

// read in the colors
    file.read((char*)m_palette.colors, 4*m_palette.ncolors);

    file.close();
}

void ColorPalette::update()
{
    m_palette.ncolors = m_colors.size();
    m_palette.colors = m_colors.raw_data();
}

ColorPalette::~ColorPalette()
{

}

void ColorPalette::append(const ColorPalette &other)
{
    MyVector<SDL_Color>::const_iterator it;
    FOREACH(it,other.get_colors())
    {
        m_colors.push_back(*it);
    }

    update();
}
void ColorPalette::set_to(SDL_Surface *dest)
{
    SDL_Palette *p = &m_palette;
    my_assert(p != 0);
	SDL_SetColors(dest, p->colors, 0, p->ncolors);

}
