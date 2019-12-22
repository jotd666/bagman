#ifndef GAMECONTEXT_H_INCLUDED
#define GAMECONTEXT_H_INCLUDED

#include "Abortable.hpp"
#include "TimerEvent.hpp"
#include <list>
#include "SDL/SDL.h"
#include "PlayerControls.hpp"
#include "Drawable.hpp"
#include "ImageFrame.hpp"
#include "PointerList.hpp"
#include "DisplayDepth.hpp"
#include "SdlColorPalette.hpp"

class GameContext : public Abortable
{
public:
  DEF_GET_STRING_TYPE(GameContext);

  GameContext();

  virtual ~GameContext();

  void init(SDL_Surface *screen);

  /**
   * @returns 0 if no screen change
   */

  GameContext *update(int elapsed);

  bool is_quit_requested() const;

  void destroy();

protected:
  /**
   * portable method to apply fadein/fadeout on a paletted/non-paletted display
   * coeff: 0-255: fade coeff
   **/

  void apply_fade_coeff(int coeff);
  void apply_fade_to_white_coeff(int coeff);

  void apply_alpha_rgb(int alpha_rgb, const SDL_Rect &bounds);
  void apply_alpha_rgb(int alpha_rgb);
  void add_timer_event(TimerEvent &te);
  void quit_requested()
  {
    m_quit_requested = true;
  }
  Drawable m_screen;
  PlayerControls::Status m_input;
private:
  void apply_alpha_rgb(int alpha_rgb, const SDL_Rect *bounds);
  bool m_quit_requested;

#if DISPLAY_DEPTH > 8
  ImageFrame m_fadeout_buffer;
#else
  #ifndef __amigaos__
  SdlColorPalette m_palette;
  #endif
#endif

  PlayerControls m_controls;
  virtual GameContext *private_update(int elapsed) = 0;
  virtual void private_init() = 0;
  PointerList<TimerEvent,false> m_events;


};

#endif // GAMECONTEXT_H_INCLUDED
