/*---------------------------------------------------------------------------*
 *         (C) 2005  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   MyString.C
 *
 * @brief  .
 *
 * @author Jean-Francois FABRE.
 *
 */

/*------------*
 * Used units *
 *------------*/

// avoid to log memory in this class
// the class has been tested for memory leaks
// and logging memory here would hinder performance

#define NO_MEMORY_LOG

#ifdef HAS_REGEX
#include "CppRegex.hpp"
#endif

#include "MyAssert.hpp"

#ifdef _WIN32


#define ALLOW_WINDOWS_PATHS


#include <direct.h>

#else
#include <unistd.h>
#define _getcwd getcwd
#endif

#include <string.h>
#include <stdlib.h>
#include <cstdio>
#include <sstream>

#include "MyString.hpp"


#include "MemoryEntryMap.hpp"



#ifdef CLASS_TEST
#include <iostream>   // class test only

int main()
{
  /*MyString xxx = "../foo.h";  // works
    cout << xxx.is_absolute_path() << endl;
    xxx = "D:\\cygdrive\\foo.h";  // works
    cout << xxx.dirname() << endl;
    cout << xxx.is_absolute_path() << endl;
    xxx = "/foo/foo.h";
    cout << xxx.is_absolute_path() << endl;
    cout << xxx.basename() << endl;
    //xxx = "../../operators/../foo.h";
    //cout << xxx.absolute_path() << endl;*/

  cout << "regex text" << endl;
  MyString re("pipo_1");
  cout << "match: " << re.regex_match("^.*_1$") << endl;
  cout << "nomatch: " << re.regex_match("^.*_2$") << endl;

  re = "you.are.a.loser";
  MyVector<MyString> s = re.split('.');

  cout << "nb_items " << s.size() << endl;
  for (int i = 0; i < s.size(); i++)
    {
      cout << "item " << s[i] << endl;
    }

  re = "";
  cout << "nb_items " << re.split('.').size() << endl;
  cout << "Done" << endl;
  return 0;
}
#endif

/*-----------------*
 * Types & objects *
 *-----------------*/

/*-----------*
 * Functions *
 *-----------*/

MyVector<MyString> MyString::split(char split_char) const
{
  MyVector<MyString> rval;
  int start_index = 0;
  for (int i = 0; i < m_size; i++)
    {
      if (m_contents[i] == split_char)
	{
	  rval.push_back(substr(start_index,i - start_index));

	  start_index = i + 1;
	}
    }

  if (m_size > 0)
    {
      rval.push_back(substr(start_index,m_size));
    }

  return rval;
}

MyString::MyString(const MyString &other) : m_contents(0)
{
  build(other.c_str());
}
MyString::MyString(const void *p) : m_contents(0)
{
  char buffer[20];
  sprintf(buffer,"%p",p);
  build(buffer);
}

MyString::MyString(const char *string_list[], char quote_char_start, char quote_char_end,
		   char separation_char, int item_count)  : m_contents(0)
{
  int counter = 0;
  build("");
  MyString &me = *this;

  while ((string_list[counter] != NULL) && ((item_count < 0) || (counter < item_count)))
    {
      MyString to_append(string_list[counter]);

      if (counter != 0)
	{
	  me += MyString(separation_char);
	}

      if (quote_char_start != '\0')
	{
	  me += MyString(quote_char_start) + to_append + MyString(quote_char_end);
	}
      else
	{
	  me += to_append + MyString(quote_char_end);
	}

      counter++;
    }
}


MyString::MyString() : m_contents(0)
{
  build("",0);
}

MyString::MyString(const char *str, const int size) : m_contents(0)
{
  build(str,size);
}


MyString::MyString(const char val) : m_contents(0)
{
  build(".",1);
  (*this)[0] = val;
}

