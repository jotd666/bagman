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
#include "Guard.hpp"
#include "MPLevel.hpp"
#include "MPDomain.hpp"
#include "GfxPalette.hpp"
#include "Player.hpp"
#include "GuardTables.hpp"
#include "GsMaths.hpp"
#include "RandomNumber.hpp"


Guard::Guard(OptionsBase::SkillLevel skill_level)  : HumanCharacter(SoundSet::guard_step,SoundSet::guard_climb),
    m_skill_level(skill_level)
{
    //ctor
}

Guard::~Guard()
{
    //dtor
}

Guard::MoveType Guard::handle_up_down()
{
    MoveType rval = MT_BLOCKED;

    if (m_full_direction == FD_UP)
    {
        rval = try_to_move_up();
    }
    else if (m_full_direction == FD_DOWN)
    {
        rval = try_to_move_down();
    }
    m_move_type = rval;
    m_frame_index = CLIMB;



    return rval;
}


Guard::MoveType Guard::handle_left_right()
{
    MoveType rval = MT_BLOCKED;
    FullDirection d = m_full_direction;

    if (d == FD_LEFT)
    {
        rval = try_to_move_left();
    }
    else if (d == FD_RIGHT)
    {
        rval = try_to_move_right();
    }
    m_move_type = rval;
    m_frame_index = WALK;

    return rval;
}


void Guard::ladder_escape()
{
    if (RandomNumber::rand(2) == 0)
    {
        if (can_climb_up())
        {
            set_full_direction(FD_UP);
        }
    }
    else
    {
        if (can_climb_down())
        {
            set_full_direction(FD_DOWN);
        }

    }
}

void Guard::update(int elapsed_time)
{
    HumanCharacter::update(elapsed_time);
    switch(get_life_state())
    {

    case DEAD:
    {

        if (m_stunned_duration <= 0)
        {
            // resurrect the guard
            set_life_state(ALIVE);
            set_position(STATE_WALK);
            set_full_direction(RandomNumber::rand(2) == 0 ? FD_LEFT : FD_RIGHT);
        }


        break;
    }
    case DYING:
        break;
    case ALIVE:
    {
        if (collides_player())
        {
            bool in_wagon = m_player->get_state() == STATE_IN_WAGON;
            if (m_player->owns(GfxObject::PICK) && (
                        in_wagon || m_player->get_state() != STATE_CLIMB))
            {
                // do nothing: let the player side handle this
            }
            else
            {
                if (!in_wagon)
                {
                    if (!m_level->get_domain().invincible)
                    {
                    m_player->kill();
                    }
                }
            }

        }
        break;
    }
    }
}

void Guard::on_die()
{
    m_stunned_duration = 5000;
    set_stunned_frame_update_rate(200);

    play_sound(SoundSet::guard_killed);
    if (m_level->all_guards_are_stunned())
    {
        // both will recover at the same time, but quicker
        PointerVector<Guard,true>::iterator it;
        FOREACH(it,m_level->get_guards())
        {
            (*it)->m_stunned_duration = 2500;
            (*it)->set_stunned_frame_update_rate(100);
        }
    }
}

