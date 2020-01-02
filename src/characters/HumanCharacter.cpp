#include "HumanCharacter.hpp"
#include "MPLevel.hpp"
#include "SoundSet.hpp"
#include "ScaleSize.hpp"

#include "Player.hpp"

static const int WALK_STEP = 1;
static const int STEP_MARGIN = 6;

void HumanCharacter::set_special_frames(const GfxFrameSet &special)
{
  /* climb 1, 2, dead 1, 2, fall */

  m_climb_frame.init(&special,this);
  m_climb_frame.set_frame_range(0,1);
  m_climb_frame.set_update_rate(100);
  m_climb_frame.set_anim_type(AnimatedSprite::FOREVER);


  m_stunned_frame.init(&special,this);
  m_stunned_frame.set_update_rate(200);
  m_stunned_frame.set_frame_range(2,3);
  m_stunned_frame.set_anim_type(AnimatedSprite::FOREVER);

  m_fall_frame.init(&special,this);
  m_fall_frame.set_frame_range(4,4);
  m_fall_frame.set_xy_render_offset(4,0);

  m_crash_frame.init(&special,this);
  m_crash_frame.set_update_rate(100);
  m_crash_frame.set_anim_type(AnimatedSprite::RUN_ONCE);
  m_crash_frame.set_frame_range(5,7);

}

void HumanCharacter::update(int elapsed_time)
{
  ENTRYPOINT(update);
  Elevator::CharacterContained cc;
  const Elevator *e = 0;

  switch (m_life_state)
    {
      case ALIVE:
	{

	  if (m_position != STATE_IN_AIR)
	    {
	      // store last position where character is not falling
	      m_y_fall = get_y();
	      m_position_before_fall = m_position;

	    }
	  update_alive(elapsed_time);
	  break;

	}
	break;
      case DYING:
	{

	  m_crash_frame.update(elapsed_time);
	  if (m_crash_frame.is_done())
	    {
	      set_life_state(DEAD);
	    }


	  m_level->get_elevator_contained_state(*this,cc,e);
	  move_character_in_elevator(e,cc);

	}
	break;
      case DEAD:
	// keep on moving the guards in the elevator if they're dead
	m_level->get_elevator_contained_state(*this,cc,e);
	move_character_in_elevator(e,cc);

	m_stunned_frame.update(elapsed_time);
	m_stunned_duration -= elapsed_time;
	break;
    }

  EXITPOINT;

}

void HumanCharacter::kill()
{
  set_life_state(DYING);
}

void HumanCharacter::play_move_sound()
{
  if ((m_life_state == ALIVE) && (m_move_type != MT_BLOCKED))
    {
      switch (m_frame_index)
	{
	  case CLIMB:
	    play_sound(m_climb_sound);
	    break;
	  case WALK:
	    play_sound(m_walk_sound);
	    break;
	  default:
	    break;
	}
    }
}

void HumanCharacter::render(Drawable &screen) const
{

  Direction d = get_direction();
  // render main sprite

  switch(m_life_state)
    {
      case ALIVE:
	switch(m_position)
	  {
	    case STATE_WALK:
	      if(m_from_cling)
		{
		  m_walk_frame.get(d).render(screen,3);
		}
	      else
		{
		  m_walk_frame.get(d).render(screen);
		}
	      break;
	    case STATE_IN_MOVING_ELEVATOR:
	      m_walk_frame.get(d).render(screen);
	      break;
	    case STATE_CLIMB:
	      m_climb_frame.render(screen);
	      break;
	    case STATE_IN_AIR:
	      if (get_y() - m_y_fall > 3)
		{
		  m_fall_frame.render(screen);
		}
	      else
		{
		  switch(m_position_before_fall)
		    {
		      case STATE_WALK:
		      case STATE_IN_MOVING_ELEVATOR:
			m_walk_frame.get(d).render(screen);
			break;
		      case STATE_CLIMB:
			m_climb_frame.render(screen);
			break;
		      default:
			break;
		    }
		}
	      break;
	    default:
	      break;
	  }
	break;
      case DYING:
	m_crash_frame.render(screen);


	break;
      case DEAD:
	{
	  // stunned or dead
	  m_stunned_frame.render(screen);
	  break;
	}
    }


}