MyString::MyString(const int val, bool hexadecimal) : m_contents(0)
{
  ostream_build(val,hexadecimal ? "%x" : "%d" );
}
MyString::MyString(const unsigned int val, bool hexadecimal) : m_contents(0)
{
  ostream_build(val, hexadecimal ? "%ux": "%u");
}
MyString::MyString(const unsigned long int val, bool hexadecimal) : m_contents(0)
{
  ostream_build(val,hexadecimal ? "%ulx" : "%ul");
}

MyString::MyString(const char *str) : m_contents(0)
{
  build(str);
}


MyString::MyString(const long int val, bool hexadecimal) : m_contents(0)
{
  ostream_build(val,hexadecimal ? "lx":"%ld");
}

#ifdef  __GLIBC_HAVE_LONG_LONG
MyString::MyString(const long long int val, bool hexadecimal) : m_contents(0)
{
#ifndef _WIN32
  ostream_build(val,hexadecimal);
#else
  ostream_build((long int)val,hexadecimal);
#endif
}
MyString::MyString(const unsigned long long int val, bool hexadecimal) : m_contents(0)
{
#ifndef _WIN32
  ostream_build(val,hexadecimal);
#else
  ostream_build((unsigned long int)val,hexadecimal);
#endif
}
#endif

MyString::MyString(const float val, const int precision) : m_contents(0)
{
  ostream_build_float(val,precision);
}

MyString::MyString(const double val, const int precision) : m_contents(0)
{
  ostream_build_float(val,precision);
}



void MyString::build(const char *str)
{
  build(str,strlen(str));
}

void MyString::allocate()
{
  my_assert(m_contents == 0);

  LOGGED_NEW(m_contents,char[m_size + 1]);
}
void MyString::build(const char *str, const int size)
{
  destroy();
  if (str != 0)
    {
      m_size = size;

      allocate();

      memcpy(m_contents,str,size);
      m_contents[size] = '\0';
    }
  else
    {
      m_size = 0;

      allocate();

      m_contents[0] = '\0';
    }
}


template <class T>
  void MyString::ostream_build_float(const T &val, const int )
{
  char buf[200];
  if (sizeof(T) == sizeof(float))
    {
      sprintf(buf,"%f",val);
    }
  else
    {
      sprintf(buf,"%lf",val);
    }
  *this = buf;

}

template <class T>
  void MyString::ostream_build(const T &val, const char *format)
{
  char buf[200];

  sprintf(buf,format,val);


  *this = buf;
}


bool MyString::compare(const MyString &other,bool respect_case) const
{
  bool rval = (other.size() == size());

  if (rval)
    {
      if (respect_case)
	{
	  rval = strcmp(other.c_str(),c_str()) == 0;
	}
      else
	{
	  const_iterator p = this->begin();
	  const_iterator p2 = other.begin();

	  while (rval && p != this->end() && p2 != other.end())
	    {
	      rval = respect_case ? *p == *p2 : (toupper(*p) == toupper(*p2));
	      p++;
	      p2++;
	    }
	}
    }
  return rval;
}

bool MyString::is_absolute_path(bool eval_env_variables) const
{
  MyString copy = (eval_env_variables ?
		   this->eval_env_variables() : *this);

  const char first_char = copy[0];
  bool rval = (first_char == '/');

#ifdef ALLOW_WINDOWS_PATHS
  if (!rval)
    {
      // can be a letter followed by :\ or :/
      // examples: d:\, C:/WINDOWS ...

      if (((first_char >= 'a') && (first_char <= 'z')) ||
	  ((first_char >= 'A') && (first_char <= 'Z')))
	{
	  rval = (copy[1] == ':' && (copy[2] == '/' || copy[2] == '\\'));
	}
    }
#endif

  return rval;

}


MyString MyString::basename() const
{
  size_type lastslash=find_last_of(
				   "/"
#ifdef ALLOW_WINDOWS_PATHS
				   "\\"
#endif
  );

  if (lastslash > length())
    {
      lastslash = 0;
    }
  else
    {
      lastslash++;
    }

  return MyString(c_str()+lastslash);
}

