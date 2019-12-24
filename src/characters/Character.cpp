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
#include "Character.hpp"
#include "MPLevel.hpp"
#include "TileGrid.hpp"
#include "Player.hpp"


Character::~Character()
{
}
Character::Character() : m_level(0), m_direction(RIGHT), m_stand_by(false)
{


}


bool Character::collides_player() const
{
  const Player *p = m_level->get_player();
  return collides(*p);
}
bool Character::collides(const Locatable &p) const
{
  SDLRectangle ob = p.get_bounds();
  //SDLRectangle tb = get_bounds();
  // make detection nicer
  ob.w -= 4;
  ob.x += 2;
  ob.y += 3;
  ob.h -= 6;

  return (ob.intersects(get_bounds()));
}

void Character::init(MPLevel *level)
{
  m_level = level;
  m_player = level->get_player();
  m_grid = &(m_level->get_grid());

}

void Character::level_init(const Locatable &start_location)
{

  set_location(start_location);
  m_stand_by = false;

}

int Character::play_sound(SoundSet::SoundId sid)
{
  return m_level->get_sound_set().play(sid);
}

void Character::stop_sound(int shnd)
{
  m_level->get_sound_set().stop(shnd);
}

int Character::play_random_sound(SoundSet::SoundId sid, int nb_sounds)
{
  return m_level->get_sound_set().play_random(sid,nb_sounds);
}


void Character::set_direction(Direction d)
{
  m_direction = d;
}
void Character::reverse_direction()
{
  m_direction = (m_direction == RIGHT) ? LEFT : RIGHT;
}