void HumanCharacter::set_position(State pos)
{
  State previous_pos = m_position;
  bool just_switched = (previous_pos != pos);
  m_position = pos;
  switch (pos)
    {
      case STATE_CLIMB:
	{
	  if (just_switched)
	    {
	      m_climb_pos = 0;
	    }
	  align_x_on_ladder();
	}
	break;
      case STATE_IN_AIR:
	if (just_switched)
	  {
	    m_fall_timer = 0;
	  }
	break;
      case STATE_LAND:

	if (!m_fall_from_ladder && (get_y() - m_y_fall < 20))
	  {
	    // non-fatal fall
	    m_position = STATE_WALK;
	  }
	else
	  {
	    add_y(-1); // correct y
	    set_life_state(DYING);
	  }
	break;
      case STATE_WALK:
	if (just_switched)
	  {
	    if (previous_pos == STATE_CLING)
	      {
		m_from_cling = true; // last frame is fall frame (arm in the air)
	      }

	    m_walk_pos = 0;


	  }

      default:
	break;

    }

}
void HumanCharacter::set_stunned_frame_update_rate(int ur)
{
  m_stunned_frame.set_update_rate(ur);
}


void HumanCharacter::align_x_on_ladder()
{
  int new_x = m_grid->get_ladder_x(get_x(),get_y()+get_h()-1);
  if (new_x != -1)
    {
      set_x(new_x);
    }

}
void HumanCharacter::add_walk_pos(int fn, bool moves)
{
  m_walk_sequence.push_back(std::make_pair(fn,moves));
  m_actual_nb_walk_frames = (int)m_walk_sequence.size();
}
void HumanCharacter::add_climb_pos(int fn, bool moves)
{
  m_climb_sequence.push_back(std::make_pair(fn,moves));
}

inline bool HumanCharacter::can_move_laterally(int x_test) const
{
  int y_high = get_y();
  int y_low = get_y()+get_h()-STEP_MARGIN;
  int y_mid = y_low-4;
  return !m_grid->is_lateral_way_blocked(x_test,y_low) && !m_grid->is_lateral_way_blocked(x_test,y_high)
  && !m_grid->is_lateral_way_blocked(x_test,y_mid);
}
bool HumanCharacter::can_move_left() const
{
  int x_test = get_x()-1;
  bool rval = x_test > 0;
  if (rval)
    {
      rval = can_move_laterally(x_test);
    }
  return rval;
}
bool HumanCharacter::can_move_right() const
{
  int x_test = get_x()+16;   // using get_w() fails on ladders: we use 16
  bool rval = x_test < 224*3;
  if (rval)
    {
      rval = can_move_laterally(x_test);
    }
  return rval;

}

bool HumanCharacter::adapt_to_slopes(int x_test, int y_test)
{
  bool flag = true;

  int y_to_add = 0;
  // test y_test-1 => y_test-1-STEP_MARGIN (handle non right-angle turns & slopes)
  for (int i = 0; i < STEP_MARGIN; i++)
    {
      y_test--;
      // check if rising slope
      flag = (m_grid->is_lateral_way_blocked(x_test,y_test));
      if (!flag)
	{
	  add_y(y_to_add);


	  break;
	}
      else
	{
	  y_to_add--;
	}

    }

  return flag;
}

HumanCharacter::MoveType HumanCharacter::try_to_move_left()
{
  MoveType rval = MT_BLOCKED;

  set_direction(LEFT);

  int delta_x = get_walk_dx();

  int x_test = get_x() - delta_x;
  int x_limit = 0;

  if (x_test > x_limit)
    {
      int y_test = get_y()+get_h()-1;

      bool flag = adapt_to_slopes(x_test,y_test);
      if (!flag)
	{
	  set_position(STATE_WALK);

	  // fall if declining slope
	  if (!m_grid->is_vertical_way_blocked(x_test-delta_x,y_test+1) &&
	      !m_grid->is_vertical_way_blocked(x_test+get_w(),y_test+1) &&
	      m_grid->is_vertical_way_blocked(x_test+get_w(),y_test+2))
	    {
	      add_y(1);
	    }
	  if (lateral_move(-delta_x))
	    {
	      rval = MT_ADVANCE_FRAME;
	    }
	  else
	    {
	      rval = MT_WAIT_FRAME;
	    }
	}
    }
  if (rval == MT_ADVANCE_FRAME)
    {
      advance_walk_pos();
    }
  return rval;
}

HumanCharacter::MoveType HumanCharacter::try_to_move_right()
{
  MoveType rval = MT_BLOCKED;

  set_direction(RIGHT);

  int delta_x = get_walk_dx();

  if (m_level_end)
    {
      if (lateral_move(delta_x))
	{
	  rval = MT_ADVANCE_FRAME;
	}
      else
	{
	  rval = MT_WAIT_FRAME;
	}
      set_position(STATE_WALK);
    }
  else
    {
      int x_test = (int)(get_x() + get_w() + delta_x);
      if (get_x()+0x10 < m_grid->get_w())
	{
	  int y_test = get_y()+get_h();
	  bool flag = adapt_to_slopes(x_test,y_test);

	  if (!flag)
	    {
	      if (lateral_move(delta_x))
		{
		  rval = MT_ADVANCE_FRAME;
		}
	      else
		{
		  rval = MT_WAIT_FRAME;
		}

	      set_position(STATE_WALK);
	      // check if falling slope
	      if (!m_grid->is_vertical_way_blocked(x_test,y_test+1) &&
		  !m_grid->is_vertical_way_blocked(get_x(),y_test+1) &&
		  m_grid->is_vertical_way_blocked(get_x(),y_test+2))

		{
		  add_y(1);
		}
	    }

	}
    }
  if (rval == MT_ADVANCE_FRAME)
    {
      advance_walk_pos();
    }

  return rval;
}
void HumanCharacter::on_die()
{

}

