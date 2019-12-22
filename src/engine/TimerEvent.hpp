#ifndef TIMEREVENT_H_INCLUDED
#define TIMEREVENT_H_INCLUDED

#include "Abortable.hpp"

class TimerEvent : public Abortable
{

protected:
  bool m_timeout_reached;
  int m_start_time;
  int m_duration;
  int m_elapsed;
  bool m_forced;
public:
  DEF_GET_STRING_TYPE(TimerEvent);

  TimerEvent() : m_start_time(0), m_duration(0)
  {
    reset();
  }

  virtual void init(int start_time, int duration)
  {
    m_start_time = start_time;
    m_duration = duration;
    reset();
  }

  void reset()
  {
    m_timeout_reached = false;
    m_elapsed = 0;
    m_forced = false;
  }

  inline bool is_forced() const
  {
    return m_forced;
  }
  inline void force()
  {
    m_start_time = m_elapsed;
    m_forced = true;
  }
  inline bool is_timeout_reached() const
  {
    return m_timeout_reached;
  }

  inline bool is_running() const
  {
    return !m_timeout_reached && m_elapsed > m_start_time;
  }

  virtual ~TimerEvent() {}
  virtual void on_timeout()
  {}

  virtual void on_update(int ) {}

  void update(int elapsed)
  {
    m_elapsed += elapsed;
    if (is_running())
      {
	if (m_elapsed >= m_duration + m_start_time)
	  {
	    m_timeout_reached = true;
	    ENTRYPOINT(on_timeout);
	    on_timeout();
	    EXITPOINT;
	  }
	else
	  {
	    ENTRYPOINT(on_update);
	    on_update(elapsed);
	    EXITPOINT;
	  }
      }

  }

};

#endif // TIMEREVENT_H_INCLUDED
