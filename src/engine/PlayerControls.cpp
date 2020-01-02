#include "PlayerControls.hpp"
#include "string.h"

#ifdef _NDS
#include <nds.h>
#else
#include <SDL/SDL.h>
#endif

#define JOY_THRESHOLD 16384


PlayerControls::Status::Status()
{
  esc_pressed = false;
#ifndef NDEBUG
  t_pressed = false;
  e_pressed = false;
#endif

}

#ifdef _NDS

PlayerControls::PlayerControls()
{
}
PlayerControls::~PlayerControls()
{
}

// don't use SDL joystick interface because it's using keysUp and keysDown and there's
// something about it that I'm not getting right => f**k it, I'm doing it using nds interface directly
// and it works 1000 times better

void PlayerControls::update(Status &controls)
{
  ENTRYPOINT(update);

  scanKeys();

  int keysc = keysCurrent();

  /*    controls.right.pressed(keysc & KEY_RIGHT);
	controls.left.pressed(keysc & KEY_LEFT);
	controls.up.pressed(keysc & KEY_UP);
	controls.down.pressed(keysc & KEY_DOWN);*/
  controls.right.pressed(keysc & KEY_UP);
  controls.left.pressed(keysc & KEY_DOWN);
  controls.up.pressed(keysc & KEY_LEFT);
  controls.down.pressed(keysc & KEY_RIGHT);

  controls.fire.pressed(keysc & KEY_A);
  controls.esc_pressed = (keysc & (KEY_L | KEY_R)) == (KEY_L | KEY_R);

  /*if((keysHeld() & KEY_LID))
    {
      // pause when closing the DS
      powerOff(POWER_ALL);
      while((keysHeld() & KEY_LID)){scanKeys();swiWaitForVBlank();}powerOn(POWER_ALL);
    }*/
  EXITPOINT;

}

#else
// PC and other civilized platforms :)
void PlayerControls::update(Status &controls)
{
  ENTRYPOINT(update);
  SDL_PumpEvents();

  const Uint8 *keys = SDL_GetKeyState(0);


  bool keyboard_fire = keys[SDLK_RCTRL] || keys[SDLK_LCTRL];
  bool keyboard_right = keys[SDLK_RIGHT];
  bool keyboard_left = keys[SDLK_LEFT];
  bool keyboard_up = keys[SDLK_UP];
  bool keyboard_down = keys[SDLK_DOWN];

  if (keyboard_fire || keyboard_right || keyboard_left || keyboard_up || keyboard_down)
    {
      // change focus on keyboard if a key is pressed
      // this avoids conflicts between joystick and keyboard "first pressed" state
      m_focus_on_keyboard = true;
    }
  if (m_focus_on_keyboard)
    {
      controls.fire.pressed(keyboard_fire);
      controls.right.pressed(keyboard_right);
      controls.left.pressed (keyboard_left);
      controls.up.pressed(keyboard_up);
      controls.down.pressed (keyboard_down);
    }
  controls.esc_pressed = keys[SDLK_ESCAPE];

  #ifndef NDEBUG
  // debug keys
  controls.t_pressed = keys[SDLK_t]; // bonus time out
  controls.e_pressed = keys[SDLK_e]; // end level

  #endif

  SDL_JoystickUpdate();
  int horiz = joystick_get_axis(0);
  int vert = joystick_get_axis(1);
  bool joy_up = vert < -JOY_THRESHOLD;
  bool joy_down = vert > JOY_THRESHOLD;
  bool joy_left = horiz < -JOY_THRESHOLD;
  bool joy_right = horiz > JOY_THRESHOLD;
  bool joy_fire = joystick_get_button(0,0);

  if (joy_down || joy_up || joy_right || joy_left || joy_fire)
    {
      // change focus on joystick if joystick input detected
      m_focus_on_keyboard = false;
    }
  if (!m_focus_on_keyboard)
    {
      controls.right.pressed(joy_right);
      controls.left.pressed(joy_left);
      controls.down.pressed(joy_down);
      controls.up.pressed(joy_up);
      controls.fire.pressed(joy_fire);
    }

  EXITPOINT;

}


void PlayerControls::flush_events()
{

  SDL_Event event;

  while (SDL_PollEvent(&event));
}

PlayerControls::PlayerControls()
{
  joystick_init();
  m_focus_on_keyboard = false;
}

void PlayerControls::joystick_init()
{

  memset(table_joysticks,0,sizeof(table_joysticks));

  int numJoystick = SDL_NumJoysticks();
  int i;
  if (numJoystick > 4)
    {
      numJoystick = 4;
    }
  for (i=0 ; i < numJoystick ; i++)
    {

      table_joysticks[i] = SDL_JoystickOpen(i);

    }

}




PlayerControls::~PlayerControls()
{

  int numJoystick = SDL_NumJoysticks();
  int i;
  if (numJoystick > 4)
    {
      numJoystick = 4;
    }
  for (i=0 ; i < numJoystick ; i++)
    {

      SDL_JoystickClose(table_joysticks[i]);

    }
}

int PlayerControls::joystick_get_button(int button,int numjoy)
{
  int rval = 0;
  SDL_Joystick *j = table_joysticks[numjoy];
  if (j != 0)
    {
      rval = SDL_JoystickGetButton(j, button);
    }
  return rval;
}
int PlayerControls::joystick_get_axis(int axis,int numjoy)
{
  int rval = 0;
  SDL_Joystick *j = table_joysticks[numjoy];
  if (j != 0)
    {
      rval = SDL_JoystickGetAxis(j, axis);
    }
  return rval;
}
#endif