void Guard::get_elevator_exit_yd(int &ey,Direction &d) const
{

    int cs = get_current_screen();
    int py = m_player->get_y();
    int px = m_player->get_x() % 224;
    // guard strategy to exit elevators wisely
    // this is kind of dishonest from the game because the guard
    // does not actually "see" the player, but that's the way it
    // works in the original game (check the .asm source at 0x2BD1)

    ey = -1;

    switch(cs)
    {
    case 1:
        // middle screen
        if (py > 0x80)
        {
            d = LEFT;   // JOTD: added that (did not see it in the original, maybe it's there)
            ey = 0x88; // exits at the bottom if player y > $80
        }
        else if (px < 0x98)
        {
            d = LEFT;   // JOTD: added that (did not see it in the original, maybe it's there)
            ey = 0x40; // exits at the wagon exit if player in the upper-left quarter x < $98
        }
        else
        {
            d = RIGHT;  // JOTD: added that (did not see it in the original, maybe it's there)
            ey = 0x69; //  exits at the 2nd floor (2 bags, lead to screen 3)
        }
        break;
        // note that guard never exits using top of screen exit unless he crosses an elevator by chance

    case 2:
        // right screen
        if (px < 0x28)
        {
            d = LEFT;
        }
        else
        {
            d = RIGHT;
        }
        if (py < 0x78)
        {
            ey = 0x29; // exits at y=$29 (below the top exit) if player y < $78
        }
        else if (py < 0xA0)
        {
            ey = 0x71; // exits at y=$71 (slope exit) if player y < $A0
        }
        else if (py < 0xC0)
        {
            ey = 0xA9; // exits at y=$A9 (pickaxe exit) if player y < $C0
        }
        else
        {
            ey = 0xC8;  // else exits at the bottom
        }
        break;
    default:
        my_assert(1==0);
        break;
    }

}

void Guard::handle_elevator_waits(int logical_address)
{

    AddressDirection::const_iterator it = m_elevator_waiting_table.find(logical_address);
    if (it != m_elevator_waiting_table.end()) // && !elevator_wait_override())
    {
        // wait for the elevator in the direction given by the table
        FullDirection wait_direction = (FullDirection)it->second;
        if (m_deny_waiting_elevator_timer <= 0)
        {
            m_waiting_elevator = true;
            set_full_direction(wait_direction);
        }
    }
}

