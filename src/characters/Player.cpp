#include "Player.hpp"
#include "GfxFrameSet.hpp"
#include "MPLevel.hpp"
#include "Fonts.hpp"
#include "SoundSet.hpp"

#include "RandomNumber.hpp"
#include "Elevator.hpp"
#include "Guard.hpp"
#include "MPDomain.hpp"

static const int WALK_STEP = 1;




Player::~Player()
{

}

void Player::new_game()
{
  m_score = 0;
  m_lives = 2;
  m_item_held = 0;
  m_extra_life_awarded = false;
  m_extra_life_score = m_level->get_domain().get_menu_options().get_extra_life_score();
}

void Player::init(MPLevel *level)
{
  Character::init(level);
  const GfxPalette &p = level->get_palette();
  set_walk_frames(p.player);
  set_special_frames(p.player_special);
  m_cling_frames.init(&p.player_special,this);
  m_cling_frames.set_frame_range(8,9);
  m_cling_frames.set_update_rate(50);

  add_walk_pos(0,false); // 1: don't move
  add_walk_pos(0,true);
  add_walk_pos(1,false); // 3: don't move
  add_walk_pos(1,true);
  add_walk_pos(1,true);
  add_walk_pos(1,true);
  add_walk_pos(1,false); // 7: don't move
  add_walk_pos(2,true);
  add_walk_pos(2,true);
  add_walk_pos(2,true);
  add_walk_pos(2,true);



  add_climb_pos(0,false);
  add_climb_pos(0,true);
  add_climb_pos(0,true);
  add_climb_pos(0,true);
  add_climb_pos(0,false);
  add_climb_pos(1,true);
  add_climb_pos(1,true);
  add_climb_pos(1,true);
  add_climb_pos(1,true);
  add_climb_pos(1,false);
  add_climb_pos(1,true);

  new_game();
}

int Player::get_max_move_skip() const
{
  int rval = 0;
  if (owns(GfxObject::YELLOW_BAG))
    {
      rval=2;
    }
  else if (owns(GfxObject::BLUE_BAG))
    {
      rval = 1;
    }
  return rval;
}

void Player::level_init(int x_arcade, int y, int current_screen, FullDirection d)
{

  HumanCharacter::level_init(x_arcade,y,current_screen);
  m_barrow = const_cast<const MPLevel *>(m_level)->get_barrow();

  set_direction(d == FD_LEFT ? LEFT : RIGHT);

  m_pick_index = 0;

  m_pick_timer = 0;
  m_walk_timer = 0;

  LOGGED_DELETE(m_item_held);

  m_allow_pick = true;

  set_position(STATE_WALK);


  set_life_state(ALIVE);


}

void Player::set_held_item(GfxObject *o)
{
  release_held_item();
  m_item_held = o;

}
/*
   void Player::collision(Hostile &nasty)
   {
    if (has_pick())
    {
	nasty.killed_by_player();
    }
    else
    {

		hurt();

    }
   }

   bool Player::hurt(bool instant_death)
   {
    bool rval = false;
    if (instant_death)
    {
	m_die = true; // only for debug purposes
    }

    // invincible when stunned
    if (!is_stunned() && m_position != STATE_SLIDE)
    {
	rval = true;

	if (m_position == STATE_WALK)
	{
	    set_position(STATE_SLIDE);

	    // if player was inflating a pocket, remove it
	    init_pocket();
	}
	else
	{
	    if (m_power_up.nb_lives > 0)
	    {
		set_stunned();
	    }
	}

	if (m_power_up.nb_lives > 0)
	{
	    m_power_up.nb_lives--;
	}
	else
	{
	    m_die = true;
	    set_position(STATE_SLIDE);
	}
    }

    return rval;
   }
 */

bool Player::owns(GfxObject::Type t) const
{
  return (m_item_held != 0) && (m_item_held->get_type() == t);
}

Player::MoveType Player::handle_up_down(const PlayerControls::Status &input)
{
  MoveType rval = MT_BLOCKED;
  if (!owns(GfxObject::BARROW))
    {
      if (input.up.is_pressed())
	{
	  rval = try_to_move_up();
	}
      else if (input.down.is_pressed())
	{
	  rval = try_to_move_down();
	}

      m_move_type = rval;
      m_frame_index = CLIMB;


    }
  return rval;
}

