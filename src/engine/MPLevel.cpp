#include "MPLevel.hpp"
#include "PrmIo.hpp"
#include "DirectoryBase.hpp"
#include "AnimatedSprite.hpp"
#include "Fonts.hpp"
#include "Player.hpp"
#include "SoundSet.hpp"
#include "GfxObjectLayer.hpp"
#include "MPDomain.hpp"
#include "Wagon.hpp"
#include "Elevator.hpp"
#include "Guard.hpp"
#include "MenuScreen.hpp"
#include "GsMaths.hpp"
#include "RandomNumber.hpp"

// uncomment this to kill all guards and only update player
//#define PLAYER_ALONE

enum CharacterStartPosSettings { CSP_NORMAL,                // 0
  CSP_PICK_BREAKS_WALL,      // 1
  CSP_BAG_ON_SLOPE,          // 2
  CSP_ELEVATORS_SCREEN_2,    // 3
  CSP_ELEVATORS_SCREEN_3,    // 4
  CSP_BARROW_KILL,           // 5
  CSP_GUARD_SLOPE_TURN,      // 6
  CSP_ELEVATORS_OUT_SCREEN_2,// 7
  CSP_GUARD_WALK_CLIMB_BRANCH, // 8
  CSP_GUARD_LADDER_TOP,             // 9
  CSP_GUARD_ELEVATORS_TOP_SCREEN_3, // 10
  CSP_GUARD_ELEVATORS_CHEAT         // 11
};



static const CharacterStartPosSettings CURRENT_CSP = CSP_NORMAL;

#ifdef _NDS
#define X_TRANSLATION -24  // eats the borders but still playable
#else

#define X_TRANSLATION -16
#endif

#ifdef __amigaos__
// no fade
static const int FADE_TIME = 0;
#else
static const int FADE_TIME = 200;
#endif

static const int NB_GUARDS = 2;
static const int NB_ELEVATORS = 2;
static const int NB_WAGONS = 3;

void MPLevel::add_character_positions(int px,int py,int pcs,HumanCharacter::FullDirection pd,
				      int g1x,int g1y,int g1cs,HumanCharacter::FullDirection g1d,
				      int g2x,int g2y,int g2cs,HumanCharacter::FullDirection g2d)
{
  CharacterStartPosSet cps;
  cps.player.init(px,py,pcs,pd);
  cps.guard[0].init(g1x,g1y,g1cs,g1d);
  cps.guard[1].init(g2x,g2y,g2cs,g2d);

  m_character_position_settings.push_back(cps);
}

MPLevel *MPLevel::create(MPDomain *domain)
{
  //const OptionsBase &opts = domain->menu_options;
  MPLevel *rval;
  LOGGED_NEW(rval,MPLevel());

  rval->m_domain = domain;
  rval->m_player = domain->player;
  rval->m_sound_set = &domain->sound_set;

  return rval;
}

void MPLevel::insert_object(GfxObject *o)
{
  m_object_layer[m_player->get_current_screen()].add(o);

}

void MPLevel::handle_guard_bag_collisions()
{
  for (int i = 0; i < NB_GUARDS; i++)
    {
      Guard &g = m_guards[i];
      if (g.get_life_state() == HumanCharacter::ALIVE and g.get_state() != HumanCharacter::STATE_IN_AIR)
	{
	  const GfxObjectLayer &ol = m_object_layer[g.get_current_screen()];

	  const GfxObjectLayer::List &items = ol.get_items();
	  const SDLRectangle &gb = g.get_bounds();

	  for (auto ob : items) // GfxObject *
	    {
	      if (ob->is_moving() && ob->get_bounds().intersects(gb))
		{
		  if (g.get_state() == HumanCharacter::STATE_CLIMB)
		    {
		      // gets hit from a falling bag while on the ladder: fall (then kill)
		      g.fall_from_ladder();
		    }
		  else
		    {
		      // gets hit by a falling bag while not on the ladder: direct kill
		      // I have added an extra check to avoid that the y-1 trick to properly
		      // detect slopes kills the guard when chasing player on a plane surface
		      if (m_player->get_y() < g.get_y())
			{
			  g.kill();
			}
		    }
		}
	    }
	}
    }
}
MPLevel::MPLevel()
{
  m_player = 0;
  m_domain = 0;
  m_sound_set = 0;
  m_palette = 0;
  m_grid = 0;
  m_first_level = true;
  m_last_rendered_screen = -1;
  m_level_end_fadeout = false;
  #ifdef PARTIAL_REFRESH
  m_redraw_bounds.resize(8); // 8 redraw zones are enough
  #endif


}
MPLevel::~MPLevel()
{

}

void MPLevel::bag_in_barrow(bool blue_bag)
{
  m_sound_set->play(SoundSet::reward);

  // award bonus

  if (blue_bag)
    {
      m_bonus_value *= 2;
    }
  if (is_trainer_mode())
    {
      m_player->add_score(m_bonus_value*20);
    }
  else
    {
      m_player->add_score(m_bonus_value*100);
    }

  // reset timer
  m_bonus_value = get_max_bonus_value();
  m_bonus_timer = 0;

  if (get_nb_bags() == 0)
    {
      level_end();
    }


}

