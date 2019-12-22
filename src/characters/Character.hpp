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
#ifndef CHARACTER_H_INCLUDED
#define CHARACTER_H_INCLUDED

#include "AnimatedSprite.hpp"
#include "SoundSet.hpp"
#include "Renderable.hpp"
#include "FrameCouple.hpp"
#include "GfxPalette.hpp"

class MPLevel;
class GfxObject;
class TileGrid;
class Player;

class Character : public Renderable
{
public:
    virtual ~Character();

    void stand_by()
    {
        m_stand_by = true;
    }
    inline bool is_stand_by() const
    {
        return m_stand_by;
    }
    // slightly different from get_current_screen(): returns true also if partially on the screen
    bool is_in_screen(int screen) const;

    Direction get_direction() const
    {
        return m_direction;
    }
    Character();

    inline int get_direction_sign() const
    {
        return m_direction == RIGHT ? 1 : -1;
    }

    virtual void update(int elapsed_time) = 0;

    inline MPLevel *get_level()
    {
        return m_level;
    }
    inline const MPLevel *get_level() const
    {
        return m_level;
    }
    virtual bool may_fall() const = 0;


    bool collides(const Locatable &p) const;

    bool collides_player() const;

protected:
    void init(MPLevel *level);

    void level_init(const Locatable &start_location);

    void stop_sound(int shnd);

    int play_sound(SoundSet::SoundId sid);
    int play_random_sound(SoundSet::SoundId sid, int nb_sounds);

    void set_direction(Direction d);

    void reverse_direction();
    void align_y_on_grid();


    MPLevel *m_level;
    const TileGrid *m_grid;
    Player *m_player;

    Direction m_direction;
private:
    bool m_stand_by;
};

#endif // CHARACTER_H_INCLUDED
