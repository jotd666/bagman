#include "Abortable.hpp"
#include "string.h"
#include <cassert>
#include <cerrno>
#include <list>

#include <stdlib.h>
#include <stdio.h>


#ifdef _HAS_THREADS
#include "ThreadSafeContainer.hpp"
typedef std::map<FunctionId,FunctionTimer> NameSortProfilerTable;
static ThreadSafeContainer<NameSortProfilerTable> m_profiler_table_list; ///< custom profiling
class DebugMutex : public ThreadSafe
{
};


static DebugMutex m_debug_mutexes; ///< non-interrupted debug print

#endif

int Abortable::m_debug_level =  0;

#ifdef _NDS
#define STDERR stdout
#else
#define STDERR stderr
#endif

// JFF: works in a multithreaded environment: there is one stacktrace per thread

using namespace std;

static int m_symbolic_name = 10;

class EntryPointList
{
public:
  EntryPointList() : symbolic_name(m_symbolic_name++)
  {}

  typedef std::list<Abortable::EntryPoint> Stack;

  int symbolic_name;
  Stack call_stack;
};


// thread-protected lists



#ifdef _HAS_THREADS

static ThreadSafeContainer<EntryPointList> m_stack_map; ///< per-thread stacks

static EntryPointList &m_entrypoint_list()
{
  return m_stack_map.get();
}

static EntryPointList::Stack &m_stack()
{
  return m_entrypoint_list().call_stack;
}

static inline void stack_push(const Abortable::EntryPoint &ep)
{
  m_stack().push_front(ep);
}

static void print_thread_context(FILE *os)
{
  if (m_stack_map.size() > 1)
    {
      // multithread context added

      fprintf(os,"%d: ",m_entrypoint_list().symbolic_name);
    }
}
#else

#endif

#ifndef _HAS_THREADS


static inline void s_warn(const MyString &m1,const MyString &m2)
{
  printf("** Warning: %s%s\n",m1.c_str(),m2.c_str());
}
static inline void s_err(const MyString &m1,const char *m2)
{
  printf("** Error: %s%s\n",m1.c_str(),m2);
}
#else
#if defined NDEBUG and defined _WIN32

#include <windows.h>
static inline void s_warn(const MyString &m1,const MyString &m2)
{
  MessageBox(0,m2.c_str(),m1.c_str(),MB_ICONWARNING);
}
static inline void s_err(const MyString &m1,const char *m2)
{
  MessageBox(0,m2,m1.c_str(),MB_ICONERROR);
}

#else
static inline void s_warn(const MyString &m1,const MyString &m2)
{

  // JFF: ensure that the messages will be displayed without
  // being interrupted by other threads

  m_debug_mutexes.cs_start();
  print_thread_context(STDERR);

  fprintf(STDERR,"** Warning: %s%s\n",m1.c_str(),m2.c_str());
  fflush(STDERR);


  m_debug_mutexes.cs_end();
}
static inline void s_err(const MyString &m1,const char *m2)
{
  // JFF: ensure that the messages will be displayed without
  // being interrupted by messages from other threads

  m_debug_mutexes.cs_start();
  print_thread_context(STDERR);

  fprintf(STDERR,"** Error: %s%s\n",m1.c_str(),m2);
  fflush(STDERR);


  m_debug_mutexes.cs_end();

}
#endif
#endif

#define MAX_ARGCOUNT 20
#define MSG_ARG_PROTO \
const MyString &message,			\
		  const MyString &arg1,	\
		  const MyString &arg2,	\
		  const MyString &arg3,	\
		  const MyString &arg4,	\
		  const MyString &arg5,	\
		  const MyString &arg6,	\
		  const MyString &arg7, \
		  const MyString &arg8, \
		  const MyString &arg9, \
		  const MyString &argA

#define MSG_ARG_LIST arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,argA

Abortable::Abortable(const MyString &name, bool user_level_object) :
m_name(name),
m_user_level_object(user_level_object)
{
}


#ifdef _HAS_THREADS

/* static */ bool Abortable::is_within_context(const char *object_name, bool by_class)
{
  bool rval = false;

  std::list<EntryPoint>::const_iterator it;
  EntryPointList::Stack &stk = m_stack();

  for (it = stk.begin();it != stk.end() && !rval;it++)
    {
      // JFF: we use strcmp in order to avoid to build an object

      rval = (strcmp(by_class ?
		     it->m_class.c_str() :
		     it->m_name.c_str(),object_name) == 0);
    }

  return rval;
}
#endif

