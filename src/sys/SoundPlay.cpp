#ifdef _NDS
#include <nds.h>
#include "soundbank.hpp"
//#include "soundbank_bin.hpp"

#include "MyFile.hpp"
#include "DirectoryBase.hpp"

#endif

#ifdef __amigaos__
// discussion/examples about the tracker/sample player:
// http://eab.abime.net/showthread.php?t=65430
#include "MyFile.hpp"
#include <proto/exec.h>
#include <exec/types.h>
#include <exec/execbase.h>
#undef Cause

static void *custom_base = (void*)0xDFF000;
#endif


#include "SoundPlay.hpp"


SoundPlay::~SoundPlay()
{
  close();
}



#ifdef _NDS


SoundPlay::SoundPlay(int master_sample_rate) : audio_open(false)
{
}

void SoundPlay::init()
{
  ENTRYPOINT(init);

  if (!audio_open)
    {
      //    mmInitDefaultMem((mm_addr)soundbank_bin);
      soundbank_file = (DirectoryBase::get_sound_path() / "soundbank.bin");
      if (!MyFile(soundbank_file).exists())
	{
	  abort_run("Cannot locate soundbank file %q",soundbank_file);
	}

      mmInitDefault((char*)soundbank_file.c_str());
      audio_open = true;
    }

  EXITPOINT;
}

void SoundPlay::close()
{
  ENTRYPOINT(close);

  if (audio_open)
    {
      //sound_stop();


      audio_open = false;


    }
  EXITPOINT;
}

void SoundPlay::stop(int i)
{
  ENTRYPOINT(stop);

  mmEffectCancel(i);

  EXITPOINT;
}

int SoundPlay::play(int key)
{
  int index;
  ENTRYPOINT(play);



  SampleList::iterator it = sample_node.find(key);

  if (it != sample_node.end())
    {
      SampleNode &sn = it->second;
      mm_sound_effect &sfx = sn.maxmod_data;

      index = mmEffect(key);

    }

  EXITPOINT;
  return index;
}

void SoundPlay::stop_all()
{
  mmEffectCancelAll();
}

void SoundPlay::unload(int key)
{
  SampleList::iterator it = sample_node.find(key);

  if (it != sample_node.end())
    {
      stop_all();
      // cancel all effects currently playing (we don't want problems)
      mmUnloadEffect(key);
      sample_node.erase(it);
    }
}

SoundPlay::SampleNode *SoundPlay::load(const MyString &sound_filename, int key, bool)
{
  init();

  const SampleNode *rc = 0;

  SampleNode sn;
  sn.maxmod_data.id = key;
  sn.maxmod_data.rate = (int)(1.0f * (1<<10));
  sn.maxmod_data.handle =	0;
  sn.maxmod_data.volume =	255;
  sn.maxmod_data.panning =	128;

  std::pair<SampleList::iterator,bool> rval = sample_node.insert(std::make_pair(key,sn));

  if (!rval.second)
    {
      abort_run("duplicate key %d",key);
    }

  mmLoadEffect(key);

  SampleList::iterator it = rval.first;
  rc = &(it->second);

  return 0;
}
#else
#ifdef __amigaos__
SoundPlay::SoundPlay(int master_sample_rate) : audio_open(false)
{
}
void SoundPlay::play_music(MyString const& )
{
  // ATM no music
  return;

  MyString filename = "music/bagman_1.mod";
  MyFile f(filename);
  auto msize = f.size();
  UBYTE *module = nullptr;

  if (msize>0)
    {
      module = (UBYTE*)AllocMem(msize,MEMF_CHIP);
      if (module == nullptr)
	{
	  abort_run("Cannot allocate %d bytes for module",msize);
	}

      f.read_bytes(module,msize);
    }
  else
    {
      abort_run("Cannot read module file %s",filename);
    }



  mt_init(custom_base,module,nullptr, 0);

  //mt_musicmask(custom_base,0x3);

  mt_Enable = -1;


}
bool SoundPlay::is_music_playing() const
{
  return mt_Enable != 0;
}
void SoundPlay::stop_music()
{
  mt_Enable = 0;
}

static APTR GetVBR(void)
{
  APTR vbr = NULL;
  static const UWORD getvbr[] = {0x4e7a, 0x0801, 0x4e73}; // MOVEC.L VBR,D0 RTE

  if (SysBase->AttnFlags & AFF_68010)
    vbr = (APTR)Supervisor((long unsigned int (*)())getvbr);

  return vbr;
}
void SoundPlay::init()
{
  ENTRYPOINT(init);

  if (!audio_open)
    {
      // install cia interrupt

      mt_install_cia(custom_base, GetVBR(),  1);
      audio_open = true;
    }

  EXITPOINT;
}

