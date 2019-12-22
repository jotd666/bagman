#ifndef GFXFRAMESET_H
#define GFXFRAMESET_H

#include "GfxFrame.hpp"
#include "AnimatedObject.hpp"

class PrmIo;

/**
* set of animation frames
*/

class GfxFrameSet
{
public:
    const MyString &get_name() const
    {
        return m_name;
    }
    void set_name(const MyString &name)
    {
        m_name = name;
    }

    GfxFrameSet();

    typedef MyVector<GfxFrame> GfxFrameList;

    void init(const ImageFrame &source,PrmIo &fr);

    void init(const GfxFrameSet &symmetric, GfxFrame::SymmetryType st);

    const GfxFrame &get_frame(int counter) const
    {
        return m_frames[counter];
    }
    const GfxFrame &get_first_frame() const
    {
        return m_frames[0];
    }

    const GfxFrame &operator[](int i) const
    {
        return m_frames[i];
    }

    bool operator==(const GfxFrameSet &o) const
    {
        return (get_name() == o.get_name());
    }

    int get_nb_frames() const
    {
        return m_frames.size();
    }


    const GfxFrameList &get_frames() const
    {
        return m_frames;
    }

    const GfxFrame::Properties &get_properties() const
    {
        return m_properties;
    }
    /**
    * @return pointer on newly allocated frame (to initialize properly)
    */

    GfxFrame *add_frame();

private:

    MyString m_name;
    GfxFrame::Properties m_properties;
    GfxFrameList m_frames;
    AnimatedObject::Type m_anim_type;



};
#endif