#ifndef _HAS_THREADS

const Abortable::EntryPoint Abortable::get_current_entrypoint() const
{
  return EntryPoint(this,"?","?",undefined_integer,0);
}
void Abortable::set_name(const MyString &name)
{
  m_name = name;
}
bool Abortable::pop_stack_to_current() const
{
  return false;
}
#else
const Abortable::EntryPoint &Abortable::get_current_entrypoint() const
{
  static const EntryPoint dummy_entry(this,"?","?",0,0);

  EntryPointList::Stack &stk = m_stack();
  return stk.empty() ? dummy_entry : *(stk.begin());
}
/* static */
MyString Abortable::stack_trace()
{
  MyString rval("\nCustom Stacktrace:\n\n");
  std::list<EntryPoint>::const_iterator it;
  EntryPointList::Stack &stk = m_stack();

  if (!stk.empty())
    {
      it = stk.begin();

      while (it != stk.end())
	{
	  const EntryPoint &ep = *it;
	  rval += MyString(ep.m_name) + "(" + ep.m_class + ")::" +
	  ep.m_method + " (called from: "+MyString(ep.m_filename).basename()+
	  " entrypoint: "+MyString(ep.m_line_number) +")\n";

	  // next item from the stack

	  it++;
	}
    }
  else
    {
      rval += "None available";
    }

  return rval;
}


bool Abortable::pop_stack_to_current() const
{
  bool context_is_different = false;
  EntryPointList::Stack &stk = m_stack();

  while (!stk.empty() &&
	 (stk.begin()->m_reference != this))
    {
      stk.erase(stk.begin());
      context_is_different = true;
    }

  return context_is_different;
}

void Abortable::set_name(const MyString &name)
{
  m_name = name;
  EntryPointList::Stack &stk = m_stack();

  if (!stk.empty())
    {
      // if no name set yet for the top of stack, set it now

      EntryPoint &current_ep = *(stk.begin());
      if (current_ep.m_name.length() == 0)
	{
	  current_ep.m_name = m_name.c_str();
	}
    }
}
#endif


void Abortable::warn(MSG_ARG_PROTO) const
{
    #ifndef NDEBUG
  if (!(get_debug_level() & DBG_no_warnings))
    #endif
    {
      s_warn(get_location_prefix(get_current_entrypoint()),
	     format_message(message,MSG_ARG_LIST));
    }


}
const char *Abortable::Cause::what() const throw()
{
  return m_context_message.c_str();
}

MyString Abortable::get_location_prefix(const EntryPoint &ep)
{
  // if method as stated in ENTRYPOINT macro starts with '?' then don't print it

  return (ep.m_name + MyString("(") + ep.m_class +
	  MyString(")") + ((ep.m_method[0] == '?') ? ": " :
			   MyString("::") + ep.m_method + ": "));
}



void Abortable::error(const Cause &c, bool propagate) const
{
  bool context_is_different = false;

  s_err(get_location_prefix(c),c.msg());

  // pop up the stack until we find us
  // (or the stack is empty)
#ifndef NDEBUG
  context_is_different = pop_stack_to_current();
#endif

  if (propagate)
    {

      if (!is_user_level_object())
	{
	  // now abort with the same message, but with the current
	  // context

	  abort_run(c.msg());
	}
      else
	{
	  // now abort with the current context, but with another message
	  abort_run("Ended with error(s)");
	}
    }
  else
    {
      if (context_is_different)
	{
	  // context different from the one where the exception
	  // came from: print the message with the current context

	  s_err(get_location_prefix(get_current_entrypoint()),c.msg());
	}
    }

}

void Abortable::abort_run(MSG_ARG_PROTO) const
{
  // throws an exception with an Abortable::Cause object
#ifdef USE_EXCEPTIONS
  throw(Cause
	(format_message(message,MSG_ARG_LIST),
	 get_current_entrypoint()));
  #endif
}

// JFF: kind of printf emulation, not complete, but with extra features
// such as %b print boolean, etc...

