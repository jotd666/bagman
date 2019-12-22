#include "SysCompat.hpp"
#include <SDL/SDL.h>

#include <ctime>
#ifndef _WIN32
#include <unistd.h>
#endif

#ifdef _NDS
#include <nds.h>
#endif

#include "GsTime.hpp"

GsTime::GsTime()
{

}

GsTime::~GsTime()
{

}


/*void GsTime::wait(int seconds)
  {
  sleep(seconds);
  }*/
/*
   #ifdef _NDS
   void GsTime::wait(int millis)
   {
    // SDL_Delay uses active wait: save batteries with that method
    // which uses wait for vblank

    uint32 target_time = millis + SDL_GetTicks();
    while(1)
    {
	swiWaitForVBlank();
	if (target_time < SDL_GetTicks())
	{
	    break;
	}
    }
   // while (VCOUNT>192); // wait for vblank
   // while (VCOUNT<192);
   }
   #else*/
void GsTime::wait(int millis)
{
  SDL_Delay(millis);
}

MyString GsTime::get_current_date
  (
  char separator
)
{
  (void)separator;
  // fake date
  return "12/12/2012";
}

//#endif

