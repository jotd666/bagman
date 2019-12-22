#include "FrameCouple.hpp"
#include "GfxFrameSet.hpp"
#include "ScaleSize.hpp"

void FrameCouple::set(const GfxFrameSet *left_frame_set,const GfxFrameSet *right_frame_set,const Locatable *pos_ref)
{

    right.init(right_frame_set,pos_ref);

    left.init(left_frame_set,pos_ref);


}