HumanCharacter::MoveType Player::handle_left_right(const PlayerControls::Status &input)
{
  MoveType rval = MT_BLOCKED;
  Direction d = m_direction;

  if (input.left.is_pressed())
    {
      rval = try_to_move_left();
    }
  else if (input.right.is_pressed())
    {
      rval = try_to_move_right();
    }

  m_move_type = rval;
  m_frame_index = WALK;

  bool direction_change = m_direction != d;
  if (direction_change)
    {
      m_allow_pick = true;
    }
  if (owns(GfxObject::PICK) && (m_direction == LEFT))
    {
      if (m_grid->get_point_type(get_x()-10+m_level->get_nb_pick_blows(),get_y()+4) == TileGrid::PT_BREAKABLE_WALL)
	{
	  if (m_allow_pick)
	    {
	      m_allow_pick = false;
	      m_level->break_wall();
	    }
	}
    }


  return rval;
}

int Player::get_held_bag_value() const
{
  int rval = 0;
  if (m_item_held != 0)
    {
      switch (m_item_held->get_type())
	{
	  case GfxObject::YELLOW_BAG:
	    rval = 1;
	    break;
	  case GfxObject::BLUE_BAG:
	    rval = 2;
	    break;
	  default:
	    break;
	}
    }
  return rval;
}



void Player::handle_climb(int elapsed_time, const PlayerControls::Status &input)
{

  m_walk_timer += elapsed_time;

  while (m_walk_timer > m_update_rate)
    {
      m_walk_timer -= m_update_rate;
      bool lateral_move = false;

      if (input.left.is_pressed())
	{
	  if (can_move_left())
	    {
	      lateral_move = try_to_move_left();

	    }
	}
      else if (input.right.is_pressed())
	{
	  if (can_move_right())
	    {
	      lateral_move = try_to_move_right();
	    }
	}

      if (!lateral_move)
	{
	  // perform a step

	  MoveType mt = handle_up_down(input);


	  m_move_type = mt;
	  m_frame_index = CLIMB;

	}
    }
}

void Player::play_pick_sound()
{
  if (owns(GfxObject::PICK) && (m_position != STATE_CLING) && (m_move_type != MT_BLOCKED) && m_frame_index == WALK)
    {
      play_sound(SoundSet::pickaxe);
    }
}
void Player::handle_walk(int elapsed_time, const PlayerControls::Status &input)
{
  m_walk_timer += elapsed_time;

  while (m_walk_timer > m_update_rate)
    {
      State old_position = m_position;

      m_walk_timer -= m_update_rate;

      // perform a step

      MoveType mt = handle_left_right(input);

      m_move_type = mt;

      if (mt != MT_BLOCKED)
	{
	  m_frame_index = WALK;

	  //debug("PX = %d, Y = %d",get_x(),get_y());
	  m_pick_timer += elapsed_time;
	  while (m_pick_timer > m_update_rate*5)
	    {
	      RandomNumber::randomize();   // randomize for guard movements

	      m_pick_index++;
	      if (m_pick_index == 4)
		{
		  m_pick_index = 0;
		}
	      m_pick_timer -= m_update_rate*5;

	    }

	  if (mt == MT_ADVANCE_FRAME && m_walk_pos == 0)
	    {
	      add_score(10);
	    }

	  if (old_position == STATE_IN_WAGON)
	    {
	      // add offset to avoid being hit by wagon immediately
	      add_x(get_direction_sign()*16);
	    }
	}
      else
	{
	  if (input.up.is_pressed())
	    {
	      // check if there's a ladder
	      if (can_climb_up() && !owns(GfxObject::BARROW))
		{
		  if (m_position == STATE_IN_WAGON)
		    {
		      // add offset to avoid being hit by wagon immediately
		      add_y(-8);
		    }
		  set_position(STATE_CLIMB);
		}
	    }
	  if (input.down.is_pressed())
	    {
	      // check if there's a ladder
	      if (can_climb_down() && !owns(GfxObject::BARROW))
		{
		  if (m_position == STATE_IN_WAGON)
		    {
		      // add offset to avoid being hit by wagon immediately
		      add_y(12);
		    }

		  set_position(STATE_CLIMB);
		}
	    }

	}

    }





}

