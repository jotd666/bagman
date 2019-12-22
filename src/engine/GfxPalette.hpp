#ifndef GFXPALETTE_H
#define GFXPALETTE_H

#include "Abortable.hpp"
#include "GfxFrameSet.hpp"
#include "ImageFrame.hpp"
#include "FrameCouple.hpp"

/**
* contains all GfxFrameSet objects for the game
* for Bagman game, they are hardcoded
*
* but for other more complex games, it can contain a dictionary
* and a search by name rather than hardcoded GfxFrameSet attributes
*/

class GfxPalette : public Abortable
{
public:
    DEF_GET_STRING_TYPE(GfxPalette);

    GfxPalette(bool rotate_90);

    MyVector<ImageFrame> playfield;

    struct LeftRight
    {
        GfxFrameSet left,right;
    };
    LeftRight player;
    LeftRight guard;
    LeftRight held_pickaxe;
    GfxFrameSet yellow_bag;
    GfxFrameSet blue_bag;
    GfxFrameSet wagon;
    GfxFrameSet barrow;
    GfxFrameSet pickaxe;
    GfxFrameSet guard_special;
    GfxFrameSet player_special;
    GfxFrameSet elevator_red,elevator_orange;
    GfxFrameSet wire;
    GfxFrameSet wall_break;
    ImageFrame life;
    ImageFrame title;
    ImageFrame presents;
    ImageFrame va_logo;
    private:
    bool m_rotate_90;
    void init_character_lr(LeftRight &lr,const MyString &id, int nb_frames);
    MyString make_sprite_name(const MyString &n) const;
   void add_frame(GfxFrameSet &gfs,const MyString &name);
    MyString m_sprites_dir;
    void load_image(ImageFrame &img, const MyString &image_basename);

};
#endif

