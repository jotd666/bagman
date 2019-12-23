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

#include "MenuScreen.hpp"
#include "MPDomain.hpp"
#include "MPLevel.hpp"

#include "OptionsBase.hpp"
#include "RandomNumber.hpp"

MenuScreen::MenuScreen(MPDomain *domain) : m_domain(domain)
{
  m_options = &m_domain->get_modifiable_menu_options();
}

GameContext *MenuScreen::private_update(int elapsed_time)
{
  GameContext *rval = 0;

  RandomNumber::rand(10); // be sure to get a different random at each first game

  m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90);
  int opts_y = 180;
  int opts_x = 140;
  int y_start = 24;

   #ifdef PARTIAL_REFRESH
  if (m_nb_renders > 0) {
    m_nb_renders--;
  #endif
    m_screen.fill_rect(0,0);


    m_domain->get_palette().va_logo.render(m_screen,72,y_start);
    m_domain->get_palette().presents.render(m_screen,80,y_start+40);
    m_domain->get_palette().title.render(m_screen,32,y_start+64);

    m_domain->dark_font.write(m_screen,18,y_start+64+32,   "REMADE BY JOTD 2010-2019");
    m_domain->dark_font.write(m_screen,12,y_start+64+32+14,"ORIGINAL BY J.BRISSE 1982");


    // render options


    m_domain->light_font.write(m_screen,32,opts_y,"SKILL");
    m_domain->light_font.write(m_screen,32,opts_y+16,"EXTRA LIFE");

      #ifdef PARTIAL_REFRESH

  }
  // clear barrow / modifiable text
  SDLRectangle r(12,opts_y-8,16,50);
  m_screen.fill_rect(&r,0);
  SDLRectangle r2(opts_x,opts_y,80,32);
  m_screen.fill_rect(&r2,0);

  #endif

  m_domain->get_palette().barrow.get_first_frame().render(m_screen,12,opts_y-8+m_current_option*16);

  m_domain->darker_font.write(m_screen,opts_x,opts_y,MyString(m_options->get_skill_level_str()).uppercase());
  m_domain->darker_font.write(m_screen,opts_x,opts_y+16,MyString((int)m_options->get_extra_life_score())+" PTS");

  m_flash_timer += elapsed_time;

  if (m_flash_timer > 500)
    {
      m_domain->darker_font.write(m_screen,56,y_start+64+36+92,"FIRE TO START");
    }
  else
    {

      m_domain->darker_font.write(m_screen,56,y_start+64+36+92,
    #ifdef _NDS
				  "L AND R TO QUIT"
    #else
				  " ESC TO QUIT "
    #endif
      );
    }


  if (m_flash_timer > 1000)
    {
      m_flash_timer = 0;
    }

  if (m_input.fire.is_first_pressed() && !m_fadeout_event.is_running())
    {
#ifdef PARTIAL_REFRESH
      const int PTIMER = 50;
      #else
      const int PTIMER = 500;
      #endif


      m_fadeout_event.init(0,PTIMER);
      add_timer_event(m_fadeout_event);
    }
  if (m_fadeout_event.is_timeout_reached())
    {
      m_screen.fill_rect(0,0);
      m_options->save();
      rval = MPLevel::create(m_domain);

    }
  // start of level
  if (m_fadein_event.is_running())
    {
      apply_fade_coeff(m_fadein_event.get_coeff());
    }

  // end of level
  if (m_fadeout_event.is_running())
    {
      apply_fade_coeff(m_fadeout_event.get_coeff());
    }
  else
    {
      if (m_input.up.is_first_pressed())
	{
	  m_current_option--;
	  if (m_current_option < 0)
	    {
	      m_current_option = 1;
	    }
	}
      if (m_input.down.is_first_pressed())
	{
	  m_current_option++;
	  if (m_current_option > 1)
	    {
	      m_current_option = 0;
	    }
	}
      if (m_input.left.is_first_pressed())
	{
	  switch (m_current_option)
	    {
	      case 0:
		// skill level
		m_options->easier_skill_level();
		break;
	      case 1:
		m_options->easier_extra_life_score();
		break;
	      default:
		break;
	    }
	}
      if (m_input.right.is_first_pressed())
	{
	  switch (m_current_option)
	    {
	      case 0:
		// skill level
		m_options->harder_skill_level();
		break;
	      case 1:
		m_options->harder_extra_life_score();
		break;
	      default:
		break;
	    }
	}
      if (m_input.esc_pressed)
	{
	  // reboot the DS / return to homebrew menu
	  // not very good for AmigaOS since there's no resource tracking
	  // but we don't care for now!!
	  SDL_Quit();
	  exit(EXIT_SUCCESS);
	}
    }

  return rval;
}

void MenuScreen::private_init()
{
  m_fadein_event.init(0,500);
  add_timer_event(m_fadein_event);
  m_flash_timer = 0;
  m_current_option = 0;
}
