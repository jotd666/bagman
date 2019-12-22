#include "GfxFrameSet.hpp"

GfxFrameSet::GfxFrameSet()
{

}

void GfxFrameSet::init(const GfxFrameSet &symmetric, GfxFrame::SymmetryType st)
{
    m_properties = symmetric.m_properties;


    switch (st)
    {
    case GfxFrame::mirror_left:
        set_name(symmetric.get_name().replace("right", "left"));
        break;
    case GfxFrame::mirror_right:
        set_name(symmetric.get_name().replace("left", "right"));
        break;

    case GfxFrame::flip_up:
    case GfxFrame::no_op_clone:
        set_name(symmetric.get_name());
        break;
        default:
        break;
    }

    // symmetrize frames

    MyVector<GfxFrame>::const_iterator it;



    FOREACH(it,symmetric.get_frames())
    {
        add_frame()->init(*it,st);
    }


}

GfxFrame *GfxFrameSet::add_frame()
{
    m_frames.emplace_back();
    return &m_frames.back();
}
