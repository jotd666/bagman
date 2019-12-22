#ifndef ANIMATEDSPRITE_H_INCLUDED
#define ANIMATEDSPRITE_H_INCLUDED

#include "AnimatedObject.hpp"
#include "MyVector.hpp"
#include "GfxFrame.hpp"

class GfxFrameSet;

/**
 * animated object/character on screen
 */

class AnimatedSprite : public AnimatedObject
{
public:
  DEF_GET_STRING_TYPE(AnimatedSprite);

  AnimatedSprite();

  virtual void set_anim_type(Type anim_type);

  /**
   * init the object
   * @param frame_set frame set
   * @param pos_ref (opt) object to follow
   */

  void init(const GfxFrameSet *frame_set, const Locatable *pos_ref = 0);

  const GfxFrame::Properties &get_properties() const;

  /** set xy offset / followed object
   * @param x_offset offset if object to follow
   * @param y_offset offset if object to follow
   */
  void set_xy_render_offset(int x_offset, int y_offset);

  void set_xy_render_extra_offset(int x_offset, int y_offset)
   #ifdef __amigaos
  {(void)x_offset;(void)y_offset;}  // define as empty
#else
  ;
  #endif

  /**
   * update the animation
   * @param elapsed time in millis since last update
   */

  void update(int elapsed);

  /**
   * render the sprite in the screen
   */

  void render(Drawable &screen, int frame_number) const;

  /**
   * render the sprite in the screen
   */

  void render(Drawable &screen) const;

  /**
   * set the set of frames that the sprite uses
   */

  void set_frame_set(const GfxFrameSet *frame_set);

  inline int get_update_rate() const
  {
    return m_update_rate;
  }


  void set_render_scale(int scale);


  void set_update_rate(int update_rate);
private:

  const GfxFrameSet *m_frames = nullptr;
  int m_update_rate = 0;
  int m_elapsed = 0;
  int m_x_render_offset = 0;
  int m_y_render_offset = 0;
  #ifndef __amigaos__
  int m_x_render_extra_offset = 0;
  int m_y_render_extra_offset = 0;
  #endif


};

#endif // ANIMATEDSEQUENCE_H_INCLUDED