void Guard::cheat_with_elevator()
{
    Elevator *e = m_level->get_elevator(get_current_screen());

    // before doing anything, check that elevator is not at the bottommost position
    // because in that position, guard can cross it without being stuck, so let it
    // stay that way

    if (e != 0 && !e->is_at_bottom())
    {
        Elevator::CharacterContained cc = e->get_contained_state(*this);

        if (cc == Elevator::CC_IN)
        {
            int min_y = 0x11;
            // set the elevator to the top (and guard too)
            e->set_y(min_y);
            set_y(min_y);
        }
    }
}
void Guard::handle_elevator_moves()
{
    const Elevator *e = m_level->get_elevator(get_current_screen());
    my_assert(e != 0); // no elev waits on first screen
    Elevator::CharacterContained cc = e->get_contained_state(*this);

    switch (cc)
    {
    case Elevator::CC_OUT:
        if (e->get_move_state() == Elevator::STATE_FLOOR)
        {
            if (m_waiting_elevator)
            {
                if (GsMaths::abs(e->get_y()-get_y()) <= 2)
                {
                    // enter in the elevator
                    if (get_direction() == LEFT)
                    {
                        try_to_move_left();
                    }
                    else
                    {
                        try_to_move_right();
                    }
                }
            }
        }
        break;

    case Elevator::CC_CROSS:
    {
        // enter in the elevator
        if (get_direction() == LEFT)
        {
            try_to_move_left();
        }
        else
        {
            try_to_move_right();
        }
        break;
    }
    case Elevator::CC_IN:
    {
        if (e->get_move_state() == Elevator::STATE_FLOOR)
        {
            int ey;
            Direction d = get_direction();
            get_elevator_exit_yd(ey,d);
            set_lateral_direction(d);
            // in the elevator: check if must exit
            if (GsMaths::abs(get_y()-ey) < 2)
            {
                //debug("GUARD EXITS ELEVATOR/QUITS WAITING ey=%d, py=%d",ey,m_player->get_y());
                m_waiting_elevator = false;
                m_deny_waiting_elevator_timer = 3000;
            }
        }

    }
    break;
    default:
        break;
    }

}
void Guard::handle_moves(int elapsed_time)
{
    m_update_timer += elapsed_time;
    while (m_update_timer > m_update_rate)
    {
        m_previous_location_x = get_x();
        m_previous_location_y = get_y();

        m_update_timer -= m_update_rate;

        int logical_address = xy2addr(get_x(),get_y());

        int player_screen = m_level->get_player()->get_current_screen();
        int guard_screen = get_current_screen();

        if (player_screen == guard_screen)
        {
            // same screen as player
            //debug("logical addr %x %d %d",logical_address,get_x(),get_y());

            // random search mode: first check if sees player
            int x_watch = get_x()+4;
            int y_watch = get_y()+4;
            int x_player = m_player->get_x();
            int y_player = m_player->get_y();


            int dx = x_player-get_x(); // dx positive if guard on the left of the player
            int dy = y_player-get_y(); // dy positive if guard above player

            // added dy limit for case guard vs player in wagon
            if (GsMaths::abs(dx) < 16 && GsMaths::abs(dy) > 4 && m_grid->is_vertical_clear(x_watch,y_watch,dy))
            {
                m_waiting_elevator = false; // not really useful since not possible

                // guard sees player y-wise
                // tries to change direction (set_full_direction contains a test to check if can actually change direction)
                if (dy >= 0)
                {
                    set_full_direction(FD_DOWN);
                }
                else if (dy <= 0)
                {
                    set_full_direction(FD_UP);
                }

            }
            else if (GsMaths::abs(dy) < 16 && m_grid->is_horizontal_clear(x_watch,y_watch,dx))
            {
                bool player_has_pick = m_player->owns(GfxObject::PICK);
                bool follow_player = true;
                m_waiting_elevator = false;

                if (player_has_pick)
                {
                    if (m_position == STATE_CLIMB)
                    {
                        // pretend not to see the player if on ladder
                        follow_player = false;
                    }
                    else
                    {
                        // walk position but stuck: select an up/down escape route
                        if ((dx < 0 && !can_move_right()) || (dx > 0 && !can_move_left()))
                        {
                            ladder_escape();
                            follow_player = false;
                        }
                    }
                }

                if (follow_player)
                {
                    // guard sees player x-wise

                    if (dx < 0)
                    {
                        set_full_direction(player_has_pick ? FD_RIGHT : FD_LEFT);
                    }
                    else if (dx > 0)
                    {
                        set_full_direction(player_has_pick ? FD_LEFT: FD_RIGHT);
                    }
                }
            }
            else
            {
                handle_elevator_waits(logical_address);
                if (!m_waiting_elevator)
                {
                    // guard does not see the player: check special location for random branch
                    handle_branches(logical_address);
                }
            }
            if (!m_waiting_elevator)
            {
                switch (m_full_direction)
                {
                case FD_LEFT:
                case FD_RIGHT:
                    handle_left_right();
                    break;
                case FD_UP:
                case FD_DOWN:
                {
                    // perform a step

                    handle_up_down();

                }

                break;
                }
            }
            else
            {
                // waiting for elevator or in the elevator
                handle_elevator_moves();
            }
        }
        else
        {
            // guided mode: if not same screen as player, just follow a predefined path depending on where they are

            // not the same screen as player: if guard was in the elevator, then
            // raise the elevator + the guard up (like in the arcade game)
            cheat_with_elevator();

            // guided mode: don't wait for elevators, just walk and change directions according to the correct table
            m_waiting_elevator = false;

            const AddressDirection &ad = m_screen_guide[guard_screen][player_screen];
            AddressDirection::const_iterator it = ad.find(logical_address);
            if (it != ad.end())
            {
                set_full_direction((FullDirection)it->second);

                // debug("found logical address %x: direction = %x",logical_address,m_full_direction);
            }
            switch (m_full_direction)
            {
            case FD_LEFT:
            case FD_RIGHT:
                handle_left_right();
                break;
            case FD_UP:
            case FD_DOWN:
                if (handle_up_down() == MT_BLOCKED)
                {
                    set_position(STATE_WALK);
                    set_full_direction(m_direction == LEFT ? FD_LEFT : FD_RIGHT);
                }
                break;
            }
            //debug("%d guard screen %d player %d",get_x(),guard_screen,player_screen);

        }

        handle_stuck(elapsed_time);


    }
}

