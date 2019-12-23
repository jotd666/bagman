#ifndef MENUSCREEN_H_INCLUDED
#define MENUSCREEN_H_INCLUDED

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

#include "GameContext.hpp"
#include "FadeInEvent.hpp"
#include "FadeOutEvent.hpp"
#include "ScaleSize.hpp"

class MPDomain;
class OptionsBase;

/** menu screen
 */

class MenuScreen : public GameContext
{
public:
  MenuScreen(MPDomain *domain);
  DEF_GET_STRING_TYPE(MenuScreen);
private:
  void private_init();
  GameContext *private_update(int elapsed_time);

  MPDomain *m_domain;
  OptionsBase *m_options;
  FadeInEvent m_fadein_event;
  FadeOutEvent m_fadeout_event;
  int m_flash_timer;
  int m_current_option;
  #ifdef PARTIAL_REFRESH
  int m_nb_renders = 2;
  #endif
};


#endif // MENUSCREEN_H_INCLUDED
