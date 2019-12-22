#ifndef FADEOUTEVENT_H_INCLUDED
#define FADEOUTEVENT_H_INCLUDED

#include "FadeEvent.hpp"

class FadeOutEvent : public FadeEvent
{
    public:
    DEF_GET_STRING_TYPE(FadeOutEvent);
    FadeOutEvent();
    int get_final_value() const;

    void on_update(int );

};


#endif // FADEOUTEVENT_H_INCLUDED
