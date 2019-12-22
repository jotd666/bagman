#ifndef JOYSTICKHANDLER_H_INCLUDED
#define JOYSTICKHANDLER_H_INCLUDED

#include "Abortable.hpp"
#include "SDL/SDL.h"

class JoystickHandler : public Abortable
{
    public:
    DEF_GET_STRING_TYPE(JoystickHandler);
    static int get_nb_joysticks();
    JoystickHandler(int joystick_number);
    ~JoystickHandler();
    void get_xy_moves(int &x, int &y);
    bool get_button_state(int i);
    void update();
    private:
    SDL_Joystick *m_handle;


};


#endif // JOYSTICKHANDLER_H_INCLUDED