MyString Abortable::format_message(MSG_ARG_PROTO)
{
  MyString rval;
  int idx = 0;
  int msgsize = message.size();
  const char *args[MAX_ARGCOUNT];
  int argcount=0,argindex=0;

  args[argcount++] = arg1.c_str();
  args[argcount++] = arg2.c_str();
  args[argcount++] = arg3.c_str();
  args[argcount++] = arg4.c_str();
  args[argcount++] = arg5.c_str();
  args[argcount++] = arg6.c_str();
  args[argcount++] = arg7.c_str();
  args[argcount++] = arg8.c_str();
  args[argcount++] = arg9.c_str();
  args[argcount++] = argA.c_str();

  while (idx < msgsize)
    {
      bool align_right = false;
      char current = message[idx++];

      if ((current != '%') || (idx == msgsize))
	{
	  rval += current;
	}
      else
	{
	  MyString partial;

	  char next = message[idx];
	  bool is_upper = isupper(next);
	  if (is_upper)
	    {
	      next = tolower(next);
	    }
	  switch (next)
	    {
	      case '%':
		partial += current;
		idx++;
		break;
	      case 'c': // character
	      case 'l': // long long
	      case 's': // string
	      case 'f': // float
	      case 'g': // float
		if (argindex < argcount)
		  {
		    partial += args[argindex++];
		    idx++;
		  }
		break;
	      case 'q': // quoted string
		if (argindex < argcount)
		  {
		    partial += MyString('"') + args[argindex++] + '"';
		    idx++;
		  }
		break;
	      case 'b': // boolean
		if (argindex < argcount)
		  {
		    if (atoi(args[argindex]) != 0)
		      {
			partial += "true";
		      }
		    else
		      {
			partial += "false";
		      }
		    argindex++;
		    idx++;
		  }
		break;
	      case 'd': // integer
	      case 'x': // integer (hexadecimal)
		{
		  // special case: understand INT_MAX as undefined
		  if (argindex < argcount)
		    {
                    #ifdef _HAS_THREADS
		      long64_t iv = atoll(args[argindex]);
                    #else
		      long64_t iv = atoi(args[argindex]);
                    #endif

		      if (iv == undefined_integer)
			{
			  partial += "?";
			}
		      else
			{
			  if (next == 'd')
			    {
			      partial += args[argindex];
			    }
			  else
			    {
			      partial += MyString(iv,true);
			    }
			}
		      argindex++;
		      idx++;
		    }
		  break;

		}
	      case '-':
		idx++;
		align_right = true;
		break;
	      case '0':
	      case '1':
	      case '2':
	      case '3':
	      case '4':
	      case '5':
	      case '6':
	      case '7':
	      case '8':
	      case '9':
		{
		  if (argindex < argcount)
		    {
		      int enddigit = idx;
		      while ((enddigit < msgsize-1) &&
			     (message[enddigit]!='s'))
			{
			  enddigit++;
			}
		      if (enddigit < (msgsize-1))
			{
			  int digit = atoi(message.c_str()+idx);
			  const char *contents = args[argindex++];
			  int contents_len = strlen(contents);
			  if (digit < contents_len)
			    {
			      partial += contents;
			    }
			  else
			    {
			      if (!align_right)
				{
				  partial += contents;
				}
			      for (int i=0;i<digit - contents_len;i++)
				{
				  partial += ' ';
				}

			      if (align_right)
				{
				  partial += contents;
				}

			      idx = enddigit + 1;

			    }
			}
		    }
		}
	    }

	  if (is_upper)
	    {
	      rval += partial.uppercase();
	    }
	  else
	    {
	      rval += partial;
	    }

	}
    }
  return rval;
}


MyString Abortable::system_error_reason()
{
  return strerror(errno);
}


void Abortable::debug(MSG_ARG_PROTO) const
{
  
  MyString msg = format_message(message,MSG_ARG_LIST);

  bool add_newline = (msg.size() == 0);

  if (!add_newline)
    {
      const char last = msg[msg.size() - 1];

      if ((last != '\n') && (last != '\r'))
	{
	  add_newline = true;
	}
    }

  // JFF: ensure that the messages will be displayed without
  // being interrupted by other threads

	
#ifndef _HAS_THREADS
  printf("%s%s",get_location_prefix(get_current_entrypoint()).c_str(),msg.c_str());

  if (add_newline)
    {
      printf("\n");
    }
  else
    {
      fflush(stdout);
    }
#else
  m_debug_mutexes.cs_start();

  print_thread_context(stdout);

  printf("%s%s",get_location_prefix(get_current_entrypoint()).c_str(),msg.c_str());

  if (add_newline)
    {
      printf("\n");
    }

  fflush(stdout);

  m_debug_mutexes.cs_end();
#endif

}

