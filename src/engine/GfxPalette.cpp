#include "GfxPalette.hpp"
#include "DirectoryBase.hpp"
#include "ScaleSize.hpp"

void GfxPalette::add_frame(GfxFrameSet &gfs,const MyString &name)
{
  GfxFrame *g = gfs.add_frame();
  g->init(make_sprite_name(name),0,m_rotate_90);
}

void GfxPalette::load_image(ImageFrame &img, const MyString &image_basename)
{
  debug("loading image: %s",image_basename);

  MyString image_dir = DirectoryBase::get_images_path();
  MyString n = image_dir / image_basename+DirectoryBase::get_images_extension();
  img.load(n,SCALE_SIZE*100);
  if (m_rotate_90)
    {
      img.rotate_90(true);
    }

  img.set_transparency(0xFF00FF); // no transparency (no magenta in the image)
}
GfxPalette::GfxPalette(bool rotate_90) : m_rotate_90(rotate_90)
{
  ENTRYPOINT(ctor);
  m_sprites_dir = DirectoryBase::get_sprites_path();

  playfield.resize(3);


  load_image(title,"bagman_title");
  load_image(va_logo,"va_logo");
  load_image(presents,"presents");
  load_image(life,"life");

  for (int i = 0; i < 3; i++)
    {
      load_image(playfield[i],"playfield_"+MyString(i+1));
    }


  init_character_lr(player,"player",3);
  add_frame(player.right,"player_fall");
  add_frame(player.left,"player_fall");
  init_character_lr(guard,"guard",3);
  init_character_lr(held_pickaxe,"pickaxe",2);

  add_frame(yellow_bag,"yellow_bag");
  add_frame(yellow_bag,"yellow_bag_right");
  GfxFrame *sg = yellow_bag.add_frame();
  sg->init(yellow_bag.get_frame(1),GfxFrame::mirror_left);


  add_frame(blue_bag,"blue_bag");
  add_frame(blue_bag,"blue_bag_right");
  sg = blue_bag.add_frame();
  sg->init(blue_bag.get_frame(1),GfxFrame::mirror_left);

  add_frame(wagon,"wagon");
  add_frame(wagon,"wagon_with_player");
  add_frame(pickaxe,"pickaxe");
  add_frame(barrow,"barrow_1");
  add_frame(barrow,"barrow_2");

  add_frame(guard_special,"guard_climb_1");
  add_frame(guard_special,"guard_climb_2");
  add_frame(guard_special,"guard_dead_1");
  add_frame(guard_special,"guard_dead_2");
  add_frame(guard_special,"guard_fall");
  add_frame(guard_special,"guard_crash_1");
  add_frame(guard_special,"guard_crash_2");
  add_frame(guard_special,"guard_crash_3");

  add_frame(player_special,"player_climb_1");
  add_frame(player_special,"player_climb_2");
  add_frame(player_special,"player_dead_1");
  add_frame(player_special,"player_dead_2");
  add_frame(player_special,"player_fall");
  add_frame(player_special,"player_crash_1");
  add_frame(player_special,"player_crash_2");
  add_frame(player_special,"player_crash_3");

  add_frame(player_special,"player_cling_1");
  add_frame(player_special,"player_cling_2");

  add_frame(elevator_red,"elevator_red");
  add_frame(elevator_orange,"elevator_orange");
  add_frame(wire,"wire");

  for (int i = 0; i < 5; i++)
    {
      add_frame(wall_break,MyString("wall_break_")+i);
    }

  EXITPOINT;
}

void GfxPalette::init_character_lr(LeftRight &lr,const MyString &id,int nb_frames)
{
  for (int i = 0; i < nb_frames; i++)
    {
      MyString image_name = make_sprite_name(id+"_right_"+MyString(i+1));
      GfxFrame *g = lr.right.add_frame();
      g->init(image_name,0,m_rotate_90);
      GfxFrame *sg = lr.left.add_frame();
      if (m_rotate_90)
	{
	  sg->init(*g,GfxFrame::flip_up);
	}
      else
	{
	  sg->init(*g,GfxFrame::mirror_left);

	}
    }

}

MyString GfxPalette::make_sprite_name(const MyString &n) const
{
  return m_sprites_dir / n+DirectoryBase::get_images_extension();
}
