#pragma once


#define LOGGED_FCLOSE(f) fclose(f); f = 0

#if defined NDEBUG || defined _NDS || defined __amigaos__ || defined NO_MEMORY_LOG
#define LOGGED_MEMORY_START ((void)0)
#define LOGGED_MANUAL_ALLOC(expr) ((void)0)
#define LOGGED_MANUAL_DELETE(addr) ((void)0)
#define LOGGED_NEW(addr,expr) addr = new expr
#define LOGGED_DELETE(expr) delete expr; expr = 0
#define LOGGED_DELETE_ARRAY(expr) delete [] expr; expr = 0
#define NO_LOGGED_MEMORY 1

#else
	
#include "MemoryEntry.hpp"
#include <map>

#define LOGGED_MEMORY_START MemoryEntryMap::instance().start_logging()
#define LOGGED_MANUAL_ALLOC(expr) MemoryEntryMap::instance().logged_new(__FILE__,__LINE__,#expr,expr)
#define LOGGED_MANUAL_DELETE(expr) MemoryEntryMap::instance().logged_delete(__FILE__,__LINE__,#expr,expr)
#define LOGGED_NEW(addr,expr) addr = new expr;MemoryEntryMap::instance().logged_new(__FILE__,__LINE__,#expr,addr)
#define LOGGED_DELETE(expr) MemoryEntryMap::instance().logged_delete(__FILE__,__LINE__,#expr,expr); delete expr, expr = 0
#define LOGGED_DELETE_ARRAY(expr) MemoryEntryMap::instance().logged_delete(__FILE__,__LINE__,#expr,expr); delete [] expr; expr = 0


class MemoryEntryMap
{
public:
  static MemoryEntryMap &instance();
  void logged_new(const char *fname,
		  const int line_number,const char *message, void *addr);
  void logged_delete(const char *fname,
		     const int line_number,const char *message, void *addr);

  void start_logging()
  {
    m_logging_enabled = true;
  }

  void dump_allocated() const;
private:
  MemoryEntryMap();
  typedef std::map<void *,MemoryEntry> List;
  List m_items;
  bool m_logging_enabled;

};
#endif

