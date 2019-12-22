#ifndef MPDOMAIN_H_INCLUDED
#define MPDOMAIN_H_INCLUDED

#include "Abortable.hpp"
#include "GfxPalette.hpp"
#include "Player.hpp"
#include "SoundSet.hpp"
#include "Fonts.hpp"
#include "OptionsBase.hpp"
#include "Cross.hpp"


class GameContext;

/**
 * contains information shared by all screens (menu, game ...)
 * MP means "Magic Pockets" and never was renamed (sorry!!)
 */

class MPDomain : public Abortable
{
public:
  MPDomain(bool silent,bool show_all_screens,bool rotate_90,bool full_screen,bool invincible,Cross *system_stub, GfxPalette *palette, OptionsBase *menu_options);
  ~MPDomain();
  DEF_GET_STRING_TYPE(MPDomain);


  const GfxPalette &get_palette() const
  {
    return m_palette;
  }

  const OptionsBase &get_menu_options() const
  {
    return m_menu_options;
  }
  OptionsBase &get_modifiable_menu_options()
  {
    return m_menu_options;
  }

  Player *player = nullptr;
  SoundSet sound_set;
  Cross *system_stub = nullptr;
  Fonts darker_font,dark_font,light_font;
  bool show_all_screens;
  bool rotate_90;
  bool full_screen;
  bool invincible;

  bool is_audio_enabled() const
  {
    return !sound_set.is_silent();
  }
private:
  GfxPalette &m_palette;
  OptionsBase &m_menu_options;


};
#endif // MPDOMAIN_H_INCLUDED