MyString MyString::dirname() const
{
  MyString rval;
  size_type lastslash=find_last_of(
				   "/"
#ifdef ALLOW_WINDOWS_PATHS
				   "\\"
#endif
  );

  if (lastslash > length())
    {
      rval=".";
    }
  else
    {
      rval = substr(0,lastslash);
    }

  return rval;
}
bool MyString::operator<(const MyString &other) const
{
  return (strcmp(c_str(), other.c_str()) < 0);
}

MyString &MyString::operator=(const char *str)
{
  build(str);

  return *this;
}

MyString MyString::operator/(const MyString &other) const
{
  MyString rval = other;
  if (*this != ".")
    {
      if (this->ends_with("/"))
	{
	  rval = (*this+other);
	}
      else
	{
	  rval = (*this+'/'+other);
	}
    }
  return rval;

}
//: Method: left
//: Part: extract the left part of the string

MyString MyString::left
  (
  const char separator,
  const bool end
) const
{
  char buf[2];
  buf[0]=separator;
  buf[1]='\0';
  return (left(buf,end));
}

//: Method: left
//: Part:

MyString MyString::left
  (
  const char *separator,
  bool end
) const
{
  size_type possep;

  if (end==false)
    {
      possep=find_first_of(separator);
    }
  else
    {
      possep=find_last_of(separator);
    }

  return substr(0,possep);

}



MyString MyString::right
  (
  const char separator,
  const bool end
) const
{
  char buf[2];
  buf[0]=separator;
  buf[1]='\0';
  return (right(buf,end));
}


MyString MyString::right
  (
  const char *separator,
  const bool end
) const
{

  MyString ret;
  size_type possep;

  if (end==false)
    {
      possep=find_first_of(separator);
    }
  else
    {
      possep=find_last_of(separator);
    }

  size_type sz = length();

  if (possep<sz)
    {
      ret=substr(possep+1,sz-possep);
    }


  return ret;

}

bool MyString::ends_with(const MyString &endstr) const
{
  bool rval=false;
  int difference = (size()-endstr.size());
  const char *thisend;

  if (difference >= 0)
    {
      thisend = c_str()+difference;

      rval = (strstr(thisend, endstr.c_str()) == thisend);
    }

  return rval;
}


bool MyString::starts_with(const MyString &startstr) const
{
  bool rval=false;

  if (size()>=startstr.size())
    {
      rval = (strstr(c_str(),startstr.c_str()) == c_str());

    }

  return rval;

}

// added by JFF, allows more flexible parameter file
// ptolemy parameter syntax

MyString MyString::eval_env_variables() const
{
  MyString rval,envvar;
  bool over = false;

  // chars possibly in the environment variable name

  static const char *non_separators=
  "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";

  size_type possep=0,posstart=0;

  while (!over && (possep = find_first_of("$",possep)) < size()-1)
    {
      // found a '$' character: append left part of the string

      rval += substr(posstart,possep-posstart);

      posstart = possep;

      // find the end of the env variable word

      char b = operator[](possep+1);

      bool bracket = ((b == '{') || (b == '('));

      if (bracket)
	{
	  possep++;
	}

      posstart = find_first_not_of(non_separators,possep+1);

      envvar = substr(possep+1,posstart-possep-1);

      // evaluate the variable

      const char *envvalue = getenv(envvar.c_str());

      if (envvalue == NULL)
	{
	  if (bracket)
	    {
	      rval += "${" + envvar + '}';
	    }
	  else
	    {
	      rval += '$' + envvar;
	    }
	}
      else
	{
	  rval += envvalue;
	}

      if ((bracket) && (posstart < size()))
	{
	  // skip the closing brace
	  posstart++;
	}

      possep = posstart;

      over = (possep >= size());
    }

  if (!over)
    {
      rval += substr(posstart);
    }

  return rval;
}

void MyString::append_dirname(const MyString &dirname)
{
  if (((*this)[0]!='/')
#ifdef ALLOW_WINDOWS_PATHS
      || ((*this)[0]!='\\')
#endif
    )

    {
      *this=dirname/(*this);
    }

}

