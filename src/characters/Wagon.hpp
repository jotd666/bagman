#ifndef WAGON_H_INCLUDED
#define WAGON_H_INCLUDED

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


class Wagon : public Character
{
    public:
    DEF_GET_STRING_TYPE(Wagon);
    void init(MPLevel *level,int min_screen_x,int max_screen_x,int min_screen,int max_screen);
    void level_init(int start_x,int start_y,int start_screen);
    void render(Drawable &d) const;
    void update(int elapsed_time);
    bool may_fall() const;
    void empty();
    private:
    int m_min_screen,m_max_screen,m_min_x,m_max_x;
    AnimatedSprite m_sprite;
    int m_move_timer;
};


#endif // WAGON_H_INCLUDED
