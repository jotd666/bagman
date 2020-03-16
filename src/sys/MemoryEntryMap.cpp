#include "MemoryEntryMap.hpp"
#ifdef NO_LOGGED_MEMORY

#else
	

#include "MyString.hpp"

#include <cstdio>
#include <new>
#include <stdlib.h>

static MemoryEntryMap *m_instance = 0;

// to log all memory, set logging_enabled to true right
MemoryEntryMap::MemoryEntryMap() : m_logging_enabled(false)
{
}

void allocation_failure()
{
  fprintf(stderr,"new handler invoked due to new failure\n");
  exit(1);
}



MemoryEntryMap &MemoryEntryMap::instance()
{
  if (m_instance == 0)
    {
      m_instance = new MemoryEntryMap();

      std::set_new_handler(allocation_failure);
    }
  return *m_instance;
}

void MemoryEntryMap::logged_new(const char *fname,
				const int line_number,const char *message, void *addr)
{
  if (m_logging_enabled)
    {
      MemoryEntry me(line_number, fname, message, addr);
      m_items.insert(std::make_pair(addr,me));
    }
}


void MemoryEntryMap::logged_delete(const char *fname,
				   const int line_number,const char *message, void *addr)
{
  (void)message;
  if (m_logging_enabled && addr != 0)
    {
      List::iterator it = m_items.find(addr);
      if (it != m_items.end())
	{
	  // found the item
	  m_items.erase(it);
	}
      else
	{
	  fprintf(stderr,"%s:%d: Address %p freed twice (or unlogged)\n",MyString(fname).basename().c_str(),line_number,addr);
	  //my_assert(1==0);
	}
    }
}

#include <SDL/SDL.h>

void MemoryEntryMap::dump_allocated() const
{
  List::const_iterator it;
  //int img_count = 0;
  for (it = m_items.begin();it != m_items.end(); it++)
    {
      const MemoryEntry &me = it->second;
      MyString fb(me.filename.c_str());
      fb = fb.basename();
      /*if (fb == "ImageUtil.cpp")
	{
	  SDL_Surface *s = (SDL_Surface *)me.address;
	  SDL_SaveBMP(s,(MyString("alloc_img_")+img_count+".bmp").c_str());
	  img_count++;
	  // fprintf(stderr,"String value: \"%s\"\n",(const char*)me.address);
	}
	else*/
      {
	fprintf(stderr,"allocated: %p (%s) at %s:%d\n",
		me.address,me.item.c_str(),
		fb.c_str(),
		me.line);
      }


    }
  fprintf(stderr,"total allocated: %zu blocks\n",m_items.size());
}
#endif
