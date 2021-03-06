#ifndef SOUNDSET_H_INCLUDED
#define SOUNDSET_H_INCLUDED

#include "Abortable.hpp"
#include "SoundPlay.hpp"
#include "soundbank.hpp"

#include <map>


/**
 * class which loads sounds and allow to play them
 * it relies on SoundPlay class (generic) and soundbank.h
 * which contains enums required for the NDS (maxmod), but also used
 * for the PC version once generated by the mmutil tool (so it's simpler)
 */

class SoundSet : public Abortable
{
public:
  enum SoundId
    {
      ethopla = SFX_ETHOPLA,
      guard_killed = SFX_GUARD_KILLED,
      hohisse = SFX_HOHISSE,
      pickaxe = SFX_PICKAXE,
      player_climb = SFX_PLAYER_CLIMB,
      player_killed = SFX_PLAYER_KILLED,
      player_step = SFX_PLAYER_STEP,
      reward = SFX_REWARD,
      take_bag = SFX_TAKE_BAG,
      timewarn = SFX_TIMEWARN,
      guard_climb = SFX_GUARD_CLIMB,
      guard_step = SFX_GUARD_STEP

    };


  DEF_GET_STRING_TYPE(SoundSet);
  SoundSet();
  void init(bool silent=false);


  bool is_silent() const
  {
    return m_silent;
  }

  SoundPlay &get_player()
  {
    return m_player;
  }
  void unload_sounds();
  void load_ingame_sounds();

  void load_sound(SoundId k, bool loop=false);
  void unload_sound(SoundId k);

  void stop_music();
  bool is_music_playing() const;

  void play_music(const MyString &track_name, int track_position=0);
  /**
   * @return channel index or -1 if failure
   */

  int play_random(SoundId s, int nb_sounds=1);
  int play(SoundId s);
  void stop(int shnd);
private:
  SoundPlay m_player;

  bool m_silent;
  bool m_game_sounds_loaded;


  DEF_CLASS_COPY(SoundSet);
};

#endif // SOUNDSET_H_INCLUDED