void SoundPlay::close()
{
  ENTRYPOINT(close);

  if (audio_open)
    {
      // remove cia interrupt


      audio_open = false;


    }
  EXITPOINT;
}

void SoundPlay::stop(int i)
{
  ENTRYPOINT(stop);

  //mmEffectCancel(i);

  EXITPOINT;
}

// amiga
int SoundPlay::play(int key)
{

  int index=-1;
  ENTRYPOINT(play);


  SampleList::iterator it = sample_node.find(key);

  if (it != sample_node.end())
    {
      SampleNode sn = it->second;

      index = key;
      mt_playfx(custom_base,&sn.cvt);

    }

  EXITPOINT;
  return index;
}

void SoundPlay::stop_all()
{
  //mmEffectCancelAll();
}

void SoundPlay::unload(int key)
{
  /* SampleList::iterator it = sample_node.find(key);

     if (it != sample_node.end())
     {
       stop_all();
       // cancel all effects currently playing (we don't want problems)
       mmUnloadEffect(key);
       sample_node.erase(it);
     }*/
}

static UWORD hardware_period(int hertz)
{
  return 100000000L / (hertz*28);
}

SoundPlay::SampleNode *SoundPlay::load(const MyString &filename, int key, bool)
{
  init();

  SoundPlay::SampleNode *rc = 0;

  SampleNode sn;
  MyFile sf(filename);

  StreamPosition sz = sf.size();
  if (sz>0)
    {
      sn.cvt.sfx_ptr = AllocMem(sz,MEMF_CHIP);
      if (sn.cvt.sfx_ptr == nullptr)
	{
	  abort_run("Cannot allocate %d bytes",sz);
	}
    }
  else
    {
      abort_run("Cannot read sound file %s",filename);
    }
  sn.cvt.sfx_len = sz / 2;

  sn.cvt.sfx_vol = 64;
  sn.cvt.sfx_cha = -1;
  sn.cvt.sfx_pri = 1;
  sf.read_bytes(sn.cvt.sfx_ptr,sz);

  // first UWORD is the sampling rate with my special JOTD raw format
  UWORD sampling_rate;
  memcpy(&sampling_rate,sn.cvt.sfx_ptr,2);
  // now set to zero to be compatible with ptplayer sample format
  memset(sn.cvt.sfx_ptr,0,2);
  // but now we have configurable per-sample sample rate
  sn.cvt.sfx_per = hardware_period(sampling_rate);

  std::pair<SampleList::iterator,bool> rval = sample_node.insert(std::make_pair(key,sn));

  if (!rval.second)
    {
      abort_run("duplicate key %d",key);
    }

  // mmLoadEffect(key);

  SampleList::iterator it = rval.first;
  rc = &(it->second);

  return rc;
}
#else
#define NUM_SOUNDS 16





#ifdef USE_SDL_MIXER

SoundPlay::SoundPlay(int master_sample_rate) : audio_open(false),m_master_sample_rate(master_sample_rate)
{

  m_music = 0;


}
bool SoundPlay::is_music_playing() const
{
  return Mix_PlayingMusic()!=0;
}
void SoundPlay::play_music(const MyString &filepath)
{


  ENTRYPOINT(play);
  init();

  if(Mix_PlayingMusic() ==0)
    {
      stop_music();

      m_music = Mix_LoadMUS(filepath.c_str());
      if(m_music == 0)
	{
	  warn("Cannot load music file "+filepath+": "+Mix_GetError());
	}
      else if(Mix_PlayMusic(m_music, 0) ==-1)
	{
	  warn("Cannot play music file "+filepath+": "+Mix_GetError());
	}
    }

  EXITPOINT;

}

