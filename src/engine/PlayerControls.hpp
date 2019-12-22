#ifndef PLAYERCONTROLS_H_INCLUDED
#define PLAYERCONTROLS_H_INCLUDED

#include "Abortable.hpp"
#ifndef _NDS
#include "SDL/SDL.h"
#endif

class PlayerControls : public Abortable
{
public:
    DEF_GET_STRING_TYPE(PlayerControls);

    PlayerControls();
    ~PlayerControls();

    void joystick_init();

    class Status
    {
    public:
        class Bistatus
        {
        public:
            Bistatus() : m_pressed(false), m_was_pressed(false)
            {}

            inline void pressed(bool s)
            {
                m_was_pressed = m_pressed;
                m_pressed = s;
            }
            inline bool was_pressed() const
            {
                return m_was_pressed;
            }
            inline bool is_pressed() const
            {
                return m_pressed;
            }
            inline bool is_first_pressed() const
            {
                return m_pressed && !m_was_pressed;
            }
        private:
            bool m_pressed;
            bool m_was_pressed;
        };

        Bistatus right;
        Bistatus left;
        Bistatus up;
        Bistatus down;
        Bistatus fire;
        bool esc_pressed;
#ifndef NDEBUG
        bool t_pressed;
        bool e_pressed;
#endif
        Status();
    };

    void update(Status &s);
    void flush_events();
private:
    int joystick_get_button(int button,int numjoy = 0);

    int joystick_get_axis(int axis, int numjoy = 0);
    bool m_focus_on_keyboard;
#ifndef _NDS
    SDL_Joystick *table_joysticks[4];
#endif

};


#endif // PLAYERCONTROLS_H_INCLUDED