int MPLevel::get_nb_bags() const
{

  int nb_bags = 0;
  // how many bags are left
  for (int i = 0; i < 3; i++)
    {
      const GfxObjectLayer &ol = m_object_layer[i];
      nb_bags += ol.get_nb_bags();
    }
  return nb_bags;
}

const PlayerControls::Status &MPLevel::get_player_input()
{
  return m_state == LEVEL_END ? m_to_right_input : m_input;
}

void MPLevel::level_end()

{
  m_state = LEVEL_END;
  m_first_level = is_trainer_mode(); // change bag layout if not in "trainer" mode

  m_player->set_level_end();
  // remove characters from list to render only player & elevators
  for (int i = 0; i < NB_WAGONS; i++)
    {
      m_wagons[i].stand_by();
    }
  for (int i = 0; i < NB_GUARDS; i++)
    {
      m_guards[i].stand_by();
    }
}
GameContext *MPLevel::update_level_end(int elapsed_time)
{
  GameContext *rval = 0;

  if (!m_level_end_fadeout)
    {
      update_characters(elapsed_time);
    }
  // exit from current screen
  if ((m_player->get_x()-0x10) % 224 > 221)
    {
      if (!m_level_end_fadeout)
	{
	  m_level_end_fadeout = true;
	  m_fadeout_event.init(0,FADE_TIME);
	  add_timer_event(m_fadeout_event);
	}
      if (m_fadeout_event.is_timeout_reached())
	{
	  // next level
	  init_new_level();
	}
    }
  return rval;
}

void MPLevel::update_pickaxes()
{
  static const int pick_locations_01[] =
  {
   144+16+3,192,GfxObject::PICK,
   152+16+3,64,GfxObject::PICK,
   -1
  };
  static const int pick_locations_11[] =
  {
   48+16+3,136,GfxObject::PICK,
   176+16+3,16,GfxObject::PICK,
   -1
  };
  static const int pick_locations_21[] =
  {
   80+16+3,168,GfxObject::PICK,
   -1
  };
  PointerVector<GfxObjectLayer,true>::iterator it;
  FOREACH(it,m_object_layer)
  {
    GfxObjectLayer &ob = *(*it);
    ob.remove_picks();
  }
  insert_objects(pick_locations_01,0);
  insert_objects(pick_locations_11,1);
  insert_objects(pick_locations_21,2);
}

void MPLevel::create_objects(const int *data, int current_screen)
{
  GfxObjectLayer *ol;
  LOGGED_NEW(ol,GfxObjectLayer());
  m_object_layer.push_back(ol);

  insert_objects(data,current_screen);
}

void MPLevel::insert_objects(const int *data, int current_screen)
{
  int i = 0;
  GfxObject *o;
  GfxObjectLayer &ol = m_object_layer[current_screen];

  while(data[i] != -1)
    {
      int x = data[i]+current_screen * 224;
      int y = data[i+1];
      GfxObject::Type objtype = (GfxObject::Type)data[i+2];

      const GfxFrameSet *gfs = 0;
      switch (objtype)
	{
	  case GfxObject::YELLOW_BAG:
	    gfs = &m_palette->yellow_bag;
	    break;
	  case GfxObject::BLUE_BAG:
	    gfs = &m_palette->blue_bag;
	    break;
	  case GfxObject::BARROW:
	    gfs = &m_palette->barrow;
	    break;
	  case GfxObject::PICK:
	    gfs = &m_palette->pickaxe;
	    break;
	  default:
	    my_assert(1==0);
	    break;

	}
      LOGGED_NEW(o,GfxObject(gfs,this,objtype));
      o->set_x(x);
      o->set_y(y);
      ol.add(o);
      i+=3;
    }

}


void MPLevel::break_wall()
{
  m_nb_pick_blows++;

  if (m_nb_pick_blows > 4)
    {
      m_grid->break_wall();
    }
}


