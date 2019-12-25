#pragma once

/*
  
   Written by JOTD & others
 */

#ifndef SDI_COMPILER_H
#include <SDI_compiler.h>
#endif

#define BITDEF(a,b,v) a##F_##b = 1<<v

extern "C"
{
  enum JoyState
    {
      BITDEF	(JP,BTN_RIGHT,0),
      BITDEF	(JP,BTN_LEFT,1),
      BITDEF	(JP,BTN_DOWN,2),
      BITDEF	(JP,BTN_UP,3),
      BITDEF	(JP,BTN_PLAY,0x11),
      BITDEF	(JP,BTN_REVERSE,0x12),
      BITDEF	(JP,BTN_FORWARD,0x13),
      BITDEF	(JP,BTN_GRN,0x14),
      BITDEF	(JP,BTN_YEL,0x15),
      BITDEF	(JP,BTN_RED,0x16),
      BITDEF	(JP,BTN_BLU,0x17)
    };
  void ASM detect_controller_types(void);

  ULONG ASM read_joystick(REG(d0, ULONG number));
  ULONG ASM read_keypress();
  
}


