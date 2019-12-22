#include "AnimatedSprite.hpp"
#include "MyFile.hpp"
#include "GfxFrameSet.hpp"
#include "ScaleSize.hpp"
#ifdef __amigaos
    #define m_x_render_extra_offset 0
#define m_y_render_extra_offset 0
#endif

AnimatedSprite::AnimatedSprite() : m_frames(0)
{

}
void AnimatedSprite::set_update_rate(int update_rate)
{
  if (update_rate > 0)
    {
      m_update_rate = update_rate;
    }
}

void AnimatedSprite::set_xy_render_offset(int x_offset, int y_offset)
{
  m_x_render_offset = x_offset;
  m_y_render_offset = y_offset;
}
// no need to add useless code
#ifndef __amigaos__
void AnimatedSprite::set_xy_render_extra_offset(int x_offset, int y_offset)
{
  m_x_render_extra_offset = x_offset;
  m_y_render_extra_offset = y_offset;
}
#endif

void AnimatedSprite::set_anim_type(Type anim_type)
{
  AnimatedObject::set_anim_type(anim_type);
  my_assert(m_anim_type == CUSTOM || m_update_rate != 0);
}

const GfxFrame::Properties &AnimatedSprite::get_properties() const
{
  return m_frames->get_properties();
}
void AnimatedSprite::set_frame_set(const GfxFrameSet *frame_set)
{
  m_frames = frame_set;
  set_nb_frames(frame_set->get_nb_frames());
  m_update_rate = frame_set->get_properties().update_rate;
  set_anim_type(frame_set->get_properties().animation_type);


  set_name(frame_set->get_name());

  set_w(frame_set->get_first_frame().get_w()/SCALE_SIZE);
  set_h(frame_set->get_first_frame().get_h()/SCALE_SIZE);


}
void AnimatedSprite::init(const GfxFrameSet *frame_set,
			  const Locatable *pos_ref)
{
  ENTRYPOINT(init);

  set_frame_set(frame_set);



  m_pos_ref = pos_ref;

  if ((m_anim_type != CUSTOM) && (m_update_rate == 0))
    {
      abort_run("update rate is 0: animation type should be CUSTOM");
    }
  EXITPOINT;

}



void AnimatedSprite::update(int elapsed)
{
  ENTRYPOINT(update);

  if (m_anim_type != CUSTOM)
    {
      m_elapsed += elapsed;
      while (m_elapsed >= m_update_rate)
	{
	  m_elapsed -= m_update_rate;
	  next();
	}
    }
  EXITPOINT;
}


void AnimatedSprite::render(Drawable &screen) const
{
  render(screen,get_current_frame());
}
void AnimatedSprite::render(Drawable &screen,int current_frame) const
{
  my_assert(m_frames != 0);

  const GfxFrameSet &gfs = *m_frames;
  const GfxFrame &d = gfs[current_frame];

  if (m_pos_ref == 0)
    {
      d.render(screen,(get_x() + m_x_render_offset + m_x_render_extra_offset),
	       (get_y() + m_y_render_offset + m_y_render_extra_offset));
    }
  else
    {
      d.render(screen,(m_pos_ref->get_x() + m_x_render_offset + m_x_render_extra_offset),
	       (m_pos_ref->get_y() + m_y_render_offset + m_y_render_extra_offset));
    }
}
