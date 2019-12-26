/*
    Copyright (C) 2010-2020 JOTD

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "TileGrid.hpp"
#include "ScaleSize.hpp"
#include "DirectoryBase.hpp"
#include "ImageFrame.hpp"
#include "MyFile.hpp"


static const int X_OFFSET = 0;
static const int Y_OFFSET = -16;

TileGrid::TileGrid(const GfxPalette *p)
{
  m_palette = p;
  init();
}

static const int WALL_X = 280;
static const int WALL_Y = 192;

void TileGrid::break_wall()
{
  m_wall_width-=2;
  change_wall(true);

}
void TileGrid::build_wall()
{
  m_wall_width = 12;
  change_wall(false);
}

inline void TileGrid::change_wall(bool clr)
{
  for (int j = WALL_Y; j < WALL_Y+16; j++)
    {
      for (int i = WALL_X; i < WALL_X+(10-m_wall_width); i++)
	{
	  m_matrix[j+Y_OFFSET][i+X_OFFSET] = clr ? PT_BACKGROUND : PT_BREAKABLE_WALL;
	}
    }
}

int TileGrid::get_ladder_x(int char_x, int char_y) const
{
  int rval = -1;

  for (int i = char_x; i < char_x+16; i++)
    {
      if (rval == -1)
	{
	  // find first x where theres a ladder
	  if (get_point_type(i,char_y) == TileGrid::PT_LADDER)
	    {
	      rval = i;
	      break;
	    }
	}

    }

  if (rval == char_x)
    {
      // was at the start: try to find the actual start

      int i = char_x;

      while(true)
	{

	  if (get_point_type(i,char_y) != TileGrid::PT_LADDER)
	    {
	      rval = i+1;
	      break;
	    }
	  else
	    {
	      i--;
	    }
	}

    }

  return rval;
}
TileGrid::PointType TileGrid::get_point_type(int x,int y) const
{
  return (PointType)m_matrix[y+Y_OFFSET][x+X_OFFSET];
}

inline const char *TileGrid::forward_to_linefeed(const char *contents)
{
  const char *rval = contents;
  while (*rval != 10)
    {
      if (*rval == 0)
	{
	  abort_run("End of stream encountered while seeking linefeed");
	}
      rval++;
    }
  rval++; // next char
  return rval;
}
void TileGrid::init()
{
  int current_x = 0;
  ControlMatrix &m = m_matrix;
  m.resize(256);
  for (int y = 0; y < (int)m.size(); y++)
    {
      ControlLine &l = m[y];
      l.resize(224*3+16,PT_OFF_BOUNDS); // add PT_OFF_BOUNDS on both sides
    }

  for (int i = 0; i < 3; i++)
    {
      // we're using a binary PPM file because with BMP there are palette problems
      // in 8-bit mode: with PPM we don't use SDL and it does not mess the logic image
      MyString mapfile = DirectoryBase::get_root() / "maps" / "playfield_" + MyString(i+1) + ".ppm";
      MyFile f(mapfile);
      StreamPosition file_len;
      char *contents = (char *)f.read_all(file_len);
      if (file_len == 0)
	{
	  abort_run("cannot load %q",mapfile);
	}
      if (strncmp(contents,"P6",2) != 0)
	{
	  abort_run("wrong format for PPM file %q",mapfile);
	}
      int w = 0;
      int h = 0;
      const unsigned char *bindata = 0;
      const char *l = contents;
      while(true)
	{
	  l = forward_to_linefeed(l);
	  if (l[0] != '#')
	    {
	      // not a comment
	      if (w == 0)
		{
		  if (sscanf(l,"%d%d",&w,&h) != 2)
		    {
		      abort_run("syntax error in PPM file %q");
		    }
		}
	      else
		{

		  // would read 255; OK
		  bindata = (const unsigned char *)forward_to_linefeed(l);
		  break;
		}
	    }
	}



      for (int y = 0; y < h; y++)
	{
	  ControlLine &l = m[y];
	  for (int x = 0; x < w; x++)
	    {
	      PointType pt = PT_BACKGROUND;
	      int r=*(bindata++);
	      int g=*(bindata++);
	      int b=*(bindata++);
	      int pv = (r<<16) + (g<<8) + b;

	      switch(pv)
		{
		  case 0:

		    break;
		  case 0xFF0000:
		    pt = PT_HANDLE;
		    break;
		  case 0xFFFF00:
		    pt = PT_BREAKABLE_WALL;
		    break;
		  case 0x00FF00:
		    pt = PT_LADDER;
		    break;
		  case 0xFFFFFF:
		    pt = PT_WALL;
		    break;
		  default:
		    abort_run("unknown pixel type at screen %d (%d,%d): %x",(i+1),x,y,pv);
		    break;
		}

	      l[x+current_x+16] = pt;
	    }
	}
      current_x += 224;
      LOGGED_DELETE(contents);
    }
}

void TileGrid::render(Drawable &screen, int current_screen, bool show_all_screens) const
{

  if (show_all_screens)
    {
      m_palette->playfield[current_screen].render(screen,16+current_screen*224,0);

    }
  else
    {
      m_palette->playfield[current_screen].render(screen,16,16);
    }

}
void TileGrid::render(Drawable &screen, int current_screen, const SDLRectangle &bounds) const
{

  SDLRectangle target_bounds = bounds;
  target_bounds.x += 16;
  target_bounds.y += 16;
  //screen.fill_rect(&target_bounds,0);
  m_palette->playfield[current_screen].render(screen,&bounds,&target_bounds);
}



int TileGrid::get_rounded_x(int x) const
{
  int floor_x = x & 0xFFF8;
  return x-floor_x < 4 ? floor_x : floor_x+8;
}
int TileGrid::get_rounded_y(int y) const
{

  return (int)y;
}
int TileGrid::get_rounded_y(int y, bool ceil) const
{

  return ceil ? (int)y+1 : (int)y;
}
int TileGrid::get_rounded_x(int x, bool ceil) const
{
  int rval =  (x & 0xFFF8);
  return ceil ? rval+8 : rval;
}
bool TileGrid::is_vertical_clear(int x,int y,int dy) const
{
  bool rval = true;
  int direction = dy < 0 ? -4 : 4;
  int yy = (y / 4) * 4;  // round it
  int end_y = ((y+dy) / 4) * 4;
  while (yy != end_y)
    {
      // ignore the ladders
      if (is_lateral_way_blocked(x,yy))
	{
	  rval = false;
	  break;
	}
      yy += direction;
    }

  return rval;
}
bool TileGrid::is_horizontal_clear(int x,int y,int dx) const
{
  bool rval = true;
  int direction = dx < 0 ? -4 : 4;
  int xx = (x / 4) * 4;  // round it
  int end_x = ((x+dx) / 4) * 4;
  while (xx != end_x)
    {
      if (is_lateral_way_blocked(xx,y))
	{
	  rval = false;
	  break;
	}
      xx += direction;
    }
  return rval;
}

inline bool TileGrid::is_way_blocked(int x,int y,int mask) const
{
  int x_test = x+X_OFFSET;
  int y_test = y+Y_OFFSET;
  bool rval = y_test >= 0;
  if (rval)
    {
      rval = false;
      const ControlLine &cl = m_matrix[y_test];
      rval = (x_test>=0) && (x_test<(int)cl.size());
      if (rval)
	{
	  char pt = cl[x_test];
	  rval = (pt & mask);
	}
    }
  return rval;
}
bool TileGrid::is_lateral_way_blocked(int x,int y) const
{
  return is_way_blocked(x,y,PT_WALL|PT_BREAKABLE_WALL|PT_OFF_BOUNDS);
}

bool TileGrid::is_vertical_way_blocked(int x,int y) const
{
  return is_way_blocked(x,y,PT_WALL|PT_BREAKABLE_WALL|PT_LADDER|PT_OFF_BOUNDS);
}

int TileGrid::get_w() const
{
  return m_matrix[0].size();
}

bool TileGrid::is_below_handle(int x, int y) const
{
  bool rval = false;
  int my = y+Y_OFFSET-2;
  if (my>0)
    {


      const ControlLine &cl = m_matrix[my];
      int mx =  x+X_OFFSET;
      //for (int i = mx; i < mx+w; i++)

      if ((mx>=0) && (mx<(int)cl.size()) && (cl[mx] == PT_HANDLE))
	{
	  rval = true;
	}
      //debug("TEST GRIP x=%d, res=%b, neigh=%d,%d",mx,rval,(int)cl[mx-1],(int)cl[mx+1]);
    }
  return rval;
}

bool TileGrid::can_climb_down(int x,int y) const
{
  bool rval = false;
  ENTRYPOINT(can_climb_down);
  int my = y+Y_OFFSET;
  const ControlLine &cl = m_matrix[my];
  int mx =  x+X_OFFSET;
  //for (int i = mx; i < mx+w; i++)

  if ((mx>=0) && (mx<(int)cl.size()))
    {
      rval =  cl[mx] == PT_LADDER;
    }
  EXITPOINT;
  return rval;

}
bool TileGrid::can_climb_up(int x,int y) const
{
  int my = y+Y_OFFSET;
  bool rval = my >= 0;
  ENTRYPOINT(can_climb_up);
  if (rval)
    {
      rval = false;
      const ControlLine &cl = m_matrix[my];
      int mx =  x+X_OFFSET;
      //for (int i = mx; i < mx+w; i++)

      if ((mx>=0) && (mx<(int)cl.size()))
	{
	  rval = (cl[mx] == PT_LADDER);
	}
    }
  EXITPOINT;
  return rval;

}

bool TileGrid::is_lateral_way_blocked(int x, int y, int h) const
{
  bool rval = false;

  for (int i = 0; i < h; i++)
    {
      if (is_lateral_way_blocked(x,y+i))
	{
	  rval = true;
	  break;
	}
    }
  return rval;
}
