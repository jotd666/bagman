#ifndef MPLEVEL_H_INCLUDED
#define MPLEVEL_H_INCLUDED

#include "GameContext.hpp"
#include "GfxPalette.hpp"
#include "GfxObjectLayer.hpp"
#include "TileGrid.hpp"
#include "MyMacros.hpp"
#include "Fonts.hpp"
#include "AnimatedSprite.hpp"
#include "FadeInEvent.hpp"
#include "FadeOutEvent.hpp"
#include "MemoryEntryMap.hpp"
#include "SoundSet.hpp"
#include "TileGrid.hpp"
#include "PointerVector.hpp"
#include "Elevator.hpp"
#include "HumanCharacter.hpp"
#include "ScaleSize.hpp"

class Wagon;
class Player;
class SoundSet;
class MPDomain;
class GfxObject;
class Guard;

/**
 * main game state/context
 */

class MPLevel : public GameContext
{
public:
  DEF_GET_STRING_TYPE(MPLevel);

  virtual ~MPLevel();
  int get_width() const;
  int get_height() const;

  Player *get_player()
  {
    return m_player;
  }

  static MPLevel *create(MPDomain *domain);

  int get_nb_pick_blows() const
  {

    return m_nb_pick_blows;
  }
  PointerVector<Guard,true> &get_guards()
  {
    return m_guards;
  }
  // shortcuts to load/unload sounds
  void unload_sound(SoundSet::SoundId sid);
  void load_sound(SoundSet::SoundId sid);


  const TileGrid &get_grid() const
  {

    return *m_grid;
  }

  const GfxPalette &get_palette() const;
  const SDLRectangle &get_view_bounds() const
  {
    return m_view_bounds;
  }

  GfxObject *get_pickable_item();

  /**
   * keep other sub-levels when loading (only case: World 1-2)
   */


  void remove_object(GfxObject *o, bool permanently);
  void pick_up_object(GfxObject *o);
  void insert_object(GfxObject *o);



  SoundSet &get_sound_set() const
  {
    return *m_sound_set;
  }

  bool hit_block(int x, int y, bool immediate);

  void set_level_end()
  {
    m_level_end = true;
  }
  void empty_wagons();

  const MPDomain &get_domain() const
  {
    return *m_domain;
  }

  const PlayerControls::Status &get_player_input();

  bool is_wagon_below_player() const;
  void get_elevator_contained_state(const Character &c,Elevator::CharacterContained &cc,const Elevator * &e) const;

  const GfxObject *get_barrow() const;
  GfxObject *get_barrow();
  void bag_in_barrow(bool blue_bag);

  void break_wall();
  void stop_music();

  void restart();
  bool all_guards_are_stunned() const;

  const Elevator *get_elevator(int current_screen) const;
  Elevator *get_elevator(int current_screen);
private:
  void render_score_and_bonus_original();
  void render_score_and_bonus_right();

  struct CharacterStartPos
  {
    int x,y,current_screen;
    HumanCharacter::FullDirection d;
    void init(int px,int py,int cs,HumanCharacter::FullDirection pd)
    {
      x = px;
      y = py;
      current_screen = cs;
      d = pd;
    }
  };


  struct CharacterStartPosSet
  {
    CharacterStartPos player,guard[2];
  };
  void add_character_positions(int px,int py,int pcs,HumanCharacter::FullDirection pd,
			       int g1x,int g1y,int g1cs,HumanCharacter::FullDirection g1d,
			       int g2x,int g2y,int g2cs,HumanCharacter::FullDirection g2d);

  MyVector<CharacterStartPosSet> m_character_position_settings;

  void update_characters(int elapsed_time);
  void update_pickaxes();
  void level_end();

  void create_objects(const int *data, int current_screen);
  void insert_objects(const int *data, int current_screen);

  MPLevel();
  void render_screen_layer(int i);
  void render_breakable_block();


  enum State { RUNNING, PAUSED, GAME_OVER, QUIT_GAME, LEVEL_END };

  State m_state;
  Player *m_player;
  virtual void private_init();

  GameContext *update_level_end(int elapsed_time);


  TileGrid *m_grid;

  void clip_fullscreen();

  GameContext *update_running(int elapsed_time);
  GfxObject *get_item_intersecting(const Locatable *c);

  /*    void render_hostiles(Drawable &d) const;
	void render_objects(Drawable &d) const;
	void render_tiles(Drawable &d, const SDLRectangle &view_bounds) const;*/

  SoundSet *m_sound_set;
  State m_old_state;

  FadeInEvent m_fadein_event;
  FadeOutEvent m_fadeout_event;
  SDLRectangle m_view_bounds;
  bool m_level_end;

  int m_player_wagon_index;
  int m_last_rendered_screen;

  GameContext *private_update(int elapsed_time);
  void load();
  void render_all_layers();
  void init_new_level();
  void handle_guard_bag_collisions();
  int get_nb_bags() const;

  bool is_trainer_mode() const;
  int get_max_bonus_value() const;

  MPDomain *m_domain;
  int m_bonus_value;
  int m_bonus_timer;
  bool m_first_update;
  int m_move_sound_timer;
  int m_nb_pick_blows;
  bool m_dead_fadeout,m_gameover_fadeout,m_level_end_fadeout;
  int m_game_over_timer;

  PlayerControls::Status m_to_right_input;

  int m_player_dead_time;
  bool m_first_level;
  const GfxPalette *m_palette;
  PointerVector<GfxObjectLayer,true> m_object_layer;

  PointerVector<Guard,true> m_guards;
  PointerVector<Wagon,true> m_wagons;
  PointerVector<Elevator,true> m_elevators;
  PointerList<Character,false> m_character_list;

  #ifdef PARTIAL_REFRESH
  void restore_background();
  void store_current_positions();

  int m_player_last_x = 0;
  int m_player_last_y = 0;
  int m_previous_bonus_value = 0;
  int m_previous_score = 0;
  MyVector<SDLRectangle> m_redraw_bounds;
  int m_nb_draw_bounds = 0;
  #endif
  DEF_CLASS_COPY(MPLevel);
};

#endif // MPLEVEL_H_INCLUDED
