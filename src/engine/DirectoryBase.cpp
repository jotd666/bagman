#include "DirectoryBase.hpp"
#include "ScaleSize.hpp"

const MyString DirectoryBase::GFX_OBJECT_SET_EXTENSION = ".mos";
const MyString DirectoryBase::LEVEL_EXTENSION = ".mlv";

/*static */
MyString DirectoryBase::get_root()
{
#ifdef _NDS
#ifdef NDS_EMU
  // emulator with embedded data in .NDS file
  return "/";
#else
  // SD card with data in data/Bagman
  return "/data/Bagman";
#endif
#else
  // native mode
  return "resource";
#endif

}

MyString DirectoryBase::get_sound_path()
{
#ifdef _NDS
  return get_root();
#else
#ifdef __amigaos__
  return get_root() +"//resource/amiga/sfx";

#else
  return get_root() / "../sound";
#endif
#endif

}

MyString DirectoryBase::get_size_dir()
{
  #ifdef __amigaos__
  return "amiga";
  #else
  return "1x";
#endif

}


MyString DirectoryBase::get_tiles_path(bool images)
{
  MyString rval = get_root() / "tiles";
  if (images)
    {
      rval = rval / get_size_dir();
    }
  return rval;
}

MyString DirectoryBase::get_images_extension()
{
  #ifdef __amigaos__
  return ".raw";
  #else
  return ".bmp";
  #endif
}
MyString DirectoryBase::get_sound_extension()
{
  #ifdef __amigaos__
  return ".raw";
  #else
  return ".wav";
  #endif
}

MyString DirectoryBase::get_sprites_path()
{
  return get_root() / get_size_dir() / "sprites";
}
MyString DirectoryBase::get_images_path()
{
  return get_root() / get_size_dir() / "images";
}
MyString DirectoryBase::rework_path(const MyString &path,const MyString &leading_to_remove,
				    bool remove_root,bool remove_extension)
{
  MyString rval = path;

  if (remove_root)
    {
      rval = path.replace(leading_to_remove,"");
    }
  if (remove_extension)
    {
      int idx = rval.find_last_of(".");
      if (idx != -1)
	{
	  rval = rval.substr(0,idx);
	}

    }


  return rval;
}