void MPLevel::private_init()
{

  // characters position presets

  add_character_positions(0x29,0xE0,0,HumanCharacter::FD_RIGHT,0xB0,0x10,0,
			  HumanCharacter::FD_LEFT,0xD0,0x10,2,HumanCharacter::FD_RIGHT);   // CSP_NORMAL
  add_character_positions(290,136,0,HumanCharacter::FD_RIGHT,0xB0,0x10,0,
			  HumanCharacter::FD_LEFT,0xD0,0x10,2,HumanCharacter::FD_LEFT); // CSP_PICK_BREAKS_WALL
  add_character_positions(162,144,0,HumanCharacter::FD_RIGHT,0xB0,0x10,0,
			  HumanCharacter::FD_LEFT,0xD0,0x10,2,HumanCharacter::FD_LEFT); // CSP_BAG_ON_SLOPE
  add_character_positions(362+50,16,0,HumanCharacter::FD_RIGHT,0xB0,0x10,0,
			  HumanCharacter::FD_RIGHT,0xD0,0x10,2,HumanCharacter::FD_LEFT);  // CSP_ELEVATORS_SCREEN_2
  add_character_positions(224*2+150,16,0,HumanCharacter::FD_RIGHT,0xB0,0x10,0,
			  HumanCharacter::FD_LEFT,0x50,201,2,HumanCharacter::FD_LEFT); // CSP_ELEVATORS_SCREEN_3
  add_character_positions(61,16,0,HumanCharacter::FD_RIGHT,61,224,0,
			  HumanCharacter::FD_LEFT,0x50,201,2,HumanCharacter::FD_LEFT); // CSP_BARROW_KILL
  add_character_positions(115,146,0,HumanCharacter::FD_RIGHT,109,99,0,
			  HumanCharacter::FD_RIGHT,0x50,201,2,HumanCharacter::FD_LEFT); // CSP_GUARD_SLOPE_TURN
  add_character_positions(303,96,0,HumanCharacter::FD_RIGHT,341,64,0,
			  HumanCharacter::FD_RIGHT,0x50,201,2,HumanCharacter::FD_LEFT); // CSP_ELEVATORS_OUT_SCREEN_2
  add_character_positions(303,96,0,HumanCharacter::FD_RIGHT,194,192,0,
			  HumanCharacter::FD_LEFT,209,200,1,HumanCharacter::FD_LEFT); // CSP_GUARD_WALK_CLIMB_BRANCH
  add_character_positions(32,176,0,HumanCharacter::FD_RIGHT,62,70,0,
			  HumanCharacter::FD_UP,0xD0,0x10,2,HumanCharacter::FD_LEFT); // CSP_GUARD_WALK_CLIMB_BRANCH
  add_character_positions(224*2+150,16,0,HumanCharacter::FD_RIGHT,0xB0,0x10,0,
			  HumanCharacter::FD_LEFT,535,40,0,HumanCharacter::FD_LEFT); // CSP_ELEVATORS_TOP_SCREEN_3
  add_character_positions(224*2+32,16,0,HumanCharacter::FD_RIGHT,0xB0,0x10,0,
			  HumanCharacter::FD_LEFT,0x50,201,2,HumanCharacter::FD_LEFT); // CSP_GUARD_ELEVATORS_CHEAT


  m_to_right_input.right.pressed(true); // fake input to flee right when all bags have been collected

  m_palette = &(m_domain->get_palette());
  LOGGED_NEW(m_grid,TileGrid(m_palette));

  for (int i = 0; i < NB_GUARDS; i++)
    {
      Guard *g;
      LOGGED_NEW(g,Guard(m_domain->get_menu_options().get_skill_level()));
      m_guards.push_back(g);
      m_character_list.push_back(g);
      g->init(this);
    }



  for (int i = 0; i < NB_WAGONS; i++)
    {
      Wagon *w;
      LOGGED_NEW(w,Wagon());

      m_wagons.push_back(w);
      m_character_list.push_back(w);
    }
  /* start_screen start_x, start_y, min_x, max_x, min_screen, max_screen */

  m_wagons[0].init(this,0x10+16,0xD0,0,1);
  m_wagons[1].init(this,60+16,120+16,0,1);
  m_wagons[2].init(this,184+16,0xC4+16,1,2);

  m_player->init(this);
  m_sound_set->load_ingame_sounds();


  for (int i = 0; i < NB_ELEVATORS; i++)
    {
      Elevator *e;
      LOGGED_NEW(e,Elevator());
      m_elevators.push_back(e);
      m_character_list.push_back(e);
    }
  MyVector<int> red_stops;
  // y values were ripped from resourced original arcade game
  red_stops.push_back(0x42);
  red_stops.push_back(0x6A);
  m_elevators[0].init(this,&m_palette->elevator_red,0x11,0x89,red_stops,true,false);

  MyVector<int> orange_stops;
  orange_stops.push_back(0xAA);
  orange_stops.push_back(0x8A);
  orange_stops.push_back(0x72);
  orange_stops.push_back(0x2A);
  m_elevators[1].init(this,&m_palette->elevator_orange,0x11,0xC9,orange_stops,true,false);

  m_character_list.push_back(m_player);

  init_new_level();

}

