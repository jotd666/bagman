#include "GfxObject.hpp"
#include "MPLevel.hpp"

static const int FALL_UPDATE_RATE = 50/6;


bool GfxObject::is_on_slope() const
{
  GroundType gt = compute_ground_type();
  return ((gt == GT_SLOPE_LEFT) || (gt == GT_SLOPE_RIGHT));
}
GfxObject::GroundType GfxObject::compute_ground_type() const
{
  // works OK as long as the object is not set too "deep" in the ground
  // subbing 1 to y when releasing the item did the trick

  GfxObject::GroundType rval = GT_SOLID;

  int y_round = get_y() + get_h();
  int x_min = get_x();
  int x_max = x_min + 8;
  bool bl = m_grid->is_lateral_way_blocked(x_min, y_round);
  bool br = m_grid->is_lateral_way_blocked(x_max, y_round);

  if (bl && br)
    {
      //rval = GT_SOLID;
    }
  else
    {
      if (!bl && !br)
	{
	  rval = GT_GAP;
	}
      else if (br)
	{
	  // right blocked: check slope
	  if (m_grid->is_lateral_way_blocked(x_min, y_round+1))
	    {
	      rval = GT_SLOPE_LEFT;
	    }
	}
      else
	{
	  // left blocked: check slope
	  if (m_grid->is_lateral_way_blocked(x_max, y_round+1))
	    {
	      rval = GT_SLOPE_RIGHT;
	    }
	}
    }
  return rval;
}

void GfxObject::update(int elapsed_time)
{
  m_moving = false;

  if (is_bag())
    {
      // optim: test fall only when needed

      m_timer += elapsed_time;

      while (m_timer > FALL_UPDATE_RATE)
	{
	  first();
	  m_timer -= FALL_UPDATE_RATE;


	  GroundType gt = compute_ground_type();


	  switch(gt)
	    {
	      case GT_GAP:
		// add 6 if free fall (other case: slope fall)
		set_xy_render_offset(m_previous_ground_type == GT_GAP ? 6 : 0,8);
		add_y(1);
		m_moving = true;
		break;
	      case GT_SLOPE_LEFT:
		set_xy_render_offset(0,8);
		add_x(-1);
		m_moving = true;
		break;
	      case GT_SLOPE_RIGHT:
		set_xy_render_offset(0,8);
		add_x(1);
		m_moving = true;
		break;
	      default:
		set_xy_render_offset(0,0);
		break;

	    }
	  m_previous_ground_type = gt;
	  if (m_moving)
	    {
	      set_current_frame(2); // falling bag frame
	    }


	}
    }
}

void GfxObject::init()
{
  m_moving = false;
  m_timer = 0;
  m_grid = &m_level->get_grid();
  m_previous_ground_type = GT_SOLID;
  switch (m_type)
    {
      case YELLOW_BAG:
      case BLUE_BAG:
	m_x_offset = 6;
	break;
      case PICK:
	m_x_offset = 3;
	break;
      default:
	m_x_offset = 0;
	break;
    }
}

void GfxObject::set_frames(const GfxFrameSet *frame_set)
{
  AnimatedSprite::init(frame_set);
  // kludge to fix bag render shift problem when using rotated 90 mode (unsolved yet)

  if (is_bag() && get_w() > get_h())
    {
        set_xy_render_extra_offset(0,-6);
    }
}


GfxObject::GfxObject(const GfxFrameSet *frame_set,MPLevel *level, Type t) : m_level(level),m_type(t)
{
  init();

  // object created while in game: use current sub-level id

  set_frames(frame_set);

}



