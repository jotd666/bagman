#include "GfxFrame.hpp"
#include "ScaleSize.hpp"



GfxFrame::Properties::Properties()
{
  animation_type = AnimatedObject::CUSTOM;
  update_rate = 0;
}

GfxFrame::GfxFrame()
{
  // invalid empty object

  m_w = 0;
  m_h = 0;
  /*    set_w(0);
	set_h(0);
	set_xy(0,0);*/
}
void GfxFrame::init(const MyString &image_path, int transparent_color, bool rotate_90)
{
  m_image.load(image_path,SCALE_SIZE*100);

  if (rotate_90)
    {
      m_image.rotate_90(true);
    }
  m_image.set_transparency(transparent_color);
  m_w = m_image.get_w();
  m_h = m_image.get_h();
  m_transparent_color = transparent_color;
}

void GfxFrame::init(const GfxFrame &symmetric, SymmetryType st)
{

  m_properties = symmetric.get_properties();

  m_w = symmetric.get_w();
  m_h = symmetric.get_h();

  m_transparent_color = symmetric.m_transparent_color;


  m_image.create(get_w(),get_h(),symmetric.m_image.get_alpha());
  m_image.set_transparency(m_transparent_color);


  switch (st)
    {
      case mirror_left:
      case mirror_right:
	symmetric.to_image().render_mirror(m_image);
	break;
      case flip_up:
	symmetric.to_image().render_flip(m_image);
	break;
      case no_op_clone:
	m_image = symmetric.to_image();
	break;
      default:
	break;
    }




  // black with R=0, G=0, B=1 is converted to a light alpha shade
#if DISPLAY_DEPTH > 8
  m_image.replace_color(0xFF000001, 0xA0000000);
#endif

}