void MPLevel::init_new_level()
{

  // ripped from screenshots with grid mode + 16 x added
  static const int bag_locations_01[] =
  {
   112+16,16,GfxObject::BARROW,
   160+16+6,144,GfxObject::YELLOW_BAG,
   120+16+6,64,GfxObject::YELLOW_BAG,
   24+16+6,112,GfxObject::YELLOW_BAG,
   24+16+6,176,GfxObject::YELLOW_BAG,
   192+16+6,192,GfxObject::YELLOW_BAG,
   -1
  };
  static const int bag_locations_11[] =
  {
   112+16+6,64,GfxObject::YELLOW_BAG,
   176+16+6,80,GfxObject::YELLOW_BAG,
   176+16+6,104,GfxObject::YELLOW_BAG,
   192+16+6,136,GfxObject::YELLOW_BAG,
   192+16+6,224,GfxObject::YELLOW_BAG,
   80+16+6,96,GfxObject::YELLOW_BAG,
   16+16+6,192,GfxObject::BLUE_BAG,
   -1
  };
  static const int bag_locations_21[] =
  {
   200+16+6,16,GfxObject::YELLOW_BAG,
   136+16+6,40,GfxObject::YELLOW_BAG,
   136+16+6,72,GfxObject::YELLOW_BAG,
   96+16+6,168,GfxObject::YELLOW_BAG,
   64+16+6,200,GfxObject::YELLOW_BAG,
   152+16+6,200,GfxObject::YELLOW_BAG,
   -1
  };

  static const int bag_locations_02[] =
  {
   112+16,16,GfxObject::BARROW,
   200+16+6,136,GfxObject::YELLOW_BAG,
   112+16+6,224,GfxObject::YELLOW_BAG,
   120+16+6,64,GfxObject::YELLOW_BAG,
   160+16+6,144,GfxObject::YELLOW_BAG,
   24+16+6,176,GfxObject::YELLOW_BAG,
   192+16+6,192,GfxObject::YELLOW_BAG,-1
  };
  // same as first level, with just one bag less
  static const int bag_locations_12[] =
  {
   176+16+6,80,GfxObject::YELLOW_BAG,
   176+16+6,104,GfxObject::YELLOW_BAG,
   192+16+6,136,GfxObject::YELLOW_BAG,
   192+16+6,224,GfxObject::YELLOW_BAG,
   80+16+6,96,GfxObject::YELLOW_BAG,
   16+16+6,192,GfxObject::BLUE_BAG,
   -1

  };
  static const int bag_locations_22[] =
  {
   8+16+6,136,GfxObject::YELLOW_BAG,
   96+16+6,168,GfxObject::YELLOW_BAG,
   112+16+6,72,GfxObject::YELLOW_BAG,
   64+16+6,200,GfxObject::YELLOW_BAG,
   168+16+6,200,GfxObject::YELLOW_BAG,
   64+16+6,40,GfxObject::YELLOW_BAG,
   -1
  };

  m_state = RUNNING;

  // restore character list
  // insert bags
  m_nb_pick_blows = 0;


  m_object_layer.clear();

  if (m_first_level)
    {
      create_objects(bag_locations_01,0);
      create_objects(bag_locations_11,1);
      create_objects(bag_locations_21,2);
    }
  else
    {
      // 2nd -> infinity level layouts are identical
      create_objects(bag_locations_02,0);
      create_objects(bag_locations_12,1);
      create_objects(bag_locations_22,2);

    }

  m_grid->build_wall();

  update_pickaxes();

  restart();


  switch (CURRENT_CSP)
    {
      case CSP_BARROW_KILL:
	{
	  get_barrow()->add_x(-40);
	  break;
	}
      case CSP_ELEVATORS_SCREEN_3:
	{
	  GfxObject *g = get_barrow();
	  m_object_layer[0].get_items().remove(g,false);
	  g->add_x(224*2);
	  insert_object(g);
	  break;

	}
      default:
	break;
    }

}
const Elevator *MPLevel::get_elevator(int current_screen) const
{
  return current_screen == 0 ? 0 : &m_elevators[current_screen-1];
}

Elevator *MPLevel::get_elevator(int current_screen)
{
  return current_screen == 0 ? 0 : &m_elevators[current_screen-1];
}

bool MPLevel::is_trainer_mode() const
{
  return (m_domain->get_menu_options().get_skill_level()==OptionsBase::TRAINER);
}

int MPLevel::get_max_bonus_value() const
{
  // trainer: max bonus = 7000 else 4000
  return is_trainer_mode() ? 70 : 40;
}

void MPLevel::stop_music()
{
  m_domain->sound_set.stop_music();
}
void MPLevel::restart()
{
  stop_music();
  m_first_update = true;

  // remove all moving objects
  for (size_t i = 0; i < m_object_layer.size();i++)
    {
      m_object_layer[i].remove_moving_objects(); // only bags
    }

  m_fadein_event.init(0,FADE_TIME);
  add_timer_event(m_fadein_event);

  m_gameover_fadeout = false;
  m_dead_fadeout = false;
  m_bonus_value = get_max_bonus_value();
  m_bonus_timer = 0;
  m_player_dead_time = 0;
  m_move_sound_timer = 0;

  m_elevators[0].level_init(136+16,0x89,1);
  m_elevators[1].level_init(32+16,0xC9,2);


  m_wagons[0].level_init(0x5F,0xE1,1);
  m_wagons[1].level_init(0x35,0x41,1);
  m_wagons[2].level_init(0x5F,0xC9,2);

  update_pickaxes();

  const CharacterStartPosSet &csps = m_character_position_settings[CURRENT_CSP];

  for (int i = 0; i < NB_GUARDS; i++)
    {
      m_guards[i].level_init(csps.guard[i].x,csps.guard[i].y,csps.guard[i].current_screen,csps.guard[i].d);
    }

  m_player->level_init(csps.player.x,csps.player.y,csps.player.current_screen,csps.player.d);

  if (CURRENT_CSP == CSP_BARROW_KILL)
    {
      static const int pick_locations_test[] =
      {
       40+16+3,16,GfxObject::PICK,
       -1
      };
      insert_objects(pick_locations_test,0);
    }

}
const GfxPalette &MPLevel::get_palette() const
{

  return m_domain->get_palette();
}