#ifdef _HAS_THREADS
void Abortable::enter_method(const char *mname,
			     const char *fname,
			     const int line_number
) const
{
  // in case the object is not allocated
  my_assert(this != 0);

  // smart management of the debug level per stack
  // debug level is propagated to the called method, thus avoiding
  // ugly static definition of the debug level whihc existed previously

  int debug_level = get_debug_level();
  EntryPointList::Stack &stk = m_stack();

  if (!stk.empty())
    {
      // retrieve debug level from caller

      const EntryPoint &current_ep = *(stk.begin());
      debug_level = current_ep.m_debug_level;
      m_debug_level = debug_level;
    }

  stack_push(EntryPoint(this,
			mname,
			fname,
			line_number,
			debug_level));


  if (debug_level & DBG_trace_mode)
    {
      debug("enter (tl=0x%x)",debug_level);
    }
  if (debug_level & DBG_profiler)
    {
      // start function timer

      stk.begin()->m_profile_info.in();
    }

}

void Abortable::exit_method(const char *fname,
			    const int line_number) const
{
  const int debug_level = get_debug_level();
  EntryPointList::Stack &stk = m_stack();

  if (stk.empty())
    {
      abort_run("empty stack at line %d, file %q",
		line_number,fname);
    }

  EntryPoint &current_ep = *(stk.begin());

  if (debug_level & DBG_trace_mode)
    {
      debug("exit (tl=0x%x)",debug_level);
    }
  if (debug_level & DBG_profiler)
    {
      FunctionTimer &ft = current_ep.m_profile_info;

      // stop function timer

      ft.out();


      // find function id

      FunctionId fi(current_ep.m_class,current_ep.m_method);

      // get this thread profiler table

      NameSortProfilerTable &pl = m_profiler_table_list.get();

      // does the function already exists in our table?

      NameSortProfilerTable::iterator rval = pl.find(fi);

      if (rval == pl.end())
	{
	  // no: add it

	  //pair<NameSortProfilerTable::iterator, bool> success =
	  pl.insert(make_pair(fi,ft));
	}
      else
	{
	  // just add the elapsed times & call counter

	  rval->second += ft;
	}
    }

  // pop the stack
  stk.erase(stk.begin());

  if (!stk.empty())
    {
      // propagate debug level to the caller if any

      EntryPoint &parent_ep = *(stk.begin());
      parent_ep.m_debug_level = debug_level;
    }

}

Abortable::ProfilerInfo::ProfilerInfo(const FunctionTimer &ft,
				      const MyString &class_name,
				      const MyString &method_name)
{
  FunctionTimer &my_ft = *this;
  my_ft = ft;
  m_function_name = class_name + "::" + method_name;
}

Abortable::ProfilerTable Abortable::get_profiler_info()
{
  NameSortProfilerTable name_sorted_list;
  ProfilerTable time_sorted_list;
  ThreadSafeContainer<NameSortProfilerTable>::const_iterator it;
  NameSortProfilerTable::const_iterator itp;

  for (it = m_profiler_table_list.begin();
       it != m_profiler_table_list.end();
       it++)
    {
      // for each thread

      const NameSortProfilerTable &pt = it->second;


      for (itp = pt.begin(); itp != pt.end(); itp++)
	{
	  // for each function of the thread, merge it into the big list

	  NameSortProfilerTable::iterator item = name_sorted_list.find(itp->first);

	  if (item == name_sorted_list.end())
	    {
	      // not found: first occurrence: insert it

	      name_sorted_list.insert(*itp);
	    }
	  else
	    {
	      // already exists: merge timing information

	      item->second += itp->second;
	    }
	}
    }

  // sort the big list by times

  for (itp = name_sorted_list.begin(); itp != name_sorted_list.end(); itp++)
    {
      time_sorted_list.insert(make_pair(itp->second,itp->first));
    }
  return time_sorted_list;
}
#endif

/**
 * sets debug level
 */

void Abortable::set_debug_level(const int dl)
{
  ENTRYPOINT(set_debug_level);
  m_debug_level = dl;
  EXITPOINT;
}

/**
 * adds mask to debug level
 */

void Abortable::add_debug_level(const int dmsk)
{
  ENTRYPOINT(add_debug_level);
  m_debug_level |= dmsk;
  EXITPOINT;
}

Abortable::Cause::Cause(const MyString &error_message,
			const EntryPoint &entrypoint)
: EntryPoint(entrypoint),
m_message(error_message)
{
  m_context_message = get_location_prefix(*this) + m_message;
}
