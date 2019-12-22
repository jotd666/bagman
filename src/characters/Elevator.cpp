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

#include "Elevator.hpp"
#include "ScaleSize.hpp"
#include "MPLevel.hpp"
#include "Player.hpp"
#include "GsMaths.hpp"

void Elevator::init(MPLevel *level,const GfxFrameSet *gfs,int min_y,int max_y,
                    const MyVector<int> &stops,bool up_stops,bool down_stops)
{
    Character::init(level);
    m_sprite.init(gfs,this);
    set_w(16);
    set_h(16);
    m_wire = &(level->get_palette().wire.get_first_frame().to_image());
    m_stops = stops;
    m_up_stops = up_stops;
    m_down_stops = down_stops;

    m_min_y = min_y;
    m_max_y = max_y;

    m_vertical_wire = m_wire->get_w() < m_wire->get_h();
}

void Elevator::level_init(int arcade_x,int start_y,int screen)
{
    Locatable start_location;
    start_location.set_xy(arcade_x+screen*224,start_y);

    Character::level_init(start_location);

    m_move_timer = 0;
    m_floor_timer = 0;
    m_previous_move_state = STATE_GOING_DOWN;
    m_move_state = STATE_FLOOR;


}
void Elevator::render(Drawable &d) const
{

    SDLRectangle src(0,0,m_wire->get_w()*SCALE_SIZE,(get_y()-0x10)*SCALE_SIZE);
    if (!m_vertical_wire)
    {
        // kludge for rotated 90 mode
        SWAP(src.w,src.h,int);
    }
    SDLRectangle dst(get_x()+8,0x10,0,0);
    m_wire->render(d,&src,&dst);
    m_sprite.render(d);
}
void Elevator::update(int elapsed_time)
{
    int player_screen = m_player->get_current_screen();
    int cs = get_current_screen();

    // elevator kludge
    // update elevator from middle screen if player is in first screen or middle screen
    // update elevator from rightmost screen if player is in rightmost screen

    if ((player_screen == 0 && cs == 1) || cs == player_screen)
    {
        switch(m_move_state)
        {
        case STATE_FLOOR:
            m_floor_timer += elapsed_time;
            if (m_floor_timer >= 2000)
            {
                m_floor_timer = 0;
                if (get_y() <= m_min_y)
                {
                    m_move_state = STATE_GOING_DOWN;
                }
                else if (get_y() >= m_max_y)
                {
                    m_move_state = STATE_GOING_UP;
                }
                else
                {
                    m_move_state = m_previous_move_state;
                }
            }
            break;
        case STATE_GOING_DOWN:
        case STATE_GOING_UP:
            m_move_timer += elapsed_time;
            while (m_move_timer > 75/6)
            {
                m_move_timer -= 75/6;
                add_y(m_move_state);
                if (m_move_state == STATE_GOING_DOWN)
                {

                    check_stop(m_down_stops);

                }
                else
                {

                    check_stop(m_up_stops);

                }

            }
        }
    }
}

void Elevator::check_stop(bool middle_stops)
{
    int y = get_y();
    bool do_stop = (y == m_min_y) || (y == m_max_y);

    if (!do_stop && middle_stops)
    {


        int nb_stops = m_stops.size();
        for (int i = 0; i <nb_stops; i++)
        {
            if (m_stops[i] == y)
            {
                do_stop = true;
                break;
            }
        }
    }
    if (do_stop)
    {
        stop();
    }
}

inline void Elevator::stop()
{
    if (m_move_state != STATE_FLOOR)
    {
        m_previous_move_state = m_move_state;
    }
    m_floor_timer = 0;
    m_move_state = STATE_FLOOR;
}

void Elevator::copy_move_state_to(Elevator &other) const
{
    other.m_move_state = m_move_state;
    if (other.m_move_state == STATE_GOING_DOWN && other.get_y() == other.m_max_y)
    {
        other.stop();
    }
    else if (other.m_move_state == STATE_GOING_UP && other.get_y() == other.m_min_y)
    {
        other.stop();
    }

}
bool Elevator::is_at_bottom() const
{
    return get_y() == m_max_y;
}

Elevator::CharacterContained Elevator::get_contained_state(const Character &c) const
{
    CharacterContained cc = CC_OUT;

    int x = get_x();
    int cx = c.get_x()+2;
    int wx = x+get_w();
    int cwx = cx+c.get_w()-1;

    if (((cx < wx) && (cx > x)) ||
            ((cwx < wx) && (cwx > x)))
    {
        // x matches: test y now
        int low_y = c.get_y() + c.get_h();
        int low_ey = get_y() + get_h();
        int dy = low_y - low_ey + 1;

        if (dy >= -2 && dy <= 2)  // tolerance so player stays in the "CC_IN" state
        {
            int dx = x - cx;

            // containing or crossing
            if (GsMaths::abs(dx) <= 2)
            {
                cc = CC_IN;
            }
            else
            {
                cc = CC_CROSS;
            }
        }
        else if ((dy > 2) && (dy < c.get_h()))
        {
            // small hack: guards are not killed by the elevator
            if (dynamic_cast<const Player *>(&c) != 0)
            {
                debug("KILL !! %d",dy);
                cc = CC_KILL;
            }
        }
    }

    return cc;
}

bool Elevator::may_fall() const
{
    return false;
}