void MPLevel::load_sound(SoundSet::SoundId sid)
{
  m_domain->sound_set.load_sound(sid);
}

void MPLevel::unload_sound(SoundSet::SoundId sid)
{
  m_domain->sound_set.get_player().unload(sid);
}




const GfxObject *MPLevel::get_barrow() const
{
  const GfxObject *rval = 0;

  for (int i = 0; i < 3; i++)
    {
      rval = m_object_layer[i].get_barrow();
      if (rval != 0)
	{
	  break;
	}
    }
  return rval;
}

GfxObject *MPLevel::get_barrow()
{
  GfxObject *rval = 0;

  for (int i = 0; i < 3; i++)
    {
      rval = m_object_layer[i].get_barrow();
      if (rval != 0)
	{
	  break;
	}
    }
  return rval;
}
#ifdef PARTIAL_REFRESH
void MPLevel::restore_background()
{

  int cs = m_player->get_current_screen();
  for (int i = 0; i < m_nb_draw_bounds; i++)
    {
      auto &bounds = m_redraw_bounds[i];

      m_grid->render(m_screen, cs, bounds);

    }
  m_nb_draw_bounds = 0;
}

void MPLevel::store_current_positions()
{
  // store current character/wagon/elevator/moving bag positions
  m_nb_draw_bounds = 0;
  int cs = m_player->get_current_screen();
  // characters / wagons / elevators

  for (const Character *c : m_character_list)

    {
      #ifdef PLAYER_ALONE
      if ((c== &m_guards[0]) or (c==&m_guards[1])) continue;
      #endif


      bool is_player = c==m_player;
      auto &bref = c->get_bounds();
      if (is_player and (m_player->get_state()==HumanCharacter::STATE_IN_WAGON or
			 m_player->get_state()==HumanCharacter::STATE_IN_MOVING_ELEVATOR))
	{
	  // do nothing: zones are already drawn by elevator/wagon
	}

      else
	{
	  if (is_player or (!c->is_stand_by() and c->is_in_screen(cs)))
	    {

	      // when it's player, only draw zone if player is moving when in walk/climb state
	      if (not is_player or
		  ((m_player->get_state() != HumanCharacter::STATE_WALK and m_player->get_state() != HumanCharacter::STATE_CLIMB) or
		   bref.x != m_player_last_x or bref.y != m_player_last_y))
		{
		  auto &bounds = m_redraw_bounds[m_nb_draw_bounds++];
		  bounds = bref;

		  int maskx = bounds.x & 0xFF0;
		  if (maskx == bounds.x)
		    {
		      bounds.x -= 0x10;
		      bounds.w += 0x20;
		    }
		  else
		    {
		      bounds.x = maskx;
		      bounds.w += 0x30;
		    }
		  bounds.w &= 0xFF0;
		  bounds.x -= 0x10 + 224*cs;

		  bounds.y -= 18;
		  bounds.h += 12;
		}
	    }

	  if (is_player)
	    {
	      m_player_last_x = bref.x;
	      m_player_last_y = bref.y;
	    }
	}


    }

  // moving bag
  const GfxObjectLayer &ol = m_object_layer[cs];
  const GfxObjectLayer::List &items = ol.get_items();

  for (auto ob : items) // GfxObject *
    {
      if (ob->is_moving())
	{
	  auto &bref = ob->get_bounds();
	  auto &bounds = m_redraw_bounds[m_nb_draw_bounds++];
	  bounds = bref;

	  int maskx = bounds.x & 0xFF0;
	  if (maskx == bounds.x)
	    {
	      bounds.x -= 0x10;
	      bounds.w += 0x20;
	    }
	  else
	    {
	      bounds.x = maskx;
	      bounds.w += 0x20;
	    }
	  bounds.w &= 0xFF0;
	  bounds.x -= 0x10 + 224*cs;

	  bounds.y -= 18;
	  bounds.h += 12;
	}

    }


}
#endif

