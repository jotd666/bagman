#ifndef FADEEVENT_H_INCLUDED
#define FADEEVENT_H_INCLUDED

#include "TimerEvent.hpp"

class FadeEvent : public TimerEvent
{
public:
    FadeEvent();
    void on_timeout();
    inline int get_coeff() const
    {
        return m_alpha;
    }
    virtual void init(int start_time, int duration);

    virtual int get_final_value() const;
protected:
    int m_alpha;
private:
    bool m_second_chance_timeout;

};


#endif // FADEOUTEVENT_H_INCLUDED
