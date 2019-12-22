#ifndef RANDOMEVENT_H_INCLUDED
#define RANDOMEVENT_H_INCLUDED

#include "TimerEvent.hpp"

class RandomEvent : public TimerEvent
{
   public:
   RandomEvent(int period, double probability);

   bool has_event();

    protected:
   virtual void on_timeout();
    private:
      int m_probability;
      int m_period;
      bool m_has_event;
};

#endif // RANDOMEVENT_H_INCLUDED
