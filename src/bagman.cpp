/*#include "AudioProperties.hpp"
  #include "ModPlayer.hpp"
  #include "Mixer.hpp"*/
#include "SDL/SDL.h"
#include "Fonts.hpp"
#include "MPDomain.hpp"
#include "MenuScreen.hpp"
#include "MPLevel.hpp"

#include "MemoryEntryMap.hpp"

#include "MyAssert.hpp"
#include "ScaleSize.hpp"

#include "Cross.hpp"
#include "GsTime.hpp"

#include "DirectoryBase.hpp"

#undef main

#include "DisplayDepth.hpp"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH 224 * SCALE_SIZE
#define SCREEN_HEIGHT 256 * SCALE_SIZE
#endif

#include "MyFile.hpp"

#ifdef __amigaos
#include <hardware/custom.h>
#include <proto/graphics.h>
extern Custom custom;

#endif

class MainClass : public Abortable
{
  DEF_GET_STRING_TYPE(MainClass);

  GameContext *m_context;
  SDL_Surface *screen;
  SDL_TimerID refresh_timer_id;
  bool joystick;
  bool full_screen;
  bool active;
  bool silent;
  bool show_all_screens;
  bool rotate_90;
  bool direct_game;
  bool invincible;

  void screen_lock()
  {
    if ( SDL_MUSTLOCK(screen) )
      {
	if ( SDL_LockSurface(screen) < 0 )
	  {
	    return;
	  }
      }
  }

  void screen_unlock()
  {
    if ( SDL_MUSTLOCK(screen) )
      {
	SDL_UnlockSurface(screen);
      }
  }

  void video_update(Uint32 interval)
  {
    screen_lock();

    GameContext *nctx = m_context->update(interval);

    screen_unlock();
    SDL_Flip(screen);

    if (m_context->is_quit_requested())
      {
	shutdown();
      }
    else
      {
	if (nctx != 0)
	  {
	    // change context
	    // kill remaining objects before

	    if (m_context != 0)
	      {
		m_context->destroy();
	      }

	    LOGGED_DELETE(m_context);

	    m_context = nctx;

	    // initialize new context/screen

	    m_context->init(screen);
	  }

      }
  }

#ifndef _NDS
  static Uint32 refresh_timer_callback(Uint32 interval, void *param)
  {

#ifdef __amigaos
    (void)param;

    #else

    MainClass *c = (MainClass *)param;

    try
    {
      c->video_update(interval);
    }
    catch (const Abortable::Cause &cs)
    {
      c->error(cs,false);
      exit(1);

    }
    #endif

    return interval;
  }
  void timer_init()
  {
    /* initialise refresh timer */

    refresh_timer_id = SDL_AddTimer(20,refresh_timer_callback,this);
    if (refresh_timer_id == 0)
      {
	abort_run("Cannot create main SDL timer: %s",SDL_GetError());
      }
  }

#endif

  void create_snapshot()
  {
#ifndef _NDS
    debug("creating snapshot");
    MyString snappath = "$TEMP/snap.bmp";
    SDL_SaveBMP(screen,snappath.eval_env_variables().c_str());
#endif
  }