void Guard::update_alive(int elapsed_time)
{
    if (m_deny_waiting_elevator_timer > 0)
    {
        m_deny_waiting_elevator_timer -= elapsed_time;
    }
    update_speed();

    handle_gravity(elapsed_time);
    switch (m_position)
    {
    case STATE_IN_AIR:
        break;

    case STATE_WALK:
    case STATE_CLIMB:
        handle_moves(elapsed_time);

        break;
    default:
        // some states are only available for the human player
        break;

    }
}

bool Guard::change_direction_at_random(int direction_mask)
{
    bool rval = true;
    // random tables where opposite direction is not present
    // (original game uses only 1 table, and retries a random cast until not opposite, which
    // is less stable and requires a direction test anyway)

    static const FullDirection dir_table_up[] = { FD_LEFT, FD_RIGHT, FD_UP };
    static const FullDirection dir_table_down[] = { FD_LEFT, FD_RIGHT, FD_DOWN };
    static const FullDirection dir_table_left[] = { FD_LEFT, FD_UP, FD_DOWN };
    static const FullDirection dir_table_right[] = { FD_RIGHT, FD_UP, FD_DOWN };

    const FullDirection *dir_table = 0;

    switch (m_full_direction)
    {
    case FD_UP:
        dir_table = dir_table_up;
        break;
    case FD_DOWN:
        dir_table = dir_table_down;
        break;
    case FD_LEFT:
        dir_table = dir_table_left;
        break;
    case FD_RIGHT:
        dir_table = dir_table_right;
        break;
    }

    int v = RandomNumber::rand(3);
    FullDirection requested_direction = dir_table[v];


    if ((requested_direction & direction_mask) != 0)
    {
        rval = set_full_direction(requested_direction);
    }
    else
    {
        // anticipate the wall and change direction to up or down
        // direction is allowed in table: change direction
        if (m_full_direction == requested_direction)
        {

            if ((m_full_direction == FD_LEFT && m_grid->is_lateral_way_blocked(get_x()-16,get_y())) ||
                    (m_full_direction == FD_RIGHT && m_grid->is_lateral_way_blocked(get_x()+32,get_y())))
            {
                change_direction_axis(false);
            }
        }
    }

    return rval;
}
void Guard::handle_branches(int logical_address)
{

    if (logical_address != m_last_direction_branch_address)
    {
        AddressDirection::const_iterator it = m_direction_branch_table.find(logical_address);
        if (it != m_direction_branch_table.end())
        {
            int direction_mask = it->second;
            change_direction_at_random(direction_mask);

            // store last branch address so it does not try several times while being in
            // the same zone (logical address matches more than one x,y couple)
            m_last_direction_branch_address = logical_address;
        }
        // else, keep previous direction: either stuck or keep moving as before
    }


}

void Guard::set_lateral_direction(Direction d)
{
    set_direction(d);
    if (d == LEFT)
    {
        m_full_direction = FD_LEFT;
    }
    else
    {
        m_full_direction = FD_RIGHT;
    }
}


void Guard::change_direction_axis(bool opposite_fallback)
{
    bool evt = RandomNumber::happens_once_out_of(2);
    FullDirection dir1 = FD_UP, dir2 = FD_DOWN;


    switch (m_full_direction)
    {
    case FD_LEFT:
    case FD_RIGHT:
        if (evt)
        {
            dir1 = FD_UP;
            dir2 = FD_DOWN;
        }
        else
        {
            dir1 = FD_DOWN;
            dir2 = FD_UP;

        }
        break;

    case FD_DOWN:
    case FD_UP:
        if (evt)
        {
            dir1 = FD_LEFT;
            dir2 = FD_RIGHT;
        }
        else
        {
            dir1 = FD_RIGHT;
            dir2 = FD_LEFT;

        }
        break;

    }
    // try to change direction orthogonally first

    if (!set_full_direction(dir1) && !set_full_direction(dir2))
    {
        if (opposite_fallback)
        {
            // not possible: fallback to opposite direction to get out of stuck mode
            set_full_direction(get_opposite_direction(m_full_direction));
        }
    }

}
void Guard::handle_stuck(int elapsed_time)
{
    if (!m_waiting_elevator && m_previous_location_x == get_x() && m_previous_location_y == get_y())
    {
        m_stuck_timer += elapsed_time;
        if (m_stuck_timer > 1000)
        {
            // not moving for long enough: change direction
            // (means if walking try to climb and if not possible then walk the other way
            // if climbing try to walk and if not possible climb the other way)

            change_direction_axis(true);
        }
    }
    else
    {
        m_stuck_timer = 0;
    }
}