void MPLevel::empty_wagons()
{
  // when killing player, wagons won't be updated hence the call to the method
  // to empty them (in case player dies because of timer while in the wagon)
  for (int i = 0; i < NB_WAGONS; i++)
    {
      m_wagons[i].empty();
    }

}
GameContext *MPLevel::update_running(int elapsed_time)
{
  GameContext *rval = 0;
  ENTRYPOINT(update_running);

  m_bonus_timer += elapsed_time;

  while (m_bonus_timer > 1650) // 66 seconds for counting down from 4000 to 0
    {
      m_bonus_timer -= 1650;
      m_bonus_value--;
      if (m_bonus_value == 0)
	{
	  m_player->kill();
	}
      else if (m_bonus_value < 0)
	{
	  m_bonus_value = 99; // like the original game

	}
      else if (m_bonus_value < 5)
	{
	  stop_music();
	  m_domain->sound_set.play(SoundSet::timewarn);
	}

    }

  #ifdef PARTIAL_REFRESH
  store_current_positions();

  #endif

  handle_guard_bag_collisions();

  switch (m_player->get_life_state())
    {
      case HumanCharacter::DYING:
	m_player->update(elapsed_time); // only update player, stop all others
	break;
      case HumanCharacter::ALIVE:

	{
	  m_move_sound_timer += elapsed_time;

	  if  (m_move_sound_timer > 380)
	    {
	      m_move_sound_timer -= 380;

	      // priority to guard #2

	      if (m_guards[1].get_life_state() == HumanCharacter::ALIVE)
		{
		  m_guards[1].play_move_sound();
		}
	      else if (m_guards[0].get_life_state() == HumanCharacter::ALIVE)
		{
		  m_guards[0].play_move_sound();
		}

	      m_player->play_move_sound();
	      m_player->play_pick_sound();
	    }
	  // bag gravity
	  for (int i = 0; i < 3; i++)
	    {
	      m_object_layer[i].update(elapsed_time);
	    }

	  int prev_screen = m_player->get_current_screen();
	  update_characters(elapsed_time);
	  int current_screen = m_player->get_current_screen();
	  if ((prev_screen!=current_screen) || m_first_update)
	    {
	      m_first_update = false;
	      if ((current_screen==0 || current_screen==2)) // && RandomNumber::rand(2)==0)
		{
		  MyString track_name = DirectoryBase::get_sound_path() / "track" + MyString(current_screen+1)+".mp3";
		  m_domain->sound_set.play_music(track_name);
		}
	    }
	  // dirty shortcut to check if changes from screen 1 to 2 or 2 to 1
	  if (prev_screen + current_screen == 3)
	    {
	      if ((prev_screen == 1) && (current_screen == 2))
		{
		  // copy move state from elevator 0 to 1
		  m_elevators[0].copy_move_state_to(m_elevators[1]);
		}
	      else
		{
		  // copy move state from elevator 1 to 0
		  m_elevators[1].copy_move_state_to(m_elevators[0]);

		}
	    }
	  if (m_input.esc_pressed)
	    {
	      m_state = QUIT_GAME;
	      m_fadeout_event.init(0,FADE_TIME);
	      add_timer_event(m_fadeout_event);
	    }
#ifndef NDEBUG
	  if (m_input.t_pressed)
	    {
	      m_bonus_value = 5;
	    }
	  if (m_input.e_pressed)
	    {
	      level_end();
	    }
#endif
	}
	break;
      case HumanCharacter::DEAD:
	{
	  stop_music();
	  m_player->update(elapsed_time);
	  m_player_dead_time += elapsed_time;
	  if (m_player_dead_time > 2000)
	    {
	      if (m_player->get_nb_lives() >= 0)
		{

		  if (!m_dead_fadeout)
		    {
		      m_dead_fadeout = true;
		      m_fadeout_event.init(0,FADE_TIME);
		      add_timer_event(m_fadeout_event);
		    }

		}
	      else

		{
		  m_game_over_timer = 3000;
		  m_state = GAME_OVER;
		}

	    }
	}
	break;
    }


  EXITPOINT;

  return rval;
}

void MPLevel::update_characters(int elapsed_time)
{
  PointerList<Character>::iterator it;

  #ifdef PLAYER_ALONE
  // debug mode
  for (int i=0; i < NB_GUARDS; i++)
    {
      m_guards[i].set_life_state(HumanCharacter::DEAD);

    }
  m_player->update(elapsed_time);


  #else
  // normal game mode
  for(auto it : m_character_list)
    {
      Character &c = (*it);
      if (!c.is_stand_by())
	{
	  c.update(elapsed_time);
	}
    }
  #endif

}
GameContext *MPLevel::private_update(int elapsed_time)
{
  GameContext *rval = 0;

  switch (m_state)
    {
      case QUIT_GAME:
	// trying to quit

	if (!m_fadeout_event.is_timeout_reached())
	  {
	    render_all_layers();
	  }
	else
	  {
	    stop_music();
	  }
	break;
      case LEVEL_END:
	stop_music();
	render_all_layers();
	rval = update_level_end(elapsed_time);

	break;
      case GAME_OVER:

	m_game_over_timer -= elapsed_time;
	render_all_layers();
	if ((m_game_over_timer <= 0) && !m_gameover_fadeout)
	  {
	    m_gameover_fadeout = true;
	    m_fadeout_event.init(0,500);
	    add_timer_event(m_fadeout_event);
	  }
	break;
      default:
	render_all_layers();
	if (!m_fadein_event.is_running())
	  {
	    rval = update_running(elapsed_time);
	  }


	break;
    }

  if (m_dead_fadeout && m_fadeout_event.is_timeout_reached())
    {
      if (m_state == RUNNING)
	{
	  //m_screen.fill_rect(0,0);
	  if (get_nb_bags() == 0)
	    {
	      // restart new level (because player died with the last bag)
	      init_new_level();
	    }
	  else
	    {
	      // restart level
	      restart();
	    }
	}

    }

  if (m_state == RUNNING && m_level_end_fadeout && m_fadeout_event.is_timeout_reached())
    {
      stop_music();
      m_screen.fill_rect(0,0);
      m_level_end_fadeout = false;
    }
  if ((m_gameover_fadeout || m_state == QUIT_GAME) && m_fadeout_event.is_timeout_reached())
    {
      stop_music();
      m_screen.fill_rect(0,0);
      // return to menu
      LOGGED_NEW(rval,MenuScreen(m_domain));
    }

  return rval;
}