  void shutdown()
  {
    // SDL_RemoveTimer(refresh_timer_id);

    // wait to be sure it has exited before freeing the memory

    // SDL_Delay(100);

    active = false;

    LOGGED_DELETE(m_context);

  }
public:
  MainClass(int argc, char * const *argv) : joystick(false), full_screen(false), active(true),
  silent(false), show_all_screens(false), rotate_90(false), direct_game(false),
  invincible(false)
  {

 #ifdef USE_EXCEPTIONS
    try
    #endif
    {

#if !(defined _NDS) && (!defined __amigaos)
      int cargidx = 1;

      while (cargidx < argc)
	{
	  const char *carg = argv[cargidx++];

	  if (carg[0] == '-')
	    {
	      char c = carg[1];
	      switch (c)
		{
		  case 'i':
		    invincible = true;
		    break;
		  case 'g':
		    direct_game = true;
		    break;
		  case 'j':
		    joystick = true;
		    break;
		  case 's':
		    silent = true;
		    break;
		  case 'f':
		    full_screen = true;
		    break;
		  case 'h':
		    warn("Usage: %s -gjsfhar",MyString(argv[0]).basename().c_str());
		    exit(0);
		    break;
		  case 'r':
		    rotate_90 = true;
		    break;
		  case 'a':
		    show_all_screens = true;
		    break;
		  default:
		    abort_run("Unknown option -%c", c);
		    break;
		}
	    }
	}


#else
      silent = false;
      show_all_screens = false;
      full_screen = true;
#ifdef __amigaos__

      //joystick = true;
    #else
      // NDS mode

      joystick = true;
      rotate_90 = true;
      invincible = false;
      #endif

#endif

      int sw = SCREEN_WIDTH;
      if (show_all_screens)
	{
	  full_screen = false;
	  sw *= 3;
	}
      int sh = SCREEN_HEIGHT;
      if (rotate_90)
	{
	  SWAP(sh,sw,int);
	}
      // create global variable pool (MPDomain)

      Cross system_stub;

      screen = system_stub.init_io(silent,full_screen,sw,sh);

      if (!full_screen)
	{
	  SDL_WM_SetCaption("Bagman Remake v1.3 by JOTD in 2015-2020","bagman");
	}

      debug("init video complete");

      OptionsBase options_menu;
      GfxPalette palette(rotate_90);

      MPDomain domain(silent,show_all_screens,rotate_90,full_screen,invincible,&system_stub,&palette,&options_menu);


      // TEMP for test
      #ifdef R__amigaos
      Drawable sc;
      sc.init(screen);
      debug("draw to screen");
      //domain.sound_set.load_ingame_sounds();
      //domain.sound_set.play_music("");


      //domain.sound_set.play(SoundSet::ethopla);


      ImageFrame img;
      MyString image_dir = DirectoryBase::get_images_path();
      MyString n = image_dir / "playfield_1"+DirectoryBase::get_images_extension();
      debug("loading %s",n);
      img.load(n);
      ImageFrame ply;
      Fonts darker_font,dark_font,light_font;

      img.render(sc,0,0);

      darker_font.load("fonts_darker_blue");
      dark_font.load("fonts_dark_blue");
      light_font.load("fonts_light_blue");

      int nb_lives = 7;
      int x_life = 0;
      int y_life = 0;

      for (int i = 0; i < nb_lives; i++)
	{
	  palette.life.render(sc,x_life,y_life);
	  x_life+=8;
	}
      SDLRectangle lerase(x_life,y_life,8,8);
      //sc.fill_rect(&lerase,0);

      /*palette.life.render(sc,0,0);
	palette.life.render(sc,8,0);
	palette.life.render(sc,16,0);
	palette.life.render(sc,15,16);*/
      auto &va_logo = palette.va_logo;

      /*  va_logo.render(sc,65,20,-1,10);
	  SDL_Rect src_clip,dst_clip;
	  src_clip.x = 0;src_clip.y = 8;src_clip.w = va_logo.get_w();src_clip.h=100;
	  dst_clip.x = 72;dst_clip.y = 40;

	  va_logo.render(sc,&src_clip,&dst_clip);
	  auto &title = palette.title;


	  title.render(sc,64,80);
	  dst_clip.x = 64; dst_clip.y = 120;
	  src_clip.x = 32;
	  src_clip.y = 0;
	  src_clip.w = title.get_w()-32;
	  src_clip.h = 20;

	  title.render(sc,&src_clip,&dst_clip);*/

      // negative clipping (y)
      // va_logo.render(sc,50,-10);

      //palette.player.right.get_first_frame().render(sc,0,160);
      palette.player.right.get_first_frame().render(sc,0,30);
      palette.player.left.get_first_frame().render(sc,0,50);
      palette.player.left.get_first_frame().render(sc,66,50);
      palette.player.left.get_first_frame().render(sc,-14,70);
      palette.player.left.get_first_frame().render(sc,-2,90);
      palette.player.left.get_first_frame().render(sc,-8,110);
      //  va_logo.render(sc,0,0);
      va_logo.render(sc,-2,130);
      va_logo.render(sc,-4,160);
      va_logo.render(sc,-14,190);

      //SDLRectangle lerase(150,10,20,20);

      //sc.fill_rect(&lerase,0);


      /* ImageFrame z;
	 z.create(palette.title.get_w(),palette.title.get_h());
	 palette.title.render_mirror(z);

	 z.render(sc,28,170);*/


      debug("PRINT TO SCREEN");
      /*   light_font.write(sc,11,10,"HELLO LES POULEX");
	   darker_font.write(sc,8,50,"QUELLE ZONE");



	   SDLRectangle redraw(16,0,16*5,100);
	   img.render(sc,&redraw,&redraw);
	   SDLRectangle redraw2(48,80,16*5,140);
	   img.render(sc,&redraw2,&redraw2);

       */


      SDL_Flip(screen);

      debug("DONE draw to screen test");
      for(;;)
	{
	  light_font.write(sc,10,10,MyString(SDL_GetTicks()));
	  SDL_Flip(screen);
	}
      #endif






      //direct_game = true;

      if (direct_game)
	{
	  m_context = MPLevel::create(&domain);
	}
      else
	{
	  LOGGED_NEW(m_context,MenuScreen(&domain));
	}


      m_context->init(screen);
   #ifdef __amigaos__

      // maybe we should keep the timer just to count the ticks
      // and check for VBL interrupt here, so we can adjust update rate automatically


      m_old_ticks = SDL_GetTicks();
      ULONG new_ticks;
      ULONG delta_tick = 20;

 #ifdef USE_EXCEPTIONS
      try
      #endif
      {
	while(true)
	  {
	    meta_keys();
	    video_update(delta_tick);
	    new_ticks = SDL_GetTicks();
	    // issue: if game runs during several months, SDL_GetTicks() will wrap
	    // and the result will be a HUGE delta_tick. not sure what will happen then :)
	    delta_tick = new_ticks - m_old_ticks;
	    m_old_ticks = new_ticks;

	  }
      }
      #ifdef USE_EXCEPTIONS
      catch (const std::exception &e)
      {
	// note: that doesn't work
	Drawable sc;
	Fonts darker_font;
	sc.init(screen);
	darker_font.load("fonts_darker_blue");

	darker_font.write(sc,0,0,"FATAL ERROR");
	int len = strlen(e.what());
	const char *w = e.what();
	char s[2] = {0};
	int xpos = 0;
	int ypos = 10;
	for (int i=0;i<len;i++)
	  {
	    char c = *(w++);
	    if (islower(c))
	      {
		c = toupper(c);
	      }
	    else if (!isalpha(c))
	      {
		c = ' ';
	      }
	    s[0] = c;
	    darker_font.write(sc,xpos,ypos,s);
	    xpos += 8;
	    if (xpos > 300)
	      {
		xpos = 0;
		ypos += 10;
	      }

	  }



	SDL_Flip(screen);
	strcpy((char*)0x100,w);  // last chance...
	for(;;);
      }


      #endif

      #endif
      // on nintendo DS, as interrupt system doesn't work, we use a controlled timed loop
      // it also works on Windows, but not on amiga because SDL_GetTicks() depends on VBL
      // so for Windows & amiga we'll use the timer method, when on NDS we use the controlled loop
      #ifdef _NDS
#ifdef _AMIGA
      int update_rate = 25;
#else
#ifdef _NDS
      int update_rate = 20;  // 10 is too fast for the DS, 30 would be too jerky
#else
      int update_rate = 15;  // PC
#endif
#endif
      int catchup_limit = -100;

      int next_update_time = SDL_GetTicks();

      //int count=20;

      while (active)
	{
	  Uint32 current_time = SDL_GetTicks();
	  int delta = next_update_time - current_time;



	  if (delta <= 0)
	    {


	      // time to update
	      video_update(update_rate);

	      // case where a load took some time: avoid that the engine tries to "catch up"
	      if (delta < catchup_limit)
		{
		  next_update_time = current_time + update_rate;
		}
	      else
		{
		  // postpone next update time
		  next_update_time += update_rate;
		}
	    }
	  else
	    {
	      // time to wait
	      GsTime::wait(delta);
	    }




	}
      #else


      timer_init();
      while(true)
	{

	  SDL_Delay(100);  // lower this
	  meta_keys();
	}


      #endif

      LOGGED_DELETE(domain.player);
      //MemoryEntryMap::instance().dump_allocated();
    }
     #ifdef USE_EXCEPTIONS
    catch (const Cause &c)
    {
      error(c,false);
    }
    #endif
    Cross::close();

  }