MyString MyString::operator+(const MyString &other) const
{
  MyString rval(*this);
  rval += other;

  return rval;
}

MyString &MyString::operator+=(const MyString &other)
{
  const int old_size = m_size;
  char *old_contents = m_contents;

  m_contents = 0;
  m_size += other.size();

  allocate();

  strncpy(m_contents,old_contents,m_size);

  LOGGED_DELETE_ARRAY(old_contents);

  strcpy(m_contents+old_size,other.c_str());

  return *this;
}
MyString &MyString::operator+=(const char val)
{
  return (*this += MyString(val));
}


MyString &MyString::operator+=(const int val)
{
  return (*this += MyString(val));
}
MyString &MyString::operator+=(const long int val)
{
  return (*this += MyString(val));
}
MyString &MyString::operator+=(const float val)
{
  return (*this += MyString(val));
}

MyString::~MyString()
{
  destroy();
}

char *MyString::dup() const
{
  char *rval;
  LOGGED_NEW(rval,char[m_size+1]);
  strcpy(rval,c_str());

  return rval;
}


#if 0

// strict ansi version (without realpath, but less powerful)

MyString MyString::absolute_path() const
{
    MyString rval;
    int offset = 0;

    // turn to absolute

    if ((*this)[0] != '/')
    {
	char tmp[PATH_MAX];

	::getcwd(tmp,PATH_MAX-1);

	rval = MyString(tmp)/(*this);
    }
    else
    {
	rval = *this;
    }

    // resolve .. stuff
    // (does not work completely)

    // foo/../dir -> dir
    // foo/./bar -> foo/bar
    //
    // (just like in realpath function
    // but we don't have access to it because
    // of ansi qualification)

    const char *start = rval.c_str() + offset;
    const char *ptr = start;
    if (strstr(ptr,"/../..") == NULL) // TEMPORARY would not work
    {
	while((ptr = strstr(ptr,"/..")) != NULL)
	{
	    bool do_dirname = false;

	    switch(ptr[3])
	    {
	      case '\0':
		// end of string
	      case '/':
		// other dir
		do_dirname = true;
		break;
	      default:
		// ..somename: do nothing
		break;
	    }

	    if (do_dirname)
	    {
		int pos = ptr - start;

		if (pos > 0)
		{
		    // reverse search of '/'

		    const char *ptr2 = ptr-1;

		    while ((ptr2 != start) && (*ptr2 != '/'))
		    {
			ptr2--;
		    }

		    if (*ptr2 == '/')
		    {
			int pos2 = ptr2 - start;

			rval = rval.substr(0,pos2+offset) +
			rval.substr(pos+offset+3);
			offset += pos2 - pos;
		    }
		}
	    }
	    // increase ptr
	    ptr+=3;
	    break; // TEMPORARY: do not search further
	}

    }
    return rval;
}
#endif


/**
 * check if contains a string
 **/

bool MyString::contains(const MyString &str) const
{
  return (strstr(c_str(),str.c_str()) != NULL);
}

/**
 * convert to integer value
 */
bool MyString::int_value(int &value, const bool hexadecimal) const
{
  return p_int_value(value,hexadecimal);
}

#ifdef __GLIBC_HAVE_LONG_LONG
#ifndef _WIN32
bool MyString::int_value(long long &value, const bool hexadecimal) const
{
  return p_int_value(value,hexadecimal);
}
bool MyString::int_value(unsigned long long &value, const bool hexadecimal) const
{
  return p_int_value(value,hexadecimal);
}
#else

// WIN32 environment does not like long long with strstreams

bool MyString::int_value(long long &value, const bool hexadecimal) const
{
  return p_int_value((long)value,hexadecimal);
}
bool MyString::int_value(unsigned long long &value, const bool hexadecimal) const
{
  return p_int_value((unsigned long)value,hexadecimal);
}
#endif
#endif

