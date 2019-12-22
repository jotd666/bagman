#include "GameContext.hpp"
#include "DisplayDepth.hpp"

void GameContext::init(SDL_Surface *screen)
{
  ENTRYPOINT(init);
  m_screen.init(screen);
  m_quit_requested = false;
#if DISPLAY_DEPTH > 8
  m_fadeout_buffer.create(m_screen.get_w(),m_screen.get_h(),true);
#else
  #ifndef __amigaos__
  // palette mode: no alpha
  m_palette.copy_from_source(m_screen);
  #endif
#endif

  ENTRYPOINT(private_init); // declare it here, so all childs don't have to do it
  private_init();
  EXITPOINT;
  EXITPOINT;

}

GameContext::~GameContext()
{

}

void GameContext::destroy()
{

}

GameContext *GameContext::update(int elapsed)
{
  GameContext *rval = 0;
  ENTRYPOINT(update);
  PointerList<TimerEvent>::iterator it,it_next;

  it = m_events.begin();

  while (it != m_events.end())
    {
      it_next = it;
      it_next++;

      TimerEvent *te = (*it);

      te->update(elapsed);

      if (te->is_timeout_reached())
	{
	  // terminate event (and delete if event type says so)

	  m_events.erase(it);
	}

      it = it_next;
    }

  // read player input

  m_controls.update(m_input);

  // specific update

  rval = private_update(elapsed);
  EXITPOINT;
  return rval;
}
#ifdef _NDS
#include <nds.h>
#endif

void GameContext::apply_fade_to_white_coeff(int coeff)
{
#ifndef __amigaos__
#if DISPLAY_DEPTH > 8
  // use alpha channel for fadeout
  apply_alpha_rgb(0xFFFFFF + ((255 - coeff) << 24));
#else
    #ifdef _NDS
  // modifying hardware palette does not work on NDS SDL
  /** \brief
      \param screen 1 = main screen, 2 = subscreen, 3 = both
      \param level -16 = black, 0 = full brightness, 16 = white
   */
  int level = 16 - ((coeff * 16) / 255);

  setBrightness(1,level);

    #else
  // paletted display: modify hardware palette
  int percent = (coeff*100)/255;

  m_palette.set_to_target(m_screen,percent,0xFFFFFF);
#endif
#endif
  #endif

}


void GameContext::apply_fade_coeff(int coeff)
{
#ifndef __amigaos__
    #if DISPLAY_DEPTH > 8
  // use alpha channel for fadeout
  apply_alpha_rgb((255 - coeff) << 24);
    #else
    #ifdef _NDS
  // modifying hardware palette does not work on NDS SDL
  /** \brief
      \param screen 1 = main screen, 2 = subscreen, 3 = both
      \param level -16 = black, 0 = full brightness, 16 = white
   */
  int level = (coeff * 16) / 255 - 16;

  setBrightness(1,level);

    #else
  // modify hardware palette
  int percent = (coeff*100)/255;

  m_palette.set_to_target(m_screen,percent);
    #endif
    #endif
  #endif
}

void GameContext::apply_alpha_rgb(int alpha_rgb, const SDL_Rect &bounds)
{
  apply_alpha_rgb(alpha_rgb,&bounds);

}

void GameContext::apply_alpha_rgb(int alpha_rgb)
{
  apply_alpha_rgb(alpha_rgb,0);

}
void GameContext::apply_alpha_rgb(int alpha_rgb, const SDL_Rect *bounds)
{
#if DISPLAY_DEPTH > 8
  m_screen.render(m_fadeout_buffer,bounds,0);
  m_fadeout_buffer.fill_rect(0,alpha_rgb);
  m_fadeout_buffer.render(m_screen,0,bounds);
#endif
}

bool GameContext::is_quit_requested() const
{
  return m_quit_requested;
}
GameContext::GameContext() : m_screen(0)
{
}

void GameContext::add_timer_event(TimerEvent &te)
{
  m_events.push_back(&te);
}