void Player::align_item(GfxObject *ob)
{
  // align items when releasing them.
  // original game uses sprites for player and bag when player is carrying it
  // but when released, the bag/other items are tiles and therefore are aligned
  // in the grid. We respect that, and moreover it is essential to slope management

  if (m_position != STATE_IN_MOVING_ELEVATOR && m_position != STATE_CLIMB)
    {
      int x_offset = ob->get_x_offset();

      // release when walking/in wagon

      int x_low = x_offset+(get_x() & 0xFFF8); // align on 8
      int x_high = x_low+8;
      int preferred_x = x_low;

      switch(get_direction())
	{
	  case LEFT:
	    if (m_grid->is_vertical_way_blocked(x_low,get_y()))
	      {
		preferred_x = x_high;
	      }
	    break;
	  case RIGHT:
	    if (!m_grid->is_vertical_way_blocked(x_high+16,get_y()))
	      {
		preferred_x = x_high;
	      }

	    break;
	}

      ob->set_x(preferred_x);
      ob->add_y(-1);          // lift it slightly from the ground so the slope detection works

    }

}

void Player::release_held_item()
{
  if (m_item_held != 0)
    {
      GfxObject *ie = m_item_held;

      m_item_held = 0;      // set to 0 because on level end recursion effect

      ie->set_location(*this);
      switch (ie->get_type())
	{
	  case GfxObject::BARROW:
	    {
	      m_level->insert_object(ie);
	      ie->add_x(16);
	      while (!m_grid->is_lateral_way_blocked(ie->get_x(),get_y()+get_h()))
		{
		  // shift barrow until solid ground found
		  ie->add_x(1);
		}
	    }
	    break;
	  case GfxObject::BLUE_BAG:
	  case GfxObject::YELLOW_BAG:
	    {

	      // special behaviour if barrow
	      auto &barrow_bounds = m_barrow->get_bounds();
	      auto &bag_bounds = ie->get_bounds();

	      if (barrow_bounds.intersects(bag_bounds))
		{
		  m_level->bag_in_barrow(ie->get_type() == GfxObject::BLUE_BAG);
		}
	      else
		{
		  // drop the bag
		  align_item(ie);
		  m_level->insert_object(ie);
		}
	    }

	    break;
	  default:  // pickaxe


	    align_item(ie);
	    ie->add_y(1); // makeup -1 sub for slope test, not to be done for pick
	    m_level->insert_object(ie);

	    break;
	}
    }

}


void Player::add_score(int sc)
{

  m_score += sc;

  if (!m_extra_life_awarded && m_score > m_extra_life_score)
    {
      // extra life
      m_extra_life_awarded = true;
      m_lives++;
    }
}

void Player::handle_release()
{
  m_cling_frames.set_anim_type(AnimatedSprite::REVERSE);

  if (m_level->is_wagon_below_player())
    {
      // drop in wagon
      set_position(STATE_IN_WAGON);
      add_score(100);
      play_sound(SoundSet::ethopla);
    }
}
void Player::handle_cling()
{
  bool to_right = get_direction()==RIGHT;
  bool cling = false;

  if (to_right)
    {
      if (m_grid->is_below_handle(get_x()+12,get_y()))
	{
	  cling = true;
	}
      // be extra nice when character is not exactly below handle
      else if (m_grid->is_below_handle(get_x()+4,get_y()))
	{
	  cling = true;
	  add_x(-8);
	}
    }
  else
    {
      if (m_grid->is_below_handle(get_x()+get_w()-12,get_y()))
	{
	  cling = true;
	  add_x(-get_w()/2);

	}
      // be extra nice when character is not exactly below handle
      else if (m_grid->is_below_handle(get_x()+get_w()-4,get_y()))
	{
	  cling = true;
	  add_x(-get_w()/2+4); // align on handle
	}
    }




  if (cling)
    {
      // cling to handle
      m_cling_frames.set_anim_type(AnimatedSprite::RUN_ONCE);
      m_pick_index = 0;
      set_position(STATE_CLING);
      set_direction(RIGHT);
      play_sound(SoundSet::hohisse);

    }
}

