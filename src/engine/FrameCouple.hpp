#ifndef FRAMECOUPLE_H_INCLUDED
#define FRAMECOUPLE_H_INCLUDED

#include "MyString.hpp"
#include "AnimatedSprite.hpp"

class GfxPaletteSet;
class Locatable;

enum Direction { LEFT, RIGHT };

class FrameCouple
{
public:
    FrameCouple()
    {}


    void set(const GfxFrameSet *left_frame_set,const GfxFrameSet *right_frame_set,const Locatable *pos_ref);

    inline void set_xy_render_offset(int xeo, int yeo)
    {
        right.set_xy_render_offset(xeo,yeo);
        left.set_xy_render_offset(xeo,yeo);
    }

    inline AnimatedSprite &get(Direction d)
    {
        return d == RIGHT ? right : left;
    }
    inline const AnimatedSprite &get(Direction d) const
    {
        return d == RIGHT ? right : left;
    }

    inline void first()
    {
        right.first();
        left.first();
    }
    inline void set_current_frame(int cf)
    {
        right.set_current_frame(cf);
        left.set_current_frame(cf);
    }
    inline int get_current_frame() const
    {
        return right.get_current_frame();
    }
    void set_anim_type(AnimatedObject::Type anim_type)
    {
        left.set_anim_type(anim_type);
        right.set_anim_type(anim_type);
    }
    void update(int elapsed_time)
    {
        left.update(elapsed_time);
        right.update(elapsed_time);
    }
    inline void next()
    {
        left.next();
        right.next();
    }
    inline void prev()
    {
        left.prev();
        right.prev();
    }
    inline bool is_done() const
    {
        return left.is_done();
    }
    inline void set_frame_range(int start = 0, int end = INT_MAX)
    {
        right.set_frame_range(start,end);
        left.set_frame_range(start,end);
    }
private:
    AnimatedSprite right;
    AnimatedSprite left;
};

#endif // FRAMECOUPLE_H_INCLUDED
