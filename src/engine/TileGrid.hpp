#ifndef TILEGRID_H_INCLUDED
#define TILEGRID_H_INCLUDED

#include "Abortable.hpp"
#include "GfxPalette.hpp"
#include "MyMacros.hpp"
#include "MyVector.hpp"

class Drawable;

class TileGrid : public Abortable
{
public:
  DEF_GET_STRING_TYPE(TileGrid);
  TileGrid(const GfxPalette *p);

  void render(Drawable &screen, int current_screen, bool show_all_screens) const;

  void render(Drawable &screen, int current_screen, const SDLRectangle &bounds) const;

  int get_w() const;
  enum PointType { PT_BACKGROUND=1,
    PT_LADDER=1<<1, PT_HANDLE=1<<2,
    PT_WALL=1<<3, PT_BREAKABLE_WALL=1<<4, PT_OFF_BOUNDS=1<<5 };
  PointType get_point_type(int x,int y) const;

  void break_wall();
  void build_wall();


  bool is_below_handle(int x, int y) const;

  bool can_climb_up(int x,int y) const;
  bool can_climb_down(int x,int y) const;

  int get_rounded_x(int x) const;
  int get_rounded_y(int y) const;
  int get_rounded_y(int y, bool ceil) const;
  int get_rounded_x(int x, bool ceil) const;


  int get_ladder_x(int char_x, int char_y) const;

  bool is_vertical_clear(int x,int y,int dy) const;
  bool is_horizontal_clear(int x,int y,int dx) const;
  bool is_vertical_way_blocked(int x,int y) const;
  bool is_lateral_way_blocked(int x, int y, int h) const;
  bool is_lateral_way_blocked(int x, int y) const;
private:
  void change_wall(bool clr);
  bool is_way_blocked(int x,int y,int mask) const;
  void init();

  const GfxPalette *m_palette;

  typedef MyVector<char> ControlLine;
  typedef MyVector<ControlLine> ControlMatrix;

  ControlMatrix m_matrix;
  const char *forward_to_linefeed(const char *contents);

  int m_wall_width = 0;
  DEF_CLASS_COPY(TileGrid);
};
#endif // TILEGRID_H_INCLUDED