void Player::render(Drawable &d) const
{
  if (get_life_state() == ALIVE)
    {
      switch(m_position)
	{
	  case STATE_CLING:
	    m_cling_frames.render(d);
	    break;
	  default:
	    HumanCharacter::render(d);
	    break;
	}
      if (m_item_held != 0)
	{
	  const GfxPalette &p = m_level->get_palette();
	  GfxObject::Type t = m_item_held->get_type();
	  switch (t)
	    {
	      case GfxObject::YELLOW_BAG:
	      case GfxObject::BLUE_BAG:
		{


		  const GfxFrameSet &b = t == GfxObject::YELLOW_BAG ? p.yellow_bag : p.blue_bag;
		  Direction di = get_direction(); // climbing: always on right

		  int by = get_y()+5;
		  int bx = get_x();
		  if (m_position == STATE_CLIMB)
		    {
		      di = LEFT;
		      bx += 6;
		    }
		  else if ((m_position == STATE_WALK) && (get_direction() == LEFT))
		    {
		      bx += 4;
		    }
		  else if (m_position == STATE_IN_AIR)
		    {
		      di = RIGHT;
		    }

		  const GfxFrame &bf = b.get_frame(2-di);
		  bf.to_image().render(d,bx,by);
		  break;
		}
	      case GfxObject::PICK:
		if (m_position == STATE_CLIMB)
		  {


		    p.held_pickaxe.left.get_frame(1).render(d,get_x(),get_y());
		  }
		else
		  {
		    if (m_direction == LEFT)
		      {
			p.held_pickaxe.left.get_frame(m_pick_index/2).render(d,get_x()-8,get_y());
		      }
		    else
		      {
			p.held_pickaxe.right.get_frame(m_pick_index/2).render(d,get_x()+12,get_y());
		      }


		  }
		break;
	      case GfxObject::BARROW:
		p.barrow.get_frame(1).render(d,get_x()+get_w(),get_y());

		break;
	    }
	}
    }
  else
    {
      HumanCharacter::render(d);
    }
}
bool Player::can_barrow_be_released() const
{
  int x = get_x();
  int y_test = get_y()+get_h();
  if  (m_level->get_pickable_item()==nullptr &&
       m_grid->is_lateral_way_blocked(x+26,y_test) &&
       m_grid->is_lateral_way_blocked(x+20,y_test)) // not too strict...
    {
      // cannot release barrow near screen limits
      // (like the original game: reason could lose the barrow)

      int x_release = (x-16) % 224;
      if (x_release < 224-32)
	{

	  // release the item (but check before to avoid releasing the barrow
	  // that the barrow is not just above a ladder or a gap
	  return true;
	}
    }
  return false;
}