void MPLevel::pick_up_object(GfxObject *o)
{
  m_player->set_held_item(o);
  GfxObjectLayer::List &l = m_object_layer[m_player->get_current_screen()].get_items();
  unsigned int nb_items = l.size();
  l.remove(o,false);
  if (l.size() != nb_items-1)
    {
      abort_run("cannot remove item %p from screen %d. barrow = %p",o,m_player->get_current_screen(),get_barrow());
    }

  if (o->is_bag() && !m_sound_set->is_music_playing())
    {
      m_sound_set->play(SoundSet::take_bag);
    }
}



GfxObject *MPLevel::get_pickable_item()
{
  GfxObjectLayer &gfl = m_object_layer[m_player->get_current_screen()];

  return gfl.get_item_intersecting(m_player);
}

void MPLevel::render_screen_layer(int i)
{
  if (m_state != LEVEL_END)
    {
      m_object_layer[i].render(m_screen);
    }
  PointerList<Character>::const_iterator it;
  FOREACH(it,m_character_list)
  {
    const Character &c = *(*it);
          #ifdef PLAYER_ALONE
    if ((&c== &m_guards[0]) or (&c==&m_guards[1])) continue;
      #endif

    if (!c.is_stand_by() and c.is_in_screen(i))
      {
	c.render(m_screen);
      }
  }

}

bool MPLevel::all_guards_are_stunned() const
{
  bool rval = true;
  for (int i=0; i < NB_GUARDS; i++)
    {
      if (m_guards[i].get_life_state() != HumanCharacter::DEAD)
	{
	  rval = false;
	  break;
	}
    }
  return rval;
}

void MPLevel::get_elevator_contained_state(const Character &c,Elevator::CharacterContained &cc,const Elevator *&e) const
{

  for (int i = 0; i < 2; i++)
    {
      cc = m_elevators[i].get_contained_state(c);
      if (cc != Elevator::CC_OUT)
	{
	  e = &m_elevators[i];
	  break;
	}
    }
}

bool MPLevel::is_wagon_below_player() const
{
  bool rval = false;
  for (int i = 0; i < NB_WAGONS; i++)
    {
      if (m_wagons[i].collides_player())
	{
	  int dx = GsMaths::abs(m_wagons[i].get_x() - m_player->get_x());
	  rval = dx < 10;
	  break;
	}
    }
  return rval;
}

void MPLevel::render_breakable_block()
{
  int x = 56;
  if (m_domain->show_all_screens)
    {
      x += 224;

    }
  if (m_nb_pick_blows < 5)
    {
      m_palette->wall_break.get_frame(m_nb_pick_blows).render(m_screen,x,176+16);
    }
}

void MPLevel::clip_fullscreen()
{
  m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90);
  static const SDLRectangle r(224,0,24,256);

  m_screen.fill_rect(&r,0);
}

void MPLevel::render_all_layers()
{
  ENTRYPOINT(render_all_layers);


  int y_translation = 0; //-16;
#ifndef _NDS

  if (m_domain->full_screen and not m_domain->rotate_90)
    {
      y_translation = -16;
    }

#endif


  if (m_domain->show_all_screens) // only on windows
    {
      m_screen.set_affine_transformation(SCALE_SIZE,false,X_TRANSLATION,16);
      for (int i = 0; i < 3; i++)
	{
	  m_grid->render(m_screen, i, true);
	}

      m_screen.set_affine_transformation(SCALE_SIZE,false,X_TRANSLATION,0);
      for (int i = 0; i < 3; i++)
	{
	  if (i == 1)
	    {
	      render_breakable_block();
	    }

	  render_screen_layer(i);
	}
    }
  else
    {
      int cs = m_player->get_current_screen();
      m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90,X_TRANSLATION,y_translation);
      // draw background
      #ifdef PARTIAL_REFRESH
      if (cs != m_last_rendered_screen)
	{
	  m_nb_draw_bounds = 0;
	  m_last_rendered_screen = cs;
      #endif

	  m_grid->render(m_screen, cs, false);
      #ifdef PARTIAL_REFRESH
	}
      #endif


     #ifdef PARTIAL_REFRESH

      restore_background();

      #endif
      if (cs == 1)
	{
	  render_breakable_block();
	}
      m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90,X_TRANSLATION-224*cs,y_translation);
      render_screen_layer(cs);
    }

