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

#ifndef GUARD_H
#define GUARD_H

#include "HumanCharacter.hpp"
#include "OptionsBase.hpp"

#include <map>

class Player;

class Guard : public HumanCharacter
{
public:
    Guard(OptionsBase::SkillLevel skill_level);
    virtual ~Guard();

    virtual void update(int elapsed_time);


    void init(MPLevel *level);
    void level_init(int x, int y, int screen_index, FullDirection d);
protected:
    //void render(Drawable &d) const; // debug only
    virtual void update_alive(int elapsed_time);
    virtual void on_die();
private:

    void set_lateral_direction(Direction d);
    bool set_full_direction(FullDirection gd);
    bool change_direction_at_random(int direction_mask);

    void handle_stuck(int elapsed_time);
    void handle_moves(int elapsed_time);
    void handle_branches(int logical_address);
    void handle_elevator_waits(int logical_address);
    void handle_elevator_moves();
    // d is in/out
    void get_elevator_exit_yd(int &ey,Direction &d) const;

    typedef std::map<int,int> AddressDirection;

    AddressDirection m_elevator_waiting_table;
    AddressDirection m_direction_branch_table;
    int m_last_direction_branch_address;


    AddressDirection m_screen_guide[3][3];
    void create_table(const unsigned char *raw_table,AddressDirection &ad);

    FullDirection m_full_direction;  // careful: this is the 4-directional direction, not to be mixed up with m_direction
    MoveType handle_left_right();
    void ladder_escape();
    MoveType handle_up_down();
    void update_speed();
    void cheat_with_elevator();

    void change_direction_axis(bool opposite_fallback);

    void set_speed(bool pos1, bool pos2, bool pos3, bool pos4);

    //static void addr2xy(int addr, int &x, int &y);
    static int xy2addr(int x,int y);

    int m_update_timer;
    int m_previous_location_x;
    int m_previous_location_y;
    int m_stuck_timer;
    bool m_waiting_elevator;
    int m_deny_waiting_elevator_timer;
    OptionsBase::SkillLevel m_skill_level;

};

#endif // GUARD_H
