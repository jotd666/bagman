#ifndef ELEVATOR_H_INCLUDED
#define ELEVATOR_H_INCLUDED

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
#include "MyVector.hpp"

class Elevator : public Character
{
public:
    DEF_GET_STRING_TYPE(Elevator);
    void init(MPLevel *level,const GfxFrameSet *gfs,int min_y,int max_y,
              const MyVector<int> &stops,bool up_stops,bool down_stops);
    void level_init(
        int arcade_x,int start_y,int screen);

    virtual void render(Drawable &d) const;
    virtual void update(int elapsed_time);
    virtual bool may_fall() const;

    bool is_at_bottom() const;

    enum CharacterContained { CC_OUT, CC_IN, CC_CROSS, CC_KILL };
    enum MoveState { STATE_GOING_UP=-1, STATE_FLOOR=0, STATE_GOING_DOWN=1 };

    CharacterContained get_contained_state(const Character &c) const;
    MoveState get_move_state() const
    {
        return m_move_state;
    }
    void copy_move_state_to(Elevator &other) const;
private:
    int m_min_y,m_max_y;
    AnimatedSprite m_sprite;
    int m_move_timer;
    int m_floor_timer;
    MyVector<int> m_stops;
    bool m_up_stops;
    bool m_down_stops;
    MoveState m_previous_move_state,m_move_state;
    void check_stop(bool middle_stops);
    void stop();

    const ImageFrame *m_wire;
    bool m_vertical_wire;

};


#endif // ELEVATOR_H_INCLUDED
