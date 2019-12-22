#ifndef FADEINEVENT_H_INCLUDED
#define FADEINEVENT_H_INCLUDED

#include "FadeEvent.hpp"

class FadeInEvent : public FadeEvent
{
    public:
    DEF_GET_STRING_TYPE(FadeInEvent);

    FadeInEvent( int duration = 0);


    void on_update(int );

};


#endif // FADEOUTEVENT_H_INCLUDED
