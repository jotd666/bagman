#pragma once
#ifndef DISPLAY_DEPTH

#ifdef __amigaos__
#include "sdl_emu.hpp"
#define DISPLAY_DEPTH NB_PLANES
#else
#ifdef _NDS
#define DISPLAY_DEPTH 8
#else
#define DISPLAY_DEPTH 32
#endif

#endif
#endif // DISPLAYDEPTH_H_INCLUDED
