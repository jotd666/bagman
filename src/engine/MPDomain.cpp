#include "MPDomain.hpp"
#include "DirectoryBase.hpp"
#include "MPLevel.hpp"


MPDomain::MPDomain(bool silent,bool show_all_screens, bool rotate_90, bool full_screen, bool p_invincible,Cross *system_stub,GfxPalette *palette, OptionsBase *menu_options) :
darker_font(rotate_90),
dark_font(rotate_90),
light_font(rotate_90),
invincible(p_invincible),
m_palette(*palette),
m_menu_options(*menu_options)

{

  this->system_stub = system_stub;
  this->show_all_screens = show_all_screens;
  this->rotate_90 = rotate_90;
  this->full_screen = full_screen;
  sound_set.init(silent);


  darker_font.load("fonts_darker_blue");
  dark_font.load("fonts_dark_blue");
  light_font.load("fonts_light_blue");

  LOGGED_NEW(player,Player());

  // init
}

MPDomain::~MPDomain()
{
  LOGGED_DELETE(player);
}


