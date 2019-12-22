#include "AnimatedObject.hpp"
#include "MyFile.hpp"

void AnimatedObject::set_anim_type(Type anim_type)
{
  m_is_done = false;
  m_anim_type = anim_type;
  m_direction = 1;

  if (m_anim_type == REVERSE)
    {
      m_direction = -1;
    }
}

AnimatedObject::AnimatedObject(Type anim_type,bool transparent)
{

  AnimatedObject::set_anim_type(anim_type);
  m_transparent = transparent;
  m_current_frame = 0;
  m_nb_frames = 1;

  m_pos_ref = 0;

  set_frame_range(); // full range


}
int AnimatedObject::get_nb_frames(bool ignore_limit) const
{
  return ignore_limit ? m_nb_frames : m_end_frame - m_start_frame + 1;
}
void AnimatedObject::set_current_frame(int current_frame)
{
  if (current_frame >= m_start_frame && current_frame <= m_end_frame)
    {
      m_current_frame = current_frame;
      m_is_done = false;
    }
}
void AnimatedObject::set_nb_frames(int nbf)
{
  m_nb_frames = nbf;
  set_frame_range();

}

void AnimatedObject::first()
{
  m_is_done = false;

  switch (m_anim_type)
    {
      case REVERSE:
	m_current_frame = m_end_frame - 1;
	break;
      case BACK_AND_FORTH:
	m_current_frame = m_start_frame;
	m_direction = 1;
	break;
      default:
	m_current_frame = m_start_frame;
	break;
    }
}
void AnimatedObject::set_frame_range(int sf, int ef)
{
  m_start_frame = std::max(sf,0);
  m_end_frame = std::min(ef,m_nb_frames-1);

  // correct current frame to be in bounds in case it is not
  m_current_frame = std::min(m_end_frame,m_current_frame);
  m_current_frame = std::max(m_start_frame,m_current_frame);

  m_is_done = false;
}

void AnimatedObject::prev()
{
  ENTRYPOINT(prev);

  m_current_frame -= m_direction;

  if (m_current_frame > m_end_frame)
    {
      switch (m_anim_type)
	{
	  case REVERSE:
	    m_current_frame = m_end_frame;
	    m_is_done = true;
	    break;
	  case BACK_AND_FORTH:
	    m_current_frame = m_end_frame - 1;
	    m_direction = 1;
	    break;
	  default:
	    m_current_frame = m_start_frame;
	    break;
	}
    }
  else if (m_current_frame < m_start_frame)
    {
      switch (m_anim_type)
	{
	  case RUN_ONCE:
	    m_current_frame = m_start_frame;
	    m_is_done = true;
	    break;
	  case BACK_AND_FORTH:
	    m_current_frame = m_start_frame + 1;
	    m_direction = -1;
	    break;
	  default:
	    m_current_frame = m_end_frame;
	    break;
	}
    }
  EXITPOINT;

}


void AnimatedObject::next()
{
  ENTRYPOINT(next);

  m_current_frame += m_direction;

  if (m_current_frame > m_end_frame)
    {
      switch (m_anim_type)
	{
	  case RUN_ONCE:
	    m_current_frame = m_end_frame;
	    m_is_done = true;
	    break;
	  case BACK_AND_FORTH:
	    m_current_frame = m_end_frame - 1;
	    m_direction = -1;
	    break;
	  default:
	    m_current_frame = m_start_frame;
	    break;
	}
    }
  else if (m_current_frame < m_start_frame)
    {
      switch (m_anim_type)
	{
	  case REVERSE:
	    m_current_frame = m_start_frame;
	    m_is_done = true;
	    break;
	  case BACK_AND_FORTH:
	    m_current_frame = m_start_frame + 1;
	    m_direction = 1;
	    break;
	  default:
	    m_current_frame = m_end_frame;
	    break;
	}
    }
  EXITPOINT;
}
