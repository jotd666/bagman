#ifndef GFXFRAME_H
#define GFXFRAME_H

#include "Locatable.hpp"
#include "ImageFrame.hpp"
#include "AnimatedObject.hpp"

class PrmIo;

/**
 * contains one animation frame
 * does not have x,y information
 */

class GfxFrame // : public Locatable
{

public:

  enum SymmetryType { mirror_left, mirror_right, flip_up, no_op_clone, no_symmetry };

  int get_w() const
  {
    return m_w;
  }
  int get_h() const
  {
    return m_h;
  }



  class Properties
  {
    public:

    Properties();

    int update_rate;
    AnimatedObject::Type animation_type;

    private:

  };



  GfxFrame();

  void init(const GfxFrame &symmetric, SymmetryType st);

  void init(const MyString &image_path, int transparent_color, bool rotate_90);

  //GfxFrame(const ImageFrame &source,const Properties &p,const SDL_Rect &r,int counter = 0);

  const ImageFrame &to_image() const
  {
    return m_image;
  }

  void render(Drawable &screen, int x, int y) const
  {
    return m_image.render(screen,x,y);
  }

  inline const Properties &get_properties() const
  {
    return m_properties;
  }
private:
  ImageFrame m_image;
  int m_transparent_color;
  int m_w;
  int m_h;
  Properties m_properties;

};

#endif

