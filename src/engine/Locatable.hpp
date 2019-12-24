#ifndef LOCATABLE_H_INCLUDED
#define LOCATABLE_H_INCLUDED

#include "Abortable.hpp"
#include "SDLRectangle.hpp"

/**
 * base object for things that go on screen
 * there's a specific get_current_screen method here for Bagman game
 */

class Locatable : public Abortable
{
public:
  virtual ~Locatable() {}

  DEF_GET_STRING_TYPE(Locatable);

  Locatable(int x = 0, int y = 0, int w = 0, int h = 0);

  inline void set_xy(int x, int y)
  {
    set_x(x);
    set_y(y);
  }

  inline void set_x_center(int x_center)
  {
    set_x(x_center - m_rect.w/2);
  }
  inline void set_y_center(int y_center)
  {
    set_y(y_center - m_rect.h/2);
  }
  inline int get_x_center() const
  {
    return (int)(m_x + m_rect.w/2.0);
  }
  inline int get_y_center() const
  {
    return (int)(m_y + m_rect.h/2.0);
  }

  inline void set_x(int x)
  {
    m_rect.x = (int)x;
    m_x = x;
  }
  inline void set_y(int y)
  {
    m_rect.y = (int)y;
    m_y = y;
  }

  inline void add_x(int dx)
  {
    m_x += dx;
    m_rect.x = (int)m_x;
  }
  inline void add_y(int dy)
  {
    m_y += dy;
    m_rect.y = (int)m_y;
  }

  inline void set_w(int w)
  {
    m_rect.w = w;
  }

  inline void set_h(int h)
  {
    m_rect.h = h;
  }

  inline int get_y() const
  {
    return m_y;
  }

  inline int get_x() const
  {
    return m_x;
  }
  inline int get_h() const
  {
    return m_rect.h;
  }
  inline int get_w() const
  {
    return m_rect.w;
  }

  inline void set_centered_location(const Locatable &other)
  {
    set_x_center(other.get_x_center());
    set_y_center(other.get_y_center());
  }

  inline void set_location(const Locatable &other)
  {
    set_x(other.m_x);
    set_y(other.m_y);
  }

  inline const SDLRectangle &get_bounds() const
  {
    return m_rect;
  }
  int square_distance_to(const Locatable &go) const;

  /*    int get_x_screen() const
	{
	  return m_x % 224;
	}*/
  int get_current_screen(int offset=0) const
  {
    return (m_x-0x10+offset) / 224;
  }
  // slightly different from get_current_screen(): returns true also if partially on the screen
  bool is_in_screen(int screen) const;

private:
  int m_x;
  int m_y;
  SDLRectangle m_rect;
};

#endif // LOCATABLE_H_INCLUDED