  void meta_keys()
  {
    #ifndef _NDS
    SDL_Event evt;
    if (SDL_PollEvent(&evt))
      {



	switch (evt.type)
	  {
	    case SDL_QUIT:

	      shutdown();
	      break;

	    case SDL_KEYDOWN:
	      if (evt.key.keysym.sym == SDLK_F1)
		{
		  create_snapshot();
		}
	      /*else if (evt.key.keysym.sym == SDLK_F10)
		{
		exit = ESC in the menu
		  shutdown();
		}*/
	      else if (evt.key.keysym.sym == SDLK_ESCAPE)
		{
		  auto *level = dynamic_cast<MPLevel *>(m_context);
		  if (level != nullptr)
		    {
		      level->game_over();
		    }

		}
	      else if (evt.key.keysym.sym == SDLK_p)
		{
		  auto *level = dynamic_cast<MPLevel *>(m_context);
		  // pause only works while during the game
		  if (level != nullptr)
		    {
		      // pause
		      while (true)
			{
			  SDL_WaitEvent(&evt);
			  if ((evt.type==SDL_KEYDOWN) and (evt.key.keysym.sym == SDLK_p))
			    {
			      // update old ticks so game doesn't go berzerk after resuming pause
			      m_old_ticks = SDL_GetTicks();
			      break;
			    }
			}
		    }
		}
	  }
      }
 	#endif
  }
  unsigned long m_old_ticks;

};


int main(int argc, char * const *argv)
{
  LOGGED_MEMORY_START;  // enables memory logging now that all the static data has been allocated

  Cross c;
  c.init_console();

  MainClass(argc,argv);
  return 0;
}
