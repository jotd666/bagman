#ifndef DIRECTORYBASE_H
#define DIRECTORYBASE_H

#include "MyString.hpp"
#include "MyMacros.hpp"

class DirectoryBase
{
public:
  static const MyString GFX_OBJECT_SET_EXTENSION;
  static const MyString LEVEL_EXTENSION;

  static MyString get_misc_path()
  {
    return get_root() / "misc";
  }

  static MyString get_sound_path();

  static MyString get_tiles_path(bool images);

  static MyString get_images_extension();
  static MyString get_sound_extension();

  static MyString get_snapshot_path()
  {
    return get_root() / "snapshots";
  }

  /*static public void env_check() throws Exception
    {
      if (get_root() == null)
	  {
	      m_root = "D:\\jff_data\\MagicPockets\\";
	      //throw new Exception(ROOT_DIR_VARIABLE+" has not been set");
	  }
    }*/

  // returns 1x or 2x

  static MyString get_size_dir();

  static MyString get_root();

  static MyString get_images_path();
  static MyString get_sprites_path();



  static MyString rework_path(const MyString &path,const MyString &leading_to_remove,
			      bool remove_root = false,bool remove_extension = false);

private:
  DEF_CLASS_COPY(DirectoryBase);
};
#endif