#ifdef _NDS
  render_score_and_bonus_original();
#else
  if (m_domain->full_screen && !m_domain->rotate_90)
    {
      render_score_and_bonus_right();
    }
      #ifndef __amigaos__
  else
    {
      render_score_and_bonus_original();
    }
  #endif
#endif
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
  // avoid flashing screen when losing a life
  if (m_fadeout_event.is_timeout_reached() && m_dead_fadeout)
    {
      m_screen.fill_rect(0,0);
      #ifdef PARTIAL_REFRESH
      m_last_rendered_screen = -1;
      #endif
    }


  EXITPOINT;


}

#ifdef __amigaos__
void MPLevel::render_score_and_bonus_right()
{
  if (m_domain->full_screen)
    {
      clip_fullscreen();
    }
  // render score & bonus

  m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90,0);
  if (m_state == GAME_OVER)
    {
      m_domain->darker_font.write(m_screen,80,112-16,"GAME OVER ");
    }

  m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90,224+16);

  if (m_first_update)
    {
      m_domain->dark_font.write(m_screen,0,0,"PLAYER 1");
    }
  int score = m_player->get_score();
  if (score != m_previous_score)
    {
      MyString s = score;
      s.pad('0',6,true);
      m_domain->light_font.write(m_screen,8,8,s);
      m_previous_score = score;
    }

  int bonus_y_pos = 24;
  if (m_first_update)
    {
      m_domain->dark_font.write(m_screen,0,bonus_y_pos,"BONUS");
    }

  if (m_bonus_value != m_previous_bonus_value)
    {
      MyString b = m_bonus_value;
      b.pad('0',2,true);

      m_domain->light_font.write(m_screen,8,bonus_y_pos+8,b);
      m_domain->light_font.write(m_screen,24,bonus_y_pos+8,"00");

      m_previous_bonus_value = m_bonus_value;
    }

  int nb_lives = m_player->get_nb_lives();
  int x_life = 0;
  int y_life = 48;

  for (int i = 0; i < nb_lives; i++)
    {
      m_palette->life.render(m_screen,x_life,y_life);
      x_life+=8;
    }
  SDLRectangle lerase(x_life,y_life,8,8);
  m_screen.fill_rect(&lerase,0);



}
#else

void MPLevel::render_score_and_bonus_right()
{
  if (m_domain->full_screen)
    {
      clip_fullscreen();
    }
  // render score & bonus

  m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90,0);
  if (m_state == GAME_OVER)
    {
      m_domain->darker_font.write(m_screen,80,112-16,"GAME OVER ");
    }

  m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90,224);


  m_domain->dark_font.write(m_screen,0,0,"PLAYER 1");

  MyString s = m_player->get_score();
  s.pad('0',6,true);
  m_domain->light_font.write(m_screen,8,8,s);

  int bonus_y_pos = 24;

  m_domain->dark_font.write(m_screen,0,bonus_y_pos,"BONUS");

  MyString b = m_bonus_value;
  b.pad('0',2,true);

  m_domain->light_font.write(m_screen,8,bonus_y_pos+8,b);
  m_domain->light_font.write(m_screen,24,bonus_y_pos+8,"00");

  int nb_lives = m_player->get_nb_lives();
  int x_life = 0;
  int y_life = 48;

  for (int i = 0; i < nb_lives; i++)
    {
      m_palette->life.render(m_screen,x_life,y_life);
      x_life+=8;
    }
  SDLRectangle lerase(x_life,y_life,8,8);
  m_screen.fill_rect(&lerase,0);




}

void MPLevel::render_score_and_bonus_original()
{
  // render score & bonus

  m_screen.set_affine_transformation(SCALE_SIZE,m_domain->rotate_90);

  if (m_state == GAME_OVER)
    {
      m_domain->darker_font.write(m_screen,80,112,"GAME OVER ");
    }
  int nb_lives = m_player->get_nb_lives();
  int x_life = 8;
  int y_life = 248;
  for (int i = 0; i < nb_lives; i++)
    {
      m_palette->life.render(m_screen,x_life,y_life);
      x_life+=8;
    }
  SDLRectangle lerase(x_life,y_life,8,8);
  m_screen.fill_rect(&lerase,0);

  m_domain->dark_font.write(m_screen,0,0,"PLAYER 1");
  MyString s = m_player->get_score();
  s.pad('0',6,true);
  m_domain->light_font.write(m_screen,8,8,s);

  int bonus_x_pos = 88;
  m_domain->dark_font.write(m_screen,bonus_x_pos,0,"BONUS");
  MyString b = m_bonus_value;
  b.pad('0',2,true);

  m_domain->light_font.write(m_screen,bonus_x_pos+8,8,b);
  m_domain->light_font.write(m_screen,bonus_x_pos+24,8,"00");

  if (m_domain->full_screen)
    {
      clip_fullscreen();
    }
}
#endif
