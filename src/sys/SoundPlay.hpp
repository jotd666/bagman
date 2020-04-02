#ifndef SOUNDPLAY_H_INCLUDED
#define SOUNDPLAY_H_INCLUDED

#include "Abortable.hpp"
#include "MyVector.hpp"

#if !defined(_NDS) && !defined(__amigaos__)
#define USE_SDL_MIXER 1
#endif


#include <map>
#ifdef _NDS
#include <nds.h>
#include <maxmod9.h>
#else

#include "SDL/SDL.h"
#ifdef USE_SDL_MIXER
#include "SDL/SDL_mixer.h"
#else
#ifdef __amigaos__

#include "ptplayer.hpp"
       #else
#include "SDL/SDL_audio.h"
#endif
#endif
#endif

class SoundPlay : public Abortable
{
public:
  DEF_GET_STRING_TYPE(SoundPlay);
  ~SoundPlay();
  SoundPlay(int master_sample_rate);
  bool is_music_playing() const;

  void play_music(const MyString &filepath, int track_position=0);
  void stop_music();

  class SampleNode
  {
    public:
        #ifdef _NDS
    mm_sound_effect maxmod_data;  // maxmod stuff
        #else
        #ifdef USE_SDL_MIXER
    Mix_Chunk *sample;
        #else
       #ifdef __amigaos__
    SfxStructure cvt;
       #else
    SDL_AudioCVT cvt;  // SDL stuff
      #endif
        #endif
    bool loop;
        #endif
  };

  void close();
  // priority only used on AmigaOS (when needed, from 1 to 64, 64 being the highest)
  SampleNode *load(const MyString &filename, int key, bool loop = false, int priority = 1);
  int play(int key);
  void stop(int i);
  void unload(int key);
  void unload_all();
  void stop_all();

private:
  void init();
    #ifndef _NDS
    #ifndef USE_SDL_MIXER
  static void mixaudio(void *obj, Uint8 *stream, int len);
  void mixaudio(Uint8 *stream, int len);

  struct Sample
  {
    Sample() : data(0),dpos(0),dlen(0),loop(false) {}

    const Uint8 *data;
    Uint32 dpos;
    Uint32 dlen;
    bool    loop;
  };

  MyVector<Sample> sounds;
  SDL_AudioSpec fmt;
    #endif // USE_SDL_MIXER


#endif
  bool audio_open;

  typedef std::map<int,SampleNode> SampleList;

  SampleList sample_node;
    #ifdef _NDS
  MyString soundbank_file;
    #else
  #ifdef USE_SDL_MIXER
  Mix_Music *m_music;
  #else
  #endif
    #endif
  #ifdef __amigaos
  MyString m_last_module_loaded;
  UBYTE *m_current_module = nullptr;
  int m_current_module_size = 0;
  #endif
  int m_master_sample_rate;

};

#endif