bool HumanCharacter::can_climb_down() const
{
  int y_test = get_y()+get_h();
  int x4 = get_x()+4;
  return m_grid->can_climb_down(x4,y_test) && m_grid->can_climb_down(x4+3,y_test);
}
bool HumanCharacter::can_climb_up() const
{
  int y_test = get_y()+get_h()/2-1;
  int x4 = get_x()+4;
  return m_grid->can_climb_up(x4,y_test) && m_grid->can_climb_up(x4+3,y_test);
}

inline bool HumanCharacter::vertical_move(int delta_y)
{
  int mms = get_max_move_skip();
  m_move_skip++;
  bool rval = m_move_skip != mms;
  if (rval)
    {
      add_y(delta_y);
    }
  if (m_move_skip > mms)
    {
      m_move_skip = 0;
    }
  return rval;
}

inline bool HumanCharacter::lateral_move(int delta_x)
{
  int mms = get_max_move_skip();
  m_move_skip++;
  bool rval = m_move_skip != mms;
  if (rval)
    {
      add_x(delta_x);
    }
  if (m_move_skip > mms)
    {
      m_move_skip = 0;
    }
  return rval;
}

HumanCharacter::MoveType HumanCharacter::try_to_move_up()
{
  MoveType rval = MT_BLOCKED;

  int delta_y = get_climb_dy();

  bool flag = can_climb_up();
  if (flag)
    {
      set_position(STATE_CLIMB);

      if (vertical_move(-delta_y))
	{
	  rval = MT_ADVANCE_FRAME;
	}
      else
	{
	  rval = MT_WAIT_FRAME;
	}
    }
  if (rval == MT_ADVANCE_FRAME)
    {
      advance_climb_pos();
    }
  return rval;
}
HumanCharacter::MoveType HumanCharacter::try_to_move_down()
{
  MoveType rval = MT_BLOCKED;

  int delta_y = get_climb_dy();

  bool flag = can_climb_down();
  if (flag)
    {
      set_position(STATE_CLIMB);

      if (vertical_move(delta_y))
	{
	  rval = MT_ADVANCE_FRAME;
	}
      else
	{
	  rval = MT_WAIT_FRAME;
	}

    }
  if (rval == MT_ADVANCE_FRAME)
    {
      advance_climb_pos();
    }
  return rval;
}

inline int HumanCharacter::get_walk_dx() const
{

  const MovePos &mp = m_walk_sequence[m_walk_pos];

  return mp.second ? 1 : 0;
}
inline int HumanCharacter::get_climb_dy() const
{

  const MovePos &mp = m_climb_sequence[m_climb_pos];

  return mp.second ? 1 : 0;
}

inline void HumanCharacter::advance_walk_pos()
{
  m_from_cling = false;
  m_walk_pos++;
  if (m_walk_pos == m_actual_nb_walk_frames)
    {
      m_walk_pos = 0;
    }
  m_walk_frame.set_current_frame(m_walk_sequence[m_walk_pos].first);


}
inline void HumanCharacter::advance_climb_pos()
{
  m_climb_pos++;

  if (m_climb_pos == (int)m_climb_sequence.size())
    {
      m_climb_pos = 0;
    }
  m_climb_frame.set_current_frame(m_climb_sequence[m_climb_pos].first);


}

int HumanCharacter::get_max_move_skip() const
{
  return 0;
}

void HumanCharacter::init(MPLevel *level)
{
  Character::init(level);
}
HumanCharacter::FullDirection HumanCharacter::get_opposite_direction(FullDirection d) const
{
  FullDirection rval = FD_UP;
  switch (d)
    {
      case FD_LEFT:
	rval = FD_RIGHT;
	break;
      case FD_RIGHT:
	rval = FD_LEFT;
	break;
      case FD_UP:
	rval = FD_DOWN;
	break;
      default:
	break;
    }
  return rval;
}