inline void Guard::set_speed(bool pos1, bool pos2, bool pos3, bool pos4)
{
    m_walk_sequence[1].second = pos1;
    m_walk_sequence[3].second = pos2;
    m_walk_sequence[4].second = pos3;
    m_walk_sequence[8].second = pos4;
}
void Guard::update_speed()
{
    int ps = m_player->get_score() / 10000;
    ps += (int)(m_skill_level-1); // "trainer" mode is even easier
    if (ps<0)
    {
        ps=0;
    }


    /*	easy:	0->10000 :	0 (f f f f)
                10000->20000 :	2 (t f f f)
    	        20000->30000:	4 (t t f f)
    	        30000->40000 :	5 (t t t f)
    	        after 40000 :	 9 (t t t t)
    	        after 50000 :	 10 (same as 9)

    	for medium, hard, hardest, just shift score by 10000 each
    	which gives for the hardest setting:

    	- hardest:  0->10000: 5 (t t t f)
    	-           10000->20000: 9 (t t t t)
    	            above: 10 (t t t t)

        speed 9 and 10 are the same (may not have been the same for some
        early version of the code, but has been quickly hacked and there's
        no distinction between 9 and 10: same speed as player
    */

    switch (ps)
    {
    case 0:
        set_speed(false,false,false,false);
        break;
    case 1:
        set_speed(true, false,false,false);
        break;
    case 2:
        set_speed(true, true, false,false);
        break;
    case 3:
        set_speed(true, true, true, false);
        break;
    case 4:
        set_speed(true, true, true, true);
        break;
    default:
        // higher
        break;
    }


}

void Guard::init(MPLevel *level)
{
    const GfxPalette &p = level->get_palette();
    HumanCharacter::init(level);
    set_walk_frames(p.guard);
    set_special_frames(p.guard_special);

    set_life_state(ALIVE);

    add_walk_pos(0,true); // 1: move
    add_walk_pos(0,false); // 2 variable
    add_walk_pos(1,false); // 3: don't move
    add_walk_pos(1,false); // 4 variable
    add_walk_pos(1,false); // 5: don't move
    add_walk_pos(1,true); // 6: move
    add_walk_pos(1,false); // 7 dont move
    add_walk_pos(2,true); // 8: move
    add_walk_pos(2,false); // 9 variable
    add_walk_pos(2,true); // 10: move
    add_walk_pos(2,false); // 11: don't move


    add_climb_pos(0,false);
    add_climb_pos(0,true);
    add_climb_pos(0,false);
    add_climb_pos(0,true);
    add_climb_pos(0,false);
    add_climb_pos(1,true);
    add_climb_pos(1,true);
    add_climb_pos(1,false);
    add_climb_pos(1,true);
    add_climb_pos(1,true);
    add_climb_pos(1,true);

    create_table(waiting_point_table,m_elevator_waiting_table);
    create_table(guide_from_3_to_2,m_screen_guide[2][1]);
    create_table(guide_from_2_to_3,m_screen_guide[1][2]);
    create_table(guide_from_1_to_2,m_screen_guide[0][1]);
    create_table(guide_from_2_to_1,m_screen_guide[1][0]);
    // duplicate tables for opposite screen lookup
    m_screen_guide[2][0] = m_screen_guide[2][1];
    m_screen_guide[0][2] = m_screen_guide[1][2];

    const unsigned char *cp = direction_branch_table;
    while (*cp != 0xFF)
    {
        int msb = *(cp++);
        int lsb = *(cp++);
        int dm = *(cp++);   // direction mask
        m_direction_branch_table.insert(std::make_pair(lsb+(msb<<8),dm));
    }

}