void Player::handle_pickups(const PlayerControls::Status &input)
{

  if (input.fire.is_first_pressed())
    {
      if (m_item_held == 0)
	{

	  // check if an object can be picked up

	  GfxObject *item = m_level->get_pickable_item();

	  if (item != 0)
	    {
	      m_level->pick_up_object(item);
	    }
	  m_pick_life = 0;  // reset pickaxe lifetime
	}
      else
	{

	  switch (m_item_held->get_type())
	    {
	      case GfxObject::BARROW:
		// check floor: cannot release barrow over the elevator
		// or over a bag or pick
		if (can_barrow_be_released())
		  {
		    release_held_item();
		  }
		break;

	      case  GfxObject::PICK:
		{
		  int y_test = get_y()+get_h();

		  m_item_held->set_location(*this);
		  // modify coords so slope test has a chance to work
		  align_item(m_item_held);
		  if (!m_item_held->is_on_slope() && m_grid->is_lateral_way_blocked(m_item_held->get_x(),y_test) &&
		      m_grid->is_lateral_way_blocked(m_item_held->get_x()+8,y_test))
		    {
		      // do not release if barrow either
		      auto &barrow_bounds = m_barrow->get_bounds();
		      auto &other_bounds = m_item_held->get_bounds();

		      if (not barrow_bounds.intersects(other_bounds))
			{

			  release_held_item();
			}
		    }

		}
		break;
	      default:
		// bags
		release_held_item();
		break;

	    }
	}

    }
}
void Player::remove_held_item()
{
  LOGGED_DELETE(m_item_held);
}
void Player::handle_weapons()
{
  if (m_position == STATE_WALK || m_position == STATE_IN_WAGON)
    {
      bool owns_barrow = owns(GfxObject::BARROW);
      bool owns_pick = !owns_barrow && owns(GfxObject::PICK); // optim: if owns barrow cannot own pick => skip owns() call
      if (owns_barrow || owns_pick)
	{
	  int weapon_w = 16;

	  PointerVector<Guard,true> &guard_list = m_level->get_guards();
	  PointerVector<Guard,true>::iterator it;
	  SDLRectangle weapon_bounds(get_bounds());

	  if (owns_barrow || get_direction() == RIGHT)
	    {
	      weapon_bounds.x += get_w();
	    }
	  else
	    {
	      weapon_bounds.x -= weapon_w;
	    }
	  // increase barrow bounds so guard is killed on the ladder even if slightly misaligned
	  // (but we have to perform one more check on x to avoid that player kills guard when too
	  // much disaligned in x)

	  weapon_bounds.h += 1;


	  FOREACH(it,guard_list)
	  {
	    Guard *g = *it;
	    if ((g->get_life_state() == ALIVE) && (g->get_bounds().intersects(weapon_bounds)))
	      {
		int dy = g->get_y() - (get_y()+get_h());

		// check if guard is below
		if ((g->get_state() == HumanCharacter::STATE_CLIMB) && (dy < 2))
		  {
		    if (std::abs(g->get_x() - weapon_bounds.x) < 6)  // x align extra check
		      {
			g->fall_from_ladder();
		      }
		    // else guard eventually kills the player
		  }
		else
		  {
		    if (owns_pick)
		      {
			g->kill();
			add_score(500);
			remove_held_item();
			break;   // don't kill both guards if they are superposed
		      }
		  }
	      }
	  }
	}
    }
}
void Player::update_alive(int elapsed_time)
{
  const PlayerControls::Status &input = m_level->get_player_input();

  if (owns(GfxObject::PICK))
    {
      m_pick_life += elapsed_time;
      if (m_pick_life > 8000)    // roughly 8 seconds
	{
	  LOGGED_DELETE(m_item_held);
	}
    }

  if (m_level_end)
    {
      handle_walk(elapsed_time,input);
    }
  else
    {
      handle_gravity(elapsed_time);
      handle_weapons();

      bool fire_pressed = (input.fire.is_first_pressed());

      switch (m_position)
	{
	  case STATE_IN_WAGON:
	    m_pick_index = 0;
	    handle_walk(elapsed_time,input);

	    handle_pickups(input);

	    break;
	  case STATE_WALK:


	    if (fire_pressed)
	      {
		handle_cling();
	      }

	    if (m_position == STATE_WALK)
	      {
		// only handle pickups if no state change (cling)
		handle_pickups(input);
		handle_walk(elapsed_time,input);
	      }

	    break;
	  case STATE_CLIMB:
	    handle_climb(elapsed_time, input);
	    handle_pickups(input); // can only drop items

	    break;
	  case STATE_CLING:
	    if (fire_pressed)
	      {
		handle_release();
	      }


	    if (m_cling_frames.is_done())
	      {
		if (m_cling_frames.get_anim_type() == AnimatedSprite::REVERSE)
		  {
		    set_position(STATE_WALK);
		  }
	      }
	    else
	      {
		m_cling_frames.update(elapsed_time);
	      }
	    break;

	  case STATE_IN_AIR:
	  case STATE_IN_MOVING_ELEVATOR:
	    if (owns(GfxObject::BARROW))
	      {
		m_item_held->set_y(24); // avoid y problems
		// release barrow
		release_held_item();
	      }
	    break;
	  default:
	    break;
	}
    }
}

void Player::set_level_end()
{
  m_level_end = true;
  m_lives++;
  m_level->pick_up_object(m_level->get_barrow());
}
void Player::on_die()
{
  m_level->empty_wagons();

  m_lives--;
  stop_music();
  play_sound(SoundSet::player_killed);
  GfxObject *go=nullptr;
  if (owns(GfxObject::BARROW))
    {
      if (not can_barrow_be_released())
	{
	  go = m_item_held;
	}
    }
  // release it anyway
  release_held_item();
  if (go)
    {
      // but reset to valid position if it wasn't
      go->set_x(112+16 + 224 * get_current_screen());
    }

}


/* update method */
/***********************************************************/




Player::Player() : HumanCharacter(SoundSet::player_step,SoundSet::player_climb)
{

}





