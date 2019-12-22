#ifndef ANIMATEDSEQUENCE_H_INCLUDED
#define ANIMATEDSEQUENCE_H_INCLUDED

#include "AnimatedObject.h"
#include "MyVector.h"
#include "ImageFrame.h"

class GfxFrameSet;

class AnimatedSequence : public AnimatedObject
{
public:
    DEF_GET_STRING_TYPE(AnimatedSequence);

    virtual ~AnimatedSequence();

    AnimatedSequence(const MyString &dir_name, int update_rate, Type flags = CUSTOM, bool transparent = true);

    void set_alpha(int alpha)
    {
        m_alpha = alpha;
    }
    void update(int elapsed);

    virtual void render(Drawable &screen) const;

private:
    MyVector<ImageFrame> m_frames;
    int m_alpha;
    int m_elapsed;
    int m_update_rate;
    // no copy/affectation
    //DEF_CLASS_COPY(AnimatedSequence);
};

#endif // ANIMATEDSEQUENCE_H_INCLUDED