void  SoundPlay::stop_music()
{
  if (m_music!=0)
    {
      Mix_FreeMusic(m_music);
      m_music = 0;
    }

}
SoundPlay::SampleNode *SoundPlay::load(const MyString &filepath, int key, bool loop)
{
  SoundPlay::SampleNode *rc = 0;
  ENTRYPOINT(load);

  init();

  if (audio_open)
    {
      Mix_Chunk *c = Mix_LoadWAV(filepath.c_str());
      if(c == NULL)
	{
	  warn(SDL_GetError());
	}
      else
	{
	  SampleNode sn;

	  sn.loop = loop;

	  sn.sample = c;

	  std::pair<SampleList::iterator,bool> rval = sample_node.insert(std::make_pair(key,sn));

	  if (!rval.second)
	    {
	      abort_run("duplicate key %d for sample %q",key,filepath);
	    }

	  SampleList::iterator it = rval.first;

	  rc = &(it->second);
	}
    }

  EXITPOINT;

  return rc;
}
void SoundPlay::init()
{
  ENTRYPOINT(init);

  if (!audio_open)
    {
      if(Mix_OpenAudio(m_master_sample_rate, MIX_DEFAULT_FORMAT, 2, 4096) ==-1)
	{
	  MyString sdlerr = SDL_GetError();
	  if (sdlerr.contains("already open"))
	    {
	      // OK
	    }
	  else
	    {
	      abort_run("Unable to open audio mix: %s", sdlerr);
	    }

	  Mix_AllocateChannels(NUM_SOUNDS);
	}
      audio_open = true;
      sample_node.clear();


    }

  EXITPOINT;
}

void SoundPlay::unload(int key)
{
  ENTRYPOINT(unload);

  SampleList::iterator it = sample_node.find(key);
  if (it != sample_node.end())
    {
      SampleNode &sn = it->second;

      // free sample nodes

      Mix_FreeChunk(sn.sample);
      sample_node.erase(it);
    }
  EXITPOINT;
}
void SoundPlay::close()
{
  ENTRYPOINT(close);

  if (audio_open)
    {
      //sound_stop();
      stop_music();

      Mix_CloseAudio();

      audio_open = false;

      SampleList::iterator it;

      FOREACH(it,sample_node)
      {
	SampleNode &sn = it->second;

	// free sample nodes
	Mix_FreeChunk(sn.sample);

      }

      sample_node.clear();
    }
  EXITPOINT;
}


int SoundPlay::play(int key)
{

  ENTRYPOINT(play);

  //m_last_free_slot++;


  /* Put the sound data in the slot (it starts playing immediately) */

  SampleList::const_iterator it = sample_node.find(key);

  if (it != sample_node.end())
    {
      const SampleNode &sn = it->second;

      Mix_PlayChannel(-1, sn.sample, sn.loop ? -1 : 0);
    }
  else
    {
      warn("sample with key=%d not found",key);
    }
  EXITPOINT;
  return 0;
}

void SoundPlay::stop_all()
{
  ENTRYPOINT(stop_all);


  // halt playback on all channels
  Mix_HaltChannel(-1);

  EXITPOINT;
}
void SoundPlay::stop(int i)
{
  ENTRYPOINT(stop);

  // halt playback on all channels
  Mix_HaltChannel(i);

  EXITPOINT;
}
#else


SoundPlay::SoundPlay(int master_sample_rate) : audio_open(false),m_master_sample_rate(master_sample_rate)
{
  sounds.resize(NUM_SOUNDS);

}
SoundPlay::SampleNode *SoundPlay::load(const MyString &filepath, int key, bool loop)
{
  SoundPlay::SampleNode *rc = 0;
  #ifdef __amigaos__
  (void)filepath; (void)key; (void)loop;
  #else
  ENTRYPOINT(load);

  init();

  if (audio_open)
    {
      SDL_AudioSpec wave;
      Uint8 *data;
      Uint32 dlen;

      /* Load the sound file and convert it to 16-bit stereo at 22kHz */
      if ( SDL_LoadWAV(filepath.c_str(), &wave, &data, &dlen) == 0 )
	{
	  warn(SDL_GetError());
	}
      else
	{
	  SampleNode sn;

	  sn.loop = loop;

	  SDL_BuildAudioCVT(&(sn.cvt), wave.format, wave.channels, wave.freq,
			    fmt.format,   fmt.channels,        fmt.freq);
	  sn.cvt.buf = new Uint8[dlen*sn.cvt.len_mult];

	  memcpy(sn.cvt.buf, data, dlen);
	  sn.cvt.len = dlen;

	  SDL_ConvertAudio(&(sn.cvt));

	  SDL_FreeWAV(data);

	  std::pair<SampleList::iterator,bool> rval = sample_node.insert(std::make_pair(key,sn));

	  if (!rval.second)
	    {
	      abort_run("duplicate key %d for sample %q",key,filepath);
	    }

	  SampleList::iterator it = rval.first;

	  rc = &(it->second);
	}
    }

  EXITPOINT;
#endif

  return rc;
}

