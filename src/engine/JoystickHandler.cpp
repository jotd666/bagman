#include "JoystickHandler.hpp"
#include "SDL/SDL.h"

int JoystickHandler::get_nb_joysticks()
{
  return SDL_NumJoysticks();
}

JoystickHandler::~JoystickHandler()
{
    if (m_handle != 0)
    {
        SDL_JoystickClose(m_handle);
    }
}

void JoystickHandler::update()
{
     SDL_JoystickUpdate();
}
bool JoystickHandler::get_button_state(int i)
{
    return SDL_JoystickGetButton(m_handle, i) != 0;
}

void JoystickHandler::get_xy_moves(int &x, int &y)
{
    x = SDL_JoystickGetAxis(m_handle, 0);
    y = SDL_JoystickGetAxis(m_handle, 1);
}

JoystickHandler::JoystickHandler(int joystick_number)
{
    m_handle = 0;

   if (joystick_number < get_nb_joysticks())
   {
        m_handle = SDL_JoystickOpen(joystick_number);
        if (m_handle == 0)
        {
            abort_run("cannot open joystick #%d",joystick_number);
        }
    }
    else
    {
        abort_run("request joystick #%d, only %d available",joystick_number,get_nb_joysticks());
    }
}