#if 0
#include "MPDomain.hpp"
#include "Fonts.hpp"

void Guard::render(Drawable &d) const
{
    HumanCharacter::render(d);
    /*
        const AddressDirection &ad = m_screen_guide[2][1];
        const Fonts &f = m_level->get_domain().darker_font;


        AddressDirection::const_iterator it;

        FOREACH(it,ad)
        {
            int v = it->first;
            int di = it->second;
            int x,y;
            addr2xy(v, x, y);
            f.write(d,x,y,MyString(di/16));
        }
            AddressDirection::const_iterator it2;
            FOREACH(it2,m_direction_branch_table)
            {
                int v = it2->first;
                int x,y;
                addr2xy(v, x, y);
                f.write(d,x,y,"0");

            }
            */

    const AddressDirection &ad = m_elevator_waiting_table;

    AddressDirection::const_iterator it;
    const Fonts &f = m_level->get_domain().darker_font;
    FOREACH(it,ad)
    {
        int v = it->first;
        int x,y;
        addr2xy(v, x, y);
        f.write(d,x,y,"9");
    }
}
#endif

void Guard::create_table(const unsigned char *raw_table,AddressDirection &ad)
{
    const unsigned char *cp = raw_table;
    while (*cp != 0xFF)
    {
        int fb = *(cp++);
        int lb = *(cp++);
        FullDirection d = (FullDirection)(*(cp++));
        switch(d)
        {
        case FD_LEFT:
        case FD_RIGHT:
        case FD_UP:
        case FD_DOWN:
            // OK valid
            break;
        default:
            // should not happen if tables are OK, just a sanity check
            abort_run("invalid direction %x, offset %d",d,(int)(cp-raw_table));
        }
        int address = lb+(fb<<8); // : fb+(lb<<8);

        ad.insert(std::make_pair(address,d));

    }

}


bool Guard::set_full_direction(FullDirection gd)
{
    bool rval = false;
    switch (gd)
    {
    case FD_LEFT:
        if (can_move_left())
        {
            rval = true;
            m_full_direction = gd;

            set_direction(LEFT);
        }
        break;
    case FD_RIGHT:
        if (can_move_right())
        {
            rval = true;
            m_full_direction = gd;

            set_direction(RIGHT);
        }
        break;

    case FD_UP:
        if (can_climb_up())
        {
            rval = true;
            m_full_direction = gd;
        }
        break;
    case FD_DOWN:
        if (can_climb_down())
        {
            rval = true;
            m_full_direction = gd;
        }
        break;
    }
    return rval;
}

void Guard::level_init(int arcade_x, int y, int screen_index, FullDirection d)
{

    // arcade game values

    HumanCharacter::level_init(arcade_x,y,screen_index);

    m_previous_location_x = get_x();
    m_previous_location_y = get_y();

    m_stuck_timer = 0;
    m_deny_waiting_elevator_timer = 0;
    m_waiting_elevator = false;
    m_last_direction_branch_address = 0;

    set_full_direction(d);
    m_full_direction = d; // force direction

    m_update_timer = 0;

    // m_walk_timer = 0;





}


// xy <-> logical address conversions
inline int Guard::xy2addr(int x,int y)
{
    int screen_offset = 0;
    int sx = x;
    if (sx >= 224*2)
    {
        screen_offset+=0x800;
        sx -= 224*2;
    }
    else if (sx >= 224)
    {
        screen_offset+=0x400;
        sx -= 224;
    }

    int rval = 0x4062 + screen_offset + y/8 + ((0xE0-sx)/8)*0x20;
    return rval;
}

inline void Guard::addr2xy(int addr, int &x, int &y)
{
    int screen_offset = 0;
    // only works for 1st screen
    int b = addr - 0x4000;
    while (b>0x400)
    {
        screen_offset+=224;
        b-=0x400;
    }
    b -= 0x62;

    y = (b % 0x20) * 8;
    x = (0xE0 - b / 4) + screen_offset;

}





