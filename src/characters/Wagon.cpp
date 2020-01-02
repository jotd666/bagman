/*
    Copyright (C) 2010 JOTD

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include "Wagon.hpp"
#include "Player.hpp"
#include "MPLevel.hpp"
#include "MPDomain.hpp"

void Wagon::init(MPLevel *level,int min_screen_x,int max_screen_x,int min_screen,int max_screen,Direction d)
{
  m_start_direction = d;
  m_min_x = min_screen_x+min_screen*224;
  m_max_x = max_screen_x+max_screen*224;
  m_min_screen = min_screen;
  m_max_screen = max_screen;

  Character::init(level);
  const GfxFrameSet *gfs = &level->get_palette().wagon;
  m_sprite.init(gfs,this);

  set_w(16);
  set_h(8);

}
void Wagon::level_init(int arcade_x,int start_y,int start_screen)
{
  m_sprite.first();

  m_move_timer = 0;
  Locatable start_location;
  start_location.set_xy(arcade_x+224*start_screen,start_y);

  Character::level_init(start_location);

  set_direction(m_start_direction);

}

void Wagon::empty()
{
  m_sprite.set_current_frame(0); // picture of the wagon not containing the player

}

void Wagon::update(int elapsed_time)
{
  if (collides_player())
    {
      switch (m_player->get_state())
	{
	  case HumanCharacter::STATE_CLIMB:
	    // only kills if too low
	    {
	      int delta_y = get_y()-m_player->get_y();

	      if (delta_y<8)
		{
		  if (!m_level->get_domain().invincible)
		    {
		      m_player->kill();
		    }
		}
	    }
	    break;
	  case HumanCharacter::STATE_CLING:
	    // do nothing
	    break;
	  case HumanCharacter::STATE_IN_WAGON:
	    {
	      m_sprite.set_current_frame(1); // picture of the wagon containing the player
	      // move player with the wagon
	      m_player->set_x(get_x());

	      break;
	    }
	  default:
	    {
	      m_sprite.first();  // picture of an empty wagon
	      if (!m_level->get_domain().invincible)
		{
		  m_player->kill();
		}
	    }
	}
    }
  else
    {
      m_sprite.first();  // picture of an empty wagon
    }

  if (m_player->get_life_state() == HumanCharacter::DYING)
    {
      m_sprite.first();  // picture of an empty wagon
    }

  m_move_timer += elapsed_time;
  while (m_move_timer > 16)
    {
      m_move_timer -= 16;
      switch(get_direction())
	{
	  case LEFT:
	    // check lower bounds
	    if (get_x() <= m_min_x)
	      {
		set_direction(RIGHT);
	      }
	    else
	      {
		add_x(-1);
	      }


	    break;
	  case RIGHT:

	    // check upper bounds
	    if (get_x() >= m_max_x)
	      {
		set_direction(LEFT);
	      }
	    else
	      {
		add_x(1);
	      }


	    break;

	}

    }
}
void Wagon::render(Drawable &d) const
{
  m_sprite.render(d);
}
bool Wagon::may_fall() const
{
  return false;
}
