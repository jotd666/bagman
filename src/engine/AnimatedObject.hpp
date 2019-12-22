#ifndef ANIMATEDOBJECT_H_INCLUDED
#define ANIMATEDOBJECT_H_INCLUDED

#include "Renderable.hpp"
#include "MyVector.hpp"
#include "ImageFrame.hpp"

#include <climits>

class GfxFrameSet;

class AnimatedObject : public Renderable
{
public:
    DEF_GET_STRING_TYPE(AnimatedObject);

    enum Type { RUN_ONCE, FOREVER, REVERSE, BACK_AND_FORTH, CUSTOM};

    AnimatedObject(Type anim_type = CUSTOM, bool transparent = true);

    virtual ~AnimatedObject()
    {
    }

    virtual void update(int elapsed) = 0;


    bool is_done() const
    {
        return m_is_done;
    }

    void next();
    void prev();

    virtual void set_anim_type(Type anim_type);

    int get_nb_frames(bool ignore_limit = false) const;

    int get_current_frame() const
    {
        return m_current_frame;
    }
    void set_current_frame(int current_frame);

    void first();

    void set_frame_range(int sf = 0, int ef = INT_MAX);

    inline Type get_anim_type() const
    {
        return m_anim_type;
    }


protected:
    bool m_transparent;
    const Locatable *m_pos_ref;
    void set_nb_frames(int nbf);
    Type m_anim_type;

private:
    int m_current_frame;
    int m_nb_frames;
    int m_direction;
    int m_start_frame;
    int m_end_frame;

    bool m_is_done;


};

#endif // ANIMATEDSEQUENCE_H_INCLUDED