template <class FLT_TYPE>
  bool MyString::p_float_value(FLT_TYPE &value) const
{
    #ifndef _NDS
  std::istringstream iss(this->c_str());

  iss >> value;

  return true;
    #else
  value = atof(this->c_str());
  return true;
    #endif
}
template <class INT_TYPE>
  bool MyString::p_int_value(INT_TYPE &value, const bool hexadecimal) const
{

  if (hexadecimal)
    {
      sscanf(this->c_str(),"%x",&value);
    }
  else
    {
      sscanf(this->c_str(),"%d",&value);
    }
  return true;
}


MyString MyString::uppercase() const
{
  MyString rval(*this);
  MyString::iterator it;

  for (it = rval.begin();it != rval.end(); it++)
    {
      *it = toupper(*it);
    }

  return rval;
}
MyString MyString::lowercase() const
{
  MyString rval(*this);
  MyString::iterator it;

  for (it = rval.begin();it != rval.end(); it++)
    {
      *it = tolower(*it);
    }

  return rval;
}



#include <sys/param.h>
#include <sys/stat.h>

#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/*
 * MAXSYMLINKS
 */
#ifndef MAXSYMLINKS
#define MAXSYMLINKS 5
#endif



#ifndef MAXPATHLEN
#define MAXPATHLEN 1000
#endif


void MyString::pad(const char pad_char,const int limit,const bool start)
{
  MyString pad_str(pad_char);

  // adds the char until limit is reached

  while ((int)length()<limit)
    {
      if (start)
	{
	  *this=pad_str+*this;
	}
      else
	{
	  *this+=pad_str;
	}
    }

}

#ifdef HAS_REGEX
bool MyString::regex_match(const char *expression) const
{
  regex_t preg;
  regmatch_t pmatch;
  bool match=false;

  // first, compile the regular expression

  if (!regcomp(&preg,expression,REG_EXTENDED))
    {
      // compilation succeeded
      // now try to match the regexp against the string

      switch (regexec(&preg,c_str(),1,&pmatch, 0))
	{
	  case REG_NOMATCH:
	    // pattern was not found

	    break;
	  case 0:
	    // pattern found
	    match=true;
	    break;
	  default:
	    // other error
	    // unhandled at the moment


	    break;
	}
    }

  // free the memory

  regfree(&preg);

  // returns true if the pattern matched the string

  return match;

}
#endif


void MyString::destroy()
{
  LOGGED_DELETE_ARRAY(m_contents);

  m_size = 0;
}

MyString &MyString::operator=(const MyString &other)
{
  if (&other != this)
    {
      build(other.c_str());
    }
  return *this;
}


bool MyString::operator==(const MyString &other) const
{
  return compare(other);
}
bool MyString::operator!=(const MyString &other) const
{
  return !compare(other);
}

MyString operator+(const char *str, const MyString &me)
{
  return MyString(str) + me;
}

MyString operator+(const char str, const MyString &me)
{
  return MyString(str) + me;
}

std::ostream &operator<<(std::ostream &os,const MyString &me)
{
  os << me.c_str();
  return os;
}

MyString MyString::substr(const size_type start,const size_type nbp) const
{
  size_type nb(nbp);
  MyString rval;
  char *buffer;
  char *ptrbuf;
  size_type sz = size();

  if (start<sz)
    {

      if (start>(sz-nb))
	{
	  nb=sz-start;
	}

      //@ if char count > total size, then problem

      if (nb>size())
	{
	  nb=sz-start;
	}


      LOGGED_NEW(buffer,char[nb+1]);

      ptrbuf=buffer;

      size_type index=0;

      while ((index<nb)&&(index<sz))
	{
	  *(ptrbuf++)= m_contents[index+start];
	  index++;
	}

      *ptrbuf='\0';

      rval=buffer;

      // frees temporary buffer

      LOGGED_DELETE_ARRAY(buffer);
    }
  return rval;
}


