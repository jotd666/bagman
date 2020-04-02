#pragma once

#include "GsDefine.hpp"
#include "MyMacros.hpp"
#include "MyString.hpp"
#if !defined(_NDS) && !defined(__amigaos__)
#include "FunctionTimer.hpp"
#endif
#include "FunctionId.hpp"

#include <list>
#include <map>
#include <stdexcept>

#include "MemoryEntryMap.hpp"

#ifndef NDEBUG
#define NDEBUG
#endif

/**
 * declare the mandatory get_string_type() method for an Abortable inherited
 * object */

#define DEF_GET_STRING_TYPE(name) \
  MyString get_string_type() const { return #name; }


/**
 * create a reference on a specialized type
 */

#define DECL_CAST_TYPE(typ,specialized_variable,abstract_variable) \
typ &specialized_variable = safe_cast<typ >(abstract_variable)

/**
 * create a constant reference on a specialized type
 */

#define DECL_CAST_CONST_TYPE(typ,specialized_variable,abstract_variable) \
DECL_CAST_TYPE(const typ,specialized_variable,abstract_variable)

/**
 * kernel debug block start test
 */

#define KD_BLOCK(dbgflag) if (m_debug_level & DBG_##dbgflag)

/**
 * entrypoint/exitpoint definitions
 * NDEBUG: no stack/no thread context
 * NDEBUG + NDEBUG_TRACES (can be set locally): simply prints in & out of the methods
 */
#if defined NDEBUG || defined _NDS || defined __amigaos__

#ifdef NDEBUG_TRACE
#define ENTRYPOINT(mname) debug(get_string_type()+":"+#mname+": enter")
#define EXITPOINT debug("exit method")
#else
#define ENTRYPOINT(mname) ((void)0)
#define EXITPOINT ((void)0)
#endif

#else
#define ENTRYPOINT(mname) \
{ enter_method(#mname,__FILE__,__LINE__)

#define EXITPOINT \
  exit_method(__FILE__,__LINE__); }
#endif

// set USE_FINE_PROFILING in modules where ENTRYPOINT/EXITPOINT
// has been replaced by FP_ENTRYPOINT/FP_EXITPOINT to enable
// profiler/stacktrace (because of the number of calls, leaving
// ENTRYPOINT/EXITPOINT in those methods would introduce too
// much overhead during normal operation)

#ifdef USE_FINE_PROFILING
#define FP_ENTRYPOINT(x) ENTRYPOINT(x)
#define FP_EXITPOINT EXITPOINT
#else
#define FP_ENTRYPOINT(x) ((void)0)
#define FP_EXITPOINT ((void)0)
#endif

#define ENTRYPOINT_THROW(m) ENTRYPOINT(m); try {
#define EXITPOINT_THROW \
    } catch (const Cause &m) { error(m,true); } EXITPOINT

#define MSG_ARG_PROTO \
const MyString &message,			\
		  const MyString &arg1="",	\
		  const MyString &arg2="",	\
		  const MyString &arg3="",	\
		  const MyString &arg4="",	\
		  const MyString &arg5="",	\
		  const MyString &arg6="",	\
		  const MyString &arg7="",	\
		  const MyString &arg8="",      \
                  const MyString &arg9="",      \
		  const MyString &argA=""

class Abortable;

/**
 * base object for exception handling & context management
 *
 * this is sometimes overcomplicated and does a lot of things.
 * every big/functional object should inherit from this one
 *
 * @author Jean-Francois Fabre
 */

class Abortable
{
public:
  /**
   * debug level mask
   */

  enum DebugLevelMask
    {
      //DBG_main           = 1,     ///< main program
      DBG_profiler       = 1<<12, ///< performance profiling mode
      DBG_alloc          = 1<<13, ///< memory allocation logging
      DBG_no_warnings    = 1<<15, ///< suppress warnings
      DBG_trace_mode     = 0x10000, ///< function entrypoint trace mode
      DBG_all            = 0xFFFFFF ///< all of the above
    };

#ifdef _WIN32
  typedef std::map<FunctionTimer,FunctionId> ProfilerTable;
#endif

  /**
   * item stored in our custom stack object
   *
   * used for
   * <UL>
   * <LI> debug message prefixing
   * <LI> error/warning message prefixing
   * <LI> stacktrace (in case of interrupt or crash)
   * <LI> check current context
   * <LI> custom profiling
   * </UL>
   */

  class EntryPoint : public std::exception
  {
    public:
    const char *what() const throw()
    {
      return "";
    }

    EntryPoint(const Abortable *obj,
	       const char *method,
	       const char *filename,
	       const int line_number,
	       const int debug_level)
    :
    m_reference(obj),
    m_method(method),
    m_filename(filename),
    m_class(obj == NULL ? "?" : obj->get_string_type()),
    m_name(obj == NULL ? "?" : obj->get_name()),
    m_line_number(line_number),
    m_debug_level(debug_level)
    {
    }

    ~EntryPoint() throw()
    {}

    // object reference

    const Abortable *m_reference; ///< pointer on the object

    // const char * is OK for method and filename
    // since they're static data, never computed strings

    const char *m_method;   ///< name of the method (parameter of ENTRYPOINT)
    const char *m_filename; ///< name of the source file

    // class and name fields must be copied since objects
    // bearing their memory are deleted when the exception
    // pops up the stack

    MyString m_class; ///< type/class of the object
    MyString m_name;  ///< name of the instance

    int m_line_number;
    int m_debug_level;
#ifdef _HAS_THREADS
    FunctionTimer m_profile_info;
#endif

  };
private:
  MyString m_name;  ///< name of the instance of the object
  bool m_user_level_object; ///< whether the object is a user object

  /**
   * return a prefix containing all context information
   * for informational, warning & error messages
   */

  static MyString get_location_prefix(const EntryPoint &ep);

public:


  /**
   * get current registered entrypoint
   *
   * macros ENTRYPOINT & EXITPOINT must be used or the
   * entrypoint cannot be registered
   *
   */

#ifdef _HAS_THREADS
  const EntryPoint &get_current_entrypoint() const;
  /**
   * profiler information
   */

  class ProfilerInfo : protected FunctionTimer
  {
    public:
    ProfilerInfo(const FunctionTimer &ft,
		 const MyString &class_name,
		 const MyString &method_name);

    const MyString &get_function_name() const
    {
      return m_function_name;
    }
    private:
    MyString m_function_name;
  };

#else
  const EntryPoint get_current_entrypoint() const;

#endif

  /**
   * cause of an exception
   */

  class Cause : public EntryPoint
  {
    public:
    Cause(const MyString &error_message,
	  const EntryPoint &entrypoint);

    const char *what() const throw();

    const char *msg() const
    {
      return m_message.c_str();
    }

    ~Cause() throw()
    {}

    private:
    MyString m_message; ///< error message
    MyString m_context_message; ///< context + message
  };

  virtual ~Abortable() {}

  /**
   * @param name logical name of the instance
   * @param user_level_object if true, error message propagation
   * stops when it meets this object (to show user-level errors)
   */

  Abortable(const MyString &name = "", const bool user_level_object = false);

  /**
   * @return logical instance name
   */

  const MyString &get_name()  const
  {
    return m_name;
  }

  /**
   * set logical instance name
   */

  void set_name(const MyString &name);

  /**
   * @return true if this is a user-level object
   */

  bool is_user_level_object() const
  {
    return m_user_level_object;
  }

  /**
   * check if the current stack is within the context of
   * an object (referred to by its name or type)
   */

  static bool is_within_context(const char *object_name,
				bool by_class = false);

  /**
   * get object "class"
   */

  virtual MyString get_string_type() const = 0;

  /**
   * @return strerror(errno)
   */

  static MyString system_error_reason();

  /**
   * return debug level
   */

  inline int get_debug_level() const
  {
        #ifdef NDEBUG
    return 0;
        #else
    return m_debug_level;
        #endif
  }

  /**
   * sets debug level
   */

  void set_debug_level(const int dl);

  /**
   * adds mask to debug level
   */

  void add_debug_level(const int dmsk);


  /**
   * merged list of elapsed times on all threads
   * NameSortProfilerTable is a map
   *
   * first: FunctionId (class and method)
   * second: FunctionTimer (elapsed times)
   */
#ifdef _HAS_THREADS
  static ProfilerTable get_profiler_info();
  /**
   * stack trace of registered entrypoints leading to the error
   */

  static MyString stack_trace();
#endif

  /**
   * enumerate to string conversion
   *
   * @param strs enumerate string representation
   * @param val current enumerate value
   * @param enum_first_value first value of the enumerate in list
   * @param use_bit_model true: use left shift instead of increment
   */

  template <class E>
    MyString enum_to_string(const char *strs[],
			    const E val,
			    const E enum_first_value = (E)0,
			    const bool use_bit_model = false) const
  {
    MyString str;
    bool found = false;

    ENTRYPOINT(enum_to_string);

    if (use_bit_model)
      {
	int i=0;
	int ec = enum_first_value;

	while ((strs[i] != NULL) && (!found))
	  {
	    found = (ec == val);
	    if (found)
	      {
		str = strs[i];
	      }
	    i++;
	    ec = ec<<1;
	  }

      }
    else
      {
	str = strs[val-enum_first_value];
	found = true;
      }

    if (!found)
      {
	abort_run("Value out %d of range",val);
      }
    EXITPOINT;

    return str;
  }

  /**
   * find the logical value of an enumerate
   * from its textual representation
   *
   * @param str string value of the enumerate
   * @param strs legal enum values (NULL terminated char[] list)
   * @param rval return value
   * @param enum_first_value start counting from here
   * @param use_bit_model, false: ++, true <<1
   */

  template <class E>
    void string_to_enum(const MyString &str,
			const char *strs[],
			E &rval,
			const E enum_first_value = (E)0,
			const bool use_bit_model = false) const
  {
    ENTRYPOINT(string_to_enum);

    int string_idx=0;
    int enum_idx=enum_first_value;

    bool found = false;
    while ((strs[string_idx] != NULL) && (!found))
      {
	bool found = (str == strs[string_idx]);

	if (found)
	  {
	    rval = (E)enum_idx;
	  }
	if (use_bit_model)
	  {
	    enum_idx = (enum_idx==0) ? 1 : enum_idx<<1;
	  }
	else
	  {
	    enum_idx++;
	  }

	string_idx++;
      }

    if (!found)
      {
	abort_run("Enumerate value %s not found",str);
      }

    EXITPOINT;
  }

  /**
   * warning message
   */

  void warn(MSG_ARG_PROTO) const;

  /**
   * throw an error
   */

  void abort_run(MSG_ARG_PROTO) const;

  /**
   * debug message
   */

  void debug(MSG_ARG_PROTO) const;

  /**
   * format the message using format string + arguments
   */

  static MyString format_message(MSG_ARG_PROTO);

  /**
   * print an error with its exact location
   *
   * @param c error context & message
   * @param propagate is true then throw an exception
   *
   * propagate is useful in this context
   *
   * try
   * {
   *  // some stuff
   * }
   * catch (const Cause &c)
   * {
   *    // we want the error message printed in the exact context
   *    // but we also want some error to be propagated to a user
   *    // visible level (or the message would not be intelligible)
   *
   *    error(c,true);
   * }
   */

  void error(const Cause &c, bool propagate) const;

protected:
  /**
   * called by the ENTRYPOINT macro, do not be called directly
   */

  void enter_method
    (const char *mname,
    const char *fname,
    const int line_number) const;

  /**
   * called by the EXITPOINT macro, do not be called directly
   */

  void exit_method(const char *fname ,
		   const int line_number) const;

  /**
   * set stack to current object
   * @return true if some entrypoints have actually been popped
   */
  bool pop_stack_to_current() const;


  /**
   * print an error with its exact location,
   * useful (only) when called from without an exception
   */

  void error_nothrow(const MyString &s)
  {
    error(Cause(s,get_current_entrypoint()),false);
  }


  /**
   * dynamic cast with error check and reference return value
   * bonus: if an error occur during a cast for an object inheriting
   * from Abortable, then the type of the object is printed using
   * get_string_type()
   */

  template <class T,class U>
      inline T &safe_cast(U *value) const
  {
    T *rval = dynamic_cast<T*>(value);
#ifndef NDEBUG
    #ifndef __amigaos__
    if (rval == 0)
      {
	// try to make a more accurate error
	const Abortable *ab = dynamic_cast<const Abortable *>(value);
	if (ab == 0)
	  {
	    abort_run("Internal error, cannot dynamic cast");
	  }
	else
	  {
	    abort_run("Internal error, cannot dynamic cast "
		      "object of type %q",ab->get_string_type());
	  }
      }
    #endif
#endif

    return *rval;
  }

  static int m_debug_level;
};
#undef MSG_ARG_PROTO