void HumanCharacter::level_init(int arcade_x, int y,int current_screen)
{
  Locatable start_location;
  start_location.set_xy(arcade_x+224*current_screen,y);

  Character::level_init(start_location);

  m_stunned_duration = 5000;


  m_move_type = MT_BLOCKED;
  m_frame_index = WALK;

  m_crash_frame.first();
  m_walk_frame.first();
  m_fall_frame.first();

  m_walk_pos = 0;
  m_climb_pos = 0;
  m_move_skip = 0;

  m_walk_timer = 0;
  m_fall_timer = 0;
  m_update_rate = 100/6;

  set_position(STATE_WALK);
  m_y_fall = get_y();
  m_position_before_fall = m_position;

  m_fall_from_ladder = false;
  set_life_state(ALIVE);

  m_level_end = false;
  m_from_cling = false;

}


void HumanCharacter::handle_gravity(int elapsed_time)
{
  Elevator::CharacterContained cc;
  const Elevator *e = 0;

  m_level->get_elevator_contained_state(*this,cc,e);

  if (cc == Elevator::CC_KILL)
    {
      kill(); // only for player
    }
  else
    {

      bool mf = cc != Elevator::CC_IN && cc != Elevator::CC_CROSS;
      if (mf)
	{
	  // not in elevator or not the same screen as player: perform fall test
	  mf = may_fall();
	}
      if (mf)
	{
	  // allow 1 pixel
	  add_y(1);
	  if (may_fall())
	    {
	      add_y(-1);
	      set_position(STATE_IN_AIR);
	    }
	  if (m_position == STATE_IN_AIR)
	    {
	      apply_gravity(elapsed_time);
	    }
	}
      else
	{
	  if (m_position == STATE_IN_AIR)
	    {
	      set_position(STATE_LAND);
	    }
	  else
	    {
	      move_character_in_elevator(e,cc);
	    }
	}
    }
}


void HumanCharacter::move_character_in_elevator(const Elevator *e, Elevator::CharacterContained cc)
{
  bool follow_elevator = cc == Elevator::CC_IN;

  if (!follow_elevator && cc == Elevator::CC_CROSS &&
      ((std::abs(get_x() - e->get_x()) < 6) ||
       e->get_move_state() != Elevator::STATE_GOING_DOWN))
    {
      // follow elevator if going up and roughly in the elevator
      // don't follow when going down
      follow_elevator = true;
    }
  if (follow_elevator)
    {
      set_y(e->get_y()-1);

      if (e->get_move_state() != Elevator::STATE_FLOOR)
	{
	  set_position(STATE_IN_MOVING_ELEVATOR);
	}
      else
	{
	  if (m_position != STATE_IN_WAGON)
	    {
	      set_position(STATE_WALK);
	    }
	}
    }
}
void HumanCharacter::apply_gravity(int elapsed_time)
{
  m_fall_timer += elapsed_time;
  while(m_fall_timer > 75/6)
    {
      m_fall_timer -= 75/6;
      add_y(1);
    }
}



void HumanCharacter::align_y_on_grid()
{
  set_y(m_grid->get_rounded_y(get_y(),false));
}
void HumanCharacter::set_walk_frames(const GfxPalette::LeftRight &f)
{
  m_walk_frame.set(&f.left,&f.right,this);
  // force width & height values to the ones of the player
  // (works well that way, no need to make it more generic (i.e. complex))
  set_w(14);//m_walk_frame.get(RIGHT).get_w());
  set_h(16);
  /*

      set_h(m_walk_frame.get(RIGHT).get_h());*/

}

HumanCharacter::~HumanCharacter()
{

}

int HumanCharacter::get_x_boundary(int x, int margin) const
{
  int boundary_x = (get_direction() == RIGHT) ?
  (x + get_w() + margin) : x - margin;

  return boundary_x;
}

HumanCharacter::HumanCharacter(SoundSet::SoundId walk_sound,
			       SoundSet::SoundId climb_sound
) :  Character(), m_stunned_duration(0),m_life_state(ALIVE)
{
  m_walk_sound = walk_sound;
  m_climb_sound = climb_sound;

}


bool HumanCharacter::may_fall() const
{
  bool rval = m_position != STATE_IN_WAGON;

  if (rval)
    {
      rval = false;

      int y_test = get_y() + get_h();

      int bound_left = get_x();
      int bound_right = get_x() + 12;

      if (m_fall_from_ladder)
	{
	  rval = !m_grid->is_lateral_way_blocked(bound_left , y_test)
	  && !m_grid->is_lateral_way_blocked(bound_right , y_test);

	}
      else
	{
	  rval = !m_grid->is_vertical_way_blocked(bound_left , y_test)
	  && !m_grid->is_vertical_way_blocked(bound_right , y_test);
	}
    }

  return rval;
}

void HumanCharacter::fall_from_ladder()
{
  m_fall_from_ladder = true;
}


void HumanCharacter::set_life_state(LifeState ls)
{
  m_life_state = ls;
  if (ls == ALIVE)
    {
      m_stunned_duration = 0;
    }
  else if (ls == DEAD)
    {
      m_fall_from_ladder = false;
      on_die();
    }
}