char MyString::operator[](const int pos) const
{
  my_assert ((pos >= 0) && (pos<m_size));

  return c_str()[pos];
}
char &MyString::operator[](const int pos)
{
  my_assert ((pos >= 0) && (pos<m_size));

  return m_contents[pos];
}

MyString::size_type MyString::find_first_of(const char *chars, const MyString::size_type start_pos) const
{
  return find_xxx_of(chars,start_pos,true,false);
}
MyString::size_type MyString::find_last_of(const char *chars,const MyString::size_type start_pos) const
{
  return find_xxx_of(chars,start_pos,false,false);
}
MyString::size_type MyString::find_first_not_of(const char *chars,const MyString::size_type start_pos) const
{
  return find_xxx_of(chars,start_pos,true,true);
}

MyString::size_type MyString::find_last_not_of(const char *chars,const MyString::size_type start_pos) const
{
  return find_xxx_of(chars,start_pos,false,true);
}
MyString::size_type MyString::find_xxx_of(const char *chars,
					  const size_type start_pos_p,
					  const bool forward,
					  const bool negative
) const
{
  // default return value: not found

  size_type rval = UINT_MAX;
  size_type start_pos(start_pos_p);

  size_type sz=size();

  // if start pos unspecified or too high start from end

  if (start_pos>=sz)
    {
      start_pos=sz;
    }

  // if current string is not empty

  if (sz>0)
    {
      // points to current string + start position

      const char *ptrcont=c_str()+start_pos;

      bool out = false;

      int nb_loops = (forward ? (sz - start_pos) :
		      start_pos);

      while ((nb_loops>=0)&&(!out))
	{
	  const char *ptrsep=chars;
	  bool found = false;

	  // pre-decrementation in the case of "last" search

	  if (!forward)
	    {
	      ptrcont--;
	    }

	  while ((*ptrsep!='\0')&&(!found))
	    {
	      // tests if the current character of current string
	      // is "chars" string
	      found = (*ptrcont==*ptrsep);

	      // next character
	      ptrsep++;
	    }

	  if (negative)
	    {
	      out=!found;
	    }
	  else
	    {
	      out=found;
	    }

	  // post-incrementation in the case of "first" search

	  if ((!out)&&(forward))
	    {
	      ptrcont++;
	    }

	  nb_loops--;
	}

      if (out)
	{
	  // found something: compute position

	  rval=ptrcont-c_str();
	}

    }
  return rval;
}

MyString MyString::replace(const MyString &name1,	//: I : string to look for
			   const MyString &name2	//: I : string to put instead of name1
) const
{
  MyString rval = *this;
  rval.substitute(name1,name2);

  return rval;
}
//: Method: substitute
//: Part: replaces a string by another, lenghts can differ

bool MyString::substitute(
			  const MyString &name1,	//: I : string to look for
			  const MyString &name2	//: I : string to put instead of name1
)
{
  bool rval=false;

  size_type taille_name1=name1.size();
  size_type taille_name2=name2.size();

  // permet d'eviter des boucles infinies

  if ((name1!="")&&(name1!=name2))
    {
      size_type pos=string_find(name1);

      while (pos<size())
	{
	  rval=true;

	  MyString start = substr(0,pos);
	  MyString end = substr(pos+taille_name1);

	  *this=start+name2+end;

	  // avancer de la taille de la chaine substituee

	  pos=string_find(name1,pos+taille_name2);

	}

    }

  return rval;
}


//: Method: stringFind
//: Part: finds the position of a substring
//: in the current string

MyString::size_type MyString::string_find(const MyString &substr,const MyString::size_type start_pos) const
{
  size_type rval=UINT_MAX;

  if (start_pos<size())
    {
      const char *occ=
      strstr(c_str()+start_pos,substr.c_str());

      if (occ!=NULL)
	{
	  rval=occ-c_str();
	}
    }

  // returns UINT_MAX (i.e. 4 billions) if not found, else found pos

  return rval;
}