void SoundPlay::unload(int key)
{
  #ifdef __amigaos__
  (void)key;
  #else
  ENTRYPOINT(unload);

  SampleList::iterator it = sample_node.find(key);
  if (it != sample_node.end())
    {
      SampleNode &sn = it->second;

      // free sample nodes

      delete [] sn.cvt.buf;
      sample_node.erase(it);
    }
  EXITPOINT;
  #endif

}
void SoundPlay::init()
{
  ENTRYPOINT(init);

  if (!audio_open)
    {
      /* Set 16-bit stereo audio at 32Khz */
      fmt.freq = m_master_sample_rate;
      fmt.format = AUDIO_S16;
      fmt.channels = 2;
      fmt.samples = 512;        /* A good value for games */
      fmt.callback = &mixaudio;
      fmt.userdata = this;

      /* Open the audio device and start playing sound! */
      if ( SDL_OpenAudio(&fmt, 0) < 0 )
	{
	  MyString sdlerr = SDL_GetError();
	  if (sdlerr.contains("already open"))
	    {
	      // OK
	    }
	  else
	    {
	      abort_run("Unable to open audio: %s", sdlerr);
	    }

	}
      audio_open = true;
      sample_node.clear();

      SDL_PauseAudio(0);
    }

  EXITPOINT;
}

void SoundPlay::close()
{
  #ifdef __amigaos__

  #else
  ENTRYPOINT(close);

  if (audio_open)
    {
      //sound_stop();

      SDL_PauseAudio(0);
      SDL_CloseAudio();
      audio_open = false;

      SampleList::iterator it;

      FOREACH(it,sample_node)
      {
	SampleNode &sn = it->second;

	// free sample nodes

	delete [] sn.cvt.buf;
      }

      sample_node.clear();
    }
  EXITPOINT;
  #endif
}


void SoundPlay::mixaudio(Uint8 *stream, int len)
{
  ENTRYPOINT(mixaudio);

  int i;
  int amount;


  for ( i=0; i<NUM_SOUNDS; ++i )
    {
      Sample &s = sounds[i];

      amount = (s.dlen-s.dpos);
      if ( amount > len )
	{
	  amount = len;
	}
      if (amount > 0)
	{
	  SDL_MixAudio(stream, &s.data[s.dpos],
		       amount, SDL_MIX_MAXVOLUME);
	  s.dpos += amount;
	  if ((s.loop) && (s.dpos >= s.dlen))
	    {
	      s.dpos = 0;
	    }
	}
    }
  EXITPOINT;
}




void SoundPlay::stop(int i)
{
  ENTRYPOINT(stop);
  if (i >= 0)
    {
      sounds[i].loop = false;
      sounds[i].dpos = sounds[i].dlen;
    }
  EXITPOINT;
}

void SoundPlay::stop_all()
{
  int index;
  ENTRYPOINT(stop_all);

  for ( index=0; index<NUM_SOUNDS; ++index )
    {
      sounds[index].loop = false;
      sounds[index].dpos = sounds[index].dlen;
    }
  EXITPOINT;
}

int SoundPlay::play(int key)
{
  int index = -1;

  ENTRYPOINT(play);

  /* Look for an empty (or finished) sound slot */
  for ( index=0; index<NUM_SOUNDS; ++index )
    {
      if ( sounds[index].dpos == sounds[index].dlen )
	{
	  break;
	}
    }
  if ( index == NUM_SOUNDS )
    return -1;


  /* Put the sound data in the slot (it starts playing immediately) */

  SampleList::const_iterator it = sample_node.find(key);

  if (it != sample_node.end())
    {
      const SampleNode &sn = it->second;

      SDL_LockAudio();

      sounds[index].data = sn.cvt.buf;
      sounds[index].dlen = sn.cvt.len_cvt;
      sounds[index].dpos = 0;
      sounds[index].loop = sn.loop;
      SDL_UnlockAudio();
    }
  else
    {
      warn("sample with key=%d not found",key);
    }
  EXITPOINT;
  #endif

  return index;
}

void SoundPlay::mixaudio(void *obj, Uint8 *stream, int len)
{
  // static wrapper
  SoundPlay *t = (SoundPlay*)obj;

  t->mixaudio(stream,len);
}

#endif // USE_SDL_MIXER

#endif // _NDS
void SoundPlay::unload_all()
{
  stop_all();

  SampleList::iterator it;
  FOREACH (it,sample_node)
  {
    unload(it->first);
  }
  sample_node.clear();
}

