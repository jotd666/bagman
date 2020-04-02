#include "Cross.hpp"
#include "DisplayDepth.hpp"
#include "DirectoryBase.hpp"

#include <SDL/SDL.h>
#ifdef _NDS
#include <nds.h>
#include <nds/arm9/console.h>
#include <filesystem.h>
#include <fat.h>
#include <stdio.h>
#include <nds.h>
#include <nds/arm9/sound.h>
#include <maxmod9.h>
#include "soundbank.hpp"
#include "GsTime.hpp"
/*#ifndef NDS_EMU
#include "efs_lib.hpp"
#endif*/

#include "MyFile.hpp"

//#define		VCOUNT		(*((u16 volatile *) 0x04000006))


void Cross::sound_test()
{
    MyString soundbank_file = (DirectoryBase::get_sound_path() / "soundbank.bin");
    if (!MyFile(soundbank_file).exists())
    {
        abort_run("Cannot locate soundbank file %q",soundbank_file);
    }

    mmInitDefault((char*)soundbank_file.c_str());
    mmLoadEffect(SFX_ETHOPLA);

   /* mmLoad(MOD_POCKET);
mmStart(MOD_POCKET,MM_PLAY_LOOP);*/


}


void Cross::init_console()
{
    consoleDemoInit();
    debug("NDS console OK");


}
void Cross::init_filesystem()
{

    // nitrofsinit works OK with No$GBA (default), OK with Ideas (use GBA ROM for EFS set)
    // does not work with real DS on M3 cartridge

    // Same for EFS, but I cannot scan drives properly with it (no opendir, but specific shit)

#ifdef NDS_EMU
    if (!nitroFSInit())
    {
        debug("Could not initialize NitroFS");
    }
#else
    /*if (!EFS_Init(EFS_AND_FAT | EFS_DEFAULT_DEVICE, NULL)) //(char*)"efs:/NDS/MagicPockets.nds"))
    {
       abort_run("Could not initialize EFS");
    }*/

// this works on a real DS (M3) but requires to copy files on SD cart independently
    if (!fatInitDefault())
    {
        debug("Could not initialize FAT");
    }
#endif

    MyFile root(DirectoryBase::get_root());
    if (!root.is_directory())
    {
        abort_run("Directory %s does not exist. Install data dir properly",root.get_name());
    }
}

#else

void Cross::sound_test()
{
}
void Cross::init_console()
{
}
void Cross::init_filesystem()
{

}
#include <signal.h>

void print_stack_trace(int s)
{
    const char *reason = 0;

    switch(s)
    {
        case SIGSEGV:
            reason = "segv";
            break;
            case SIGINT:
            reason = "user interrupt";
            break;
            default:
            reason = "unknown cause";
            break;
    }
    fprintf(stderr,"\n***********************************\nAbnormal program termination: %s\n"
    "\n***********************************\n",reason);

        #ifndef NDEBUG
  #if !defined(_NDS) && !defined(__amigaos__)

 // fprintf(stderr,"%s\n",Abortable::stack_trace().c_str());
  #endif
    #endif
    exit(s);
}

#endif



void install_exception_handler()
{
    #ifdef _NDS
    defaultExceptionHandler();
    #else
    #ifndef __amigaos__
    // civilized
    //signal(SIGSEGV,print_stack_trace);
  //signal(SIGINT,print_stack_trace);
  #endif
    #endif
}

void Cross::close()
{

    SDL_Quit();
}
SDL_Surface * Cross::init_io(bool silent, bool full_screen, int screen_width, int screen_height)
{
    SDL_Surface *screen = 0;

    install_exception_handler();


    #ifdef _NDS



    int flags = SDL_INIT_VIDEO;  // NDS SDL is very limited & buggy: only video works properly
    #else

    int flags = silent ? SDL_INIT_EVERYTHING & ~SDL_INIT_AUDIO : SDL_INIT_EVERYTHING;
    #endif


    if (SDL_Init(flags) != 0)
    {
        abort_run("Unable to initialize SDL: %s", SDL_GetError());
    }
    // no mouse pointer (what the hell is that for!)
    SDL_ShowCursor(0);

    // In NDS mode, SDL kills everything: create it now
    this->init_console();
    this->init_filesystem();

#ifdef _NDS
    int vm = SDL_SWSURFACE|SDL_FULLSCREEN;
    // image blit won't work if screenmode is not standard

    screen = SDL_SetVideoMode(256,208,DISPLAY_DEPTH,vm);


#else
  #ifdef __amiga__
    // Amiga
    int vm = SDL_HWSURFACE|SDL_DOUBLEBUF;
    if (full_screen)
    {
        vm |= SDL_FULLSCREEN;
        // image blit won't work if screenmode is not standard
        screen = SDL_SetVideoMode(320,240,DISPLAY_DEPTH,vm);
    }
    else
    {
        screen = SDL_SetVideoMode(screen_width,screen_height,DISPLAY_DEPTH,vm);
    }


  #else
    // PC
    int vm = SDL_HWSURFACE|SDL_DOUBLEBUF;
    if (full_screen)
    {
        vm |= SDL_FULLSCREEN;
        // image blit won't work if screenmode is not standard
        screen = SDL_SetVideoMode(640,480,DISPLAY_DEPTH,vm);
    }
    else
    {
        screen = SDL_SetVideoMode(screen_width,screen_height,DISPLAY_DEPTH,vm);
    }
  #endif


#endif

    if (screen == 0)
    {
        abort_run("Unable to open SDL screen: %s", SDL_GetError());
    }



    return screen;
}
