#ifndef CROSS_H
#define CROSS_H

#include <SDL/SDL.h>
#include "Abortable.hpp"
#ifdef _NDS
#define SDL_Delay DO_NOT_CALL_THIS_SDL_DELAY_SHIT
#endif

class Cross : public Abortable
{
public:
    DEF_GET_STRING_TYPE(Cross);
    void init_console();   // required if print required before init_io
    /**
    * main I/O init
    *
    * initializes video, sound, filesystem, console
    */
    SDL_Surface *init_io(bool silent, bool full_screen, int screen_width, int screen_height);

    static void close();
    void sound_test();
private:
    void init_filesystem();

};

#endif
