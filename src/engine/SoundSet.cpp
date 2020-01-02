#include "SoundSet.hpp"
#include "DirectoryBase.hpp"
#include "MyFile.hpp"

#include "RandomNumber.hpp"
#include <map>

#define LOAD_SOUND(s) load_sound(s)
#define LOAD_SOUND_12(s) load_sound(s##_1); load_sound(s##_2)

#define DECL_SOUND_STRING(s) register_sound_string(SoundSet::s,#s)
#define DECL_SOUND_STRING_12(s) DECL_SOUND_STRING(s##_1); DECL_SOUND_STRING(s##_2)

// NDS implementation does not need this since it uses a soundbank & maxmod
#ifndef _NDS
typedef std::map<SoundSet::SoundId,const char *> SoundNameMap;

static SoundNameMap sound_string_table;

static void register_sound_string(SoundSet::SoundId id,const char *s)
{
  sound_string_table.insert(std::make_pair(id,s));
}
static std::map<SoundSet::SoundId, int> sound_priority =
{
 {SoundSet::player_killed,20},
 {SoundSet::timewarn, 10},
 {SoundSet::reward, 10},
 {SoundSet::ethopla, 10},
 {SoundSet::guard_killed, 10},
 {SoundSet::hohisse,10},
 {SoundSet::take_bag,10},
 {SoundSet::pickaxe,5}
};


static void register_sound_strings()
{
  DECL_SOUND_STRING(ethopla);
  DECL_SOUND_STRING(guard_killed);
  DECL_SOUND_STRING(hohisse);
  DECL_SOUND_STRING(pickaxe);
  DECL_SOUND_STRING(player_climb);
  DECL_SOUND_STRING(player_killed);
  DECL_SOUND_STRING(player_step);
  DECL_SOUND_STRING(guard_climb);
  DECL_SOUND_STRING(guard_step);
  DECL_SOUND_STRING(reward);
  DECL_SOUND_STRING(take_bag);
  DECL_SOUND_STRING(timewarn);
}

// force call of register_sound_strings
static int zit = (register_sound_strings(),0);
#endif

void SoundSet::unload_sound(SoundId k)
{
  m_player.unload(k);
}

void SoundSet::unload_sounds()
{
  m_game_sounds_loaded = false;
  std::map<int,void *>::iterator it;

  m_player.unload_all();


}

void SoundSet::stop_music()
{

  m_player.stop_music();
}
void SoundSet::play_music(const MyString &track_name, int track_position)
{

  m_player.play_music(track_name,track_position);
}


void SoundSet::load_ingame_sounds()
{
  if (!m_silent && !m_game_sounds_loaded)
    {
      // load the sounds
      LOAD_SOUND(ethopla);
      LOAD_SOUND(guard_killed);
      LOAD_SOUND(hohisse);
      LOAD_SOUND(pickaxe);
      LOAD_SOUND(player_killed);
      LOAD_SOUND(player_climb);
      LOAD_SOUND(player_step);
      LOAD_SOUND(guard_climb);
      LOAD_SOUND(guard_step);
      LOAD_SOUND(reward);
      LOAD_SOUND(take_bag);
      LOAD_SOUND(timewarn);

      m_game_sounds_loaded = true;
    }
}

void SoundSet::init(bool silent)
{
  m_silent = silent;
}

void SoundSet::stop(int shnd)
{
  if (!m_silent)
    {
      m_player.stop(shnd);
    }
}

int SoundSet::play_random(SoundId k, int nb_sounds)
{
  return play((SoundId)(k+RandomNumber::rand(nb_sounds)));
}
bool SoundSet::is_music_playing() const
{
  return m_player.is_music_playing();
}

int SoundSet::play(SoundId k)
{
  int rval = -1;


  ENTRYPOINT(SoundSet);
  if (!m_silent)
    {
      rval = m_player.play(k);
    }
  EXITPOINT;
  return rval;
}

#ifdef _NDS

void SoundSet::load_sound(SoundId k,bool)
{
  // loop is not taken in consideration: MAXMOD requires looped .wav files
  // I could only create proper ones using Sony Soundforge 8
  m_player.load("",k,false);
}


#else

void SoundSet::load_sound(SoundId k,bool loop)
{
  // find sound name
  SoundNameMap::const_iterator it = sound_string_table.find(k);
  if (it == sound_string_table.end())
    {
      abort_run("Cannot find sound name for sound id %d",k);
    }

  const  char *sound_name = it->second;
  MyFile sound_filename = DirectoryBase::get_sound_path() / sound_name;
  int priority = 1; // default: low pri
  auto itp = sound_priority.find(k);
  if (itp != sound_priority.end())
    {
      priority = itp->second;
    }
  m_player.load(sound_filename.get_name() + DirectoryBase::get_sound_extension(),k,loop,priority);
}

#endif


SoundSet::SoundSet() :  m_player(32000), m_silent(false), m_game_sounds_loaded(false)
{

}
