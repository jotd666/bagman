/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

#include "SysCompat.hpp"

#include "MyFile.hpp"
#include "MemoryEntryMap.hpp"

#include <cstdio>
#ifdef __amigaos__
#include <proto/dos.h>
#include <proto/exec.h>
#include <dos/dos.h>
#else
#include <dirent.h>
#endif


MyFile::MyFile(const MyString &name) : m_name(name)
{

}




//: Method: del
//: Part: physically deletes a file from disk

bool MyFile::del()
{
  return (remove(m_name.c_str())==0);
}

StreamPosition MyFile::write_all(const StreamPosition length_to_write, const void *buffer) const
{
  FILE *f = fopen(get_name().c_str(),"wb");

  StreamPosition length_written = -1;
  if (f != 0)
    {
      //size_t oldpos = 0;
      length_written = fwrite((const char*)buffer,length_to_write * sizeof(char),1,f);

      LOGGED_FCLOSE(f);
    }

  return length_written;
}

void *MyFile::read_all(StreamPosition &length_read, const StreamPosition max_size) const
{
  // not guaranteed to work on files >2Gb size
  char *rval = 0;
  length_read = size();

  if (length_read > 0)
    {
      // read limitation

      if ((max_size > 0) && (length_read > max_size))
	{
	  length_read = max_size;
	}

      // allocate buffer

      LOGGED_NEW(rval,char[length_read]);

      length_read = read_bytes(rval,length_read);
      if (length_read == 0)
	{
	  rval[0]=0;
	}
    }
  return rval;
}

//: Method: listContents
//: Part: list the contents of the directory
#ifdef __amigaos__
bool MyFile::is_fifo() const
{
  return false;
}

StreamSize MyFile::read_bytes(void *data,int sz) const
{
  StreamSize rval = -1;
  BPTR f = Open(get_name().c_str(),MODE_OLDFILE);

  rval = Read(f,(char*)data,sz);
  Close(f);

  return rval;
}
bool MyFile::exists() const
{
  bool rval = false;
  BPTR l = Lock(m_name.c_str(),ACCESS_READ);
  if (l)
    {
      rval = true;
      UnLock(l);
    }
  return rval;
}
bool MyFile::is_directory() const
{
  bool rval = false;

  BPTR l = Lock(m_name.c_str(),ACCESS_READ);
  if (l)
    {
      struct FileInfoBlock *fib = (struct FileInfoBlock *)AllocMem(sizeof(*fib),MEMF_PUBLIC);
      if (Examine(l,fib))
	{
	  if (fib->fib_DirEntryType == ST_USERDIR)
	    {
	      rval = true;
	    }
	}



      FreeMem(fib,sizeof(*fib));

      UnLock(l);
    }
  return rval;
}

StreamPosition MyFile::size() const
{
  StreamPosition rval=-1;

  BPTR l = Lock(m_name.c_str(),ACCESS_READ);
  if (l)
    {
      struct FileInfoBlock *fib = (struct FileInfoBlock *)AllocMem(sizeof(*fib),MEMF_PUBLIC);
      if (Examine(l,fib))
	{
	  if (fib->fib_DirEntryType == ST_FILE)
	    {
	      rval = fib->fib_Size;
	    }
	}

      FreeMem(fib,sizeof(*fib));

      UnLock(l);
    }
  return rval;

}

#else

bool MyFile::create_as_dir()
{
    #ifndef _WIN32
  return ::mkdir(m_name.c_str(),0666) == 0;
   #else
  return ::mkdir(m_name.c_str()) == 0;

   #endif
}
bool MyFile::exists() const
{
  struct stat buf;
  return stat(buf);
}

#define STAT_TYPE_COND(t) (stat(buf)&&((buf.st_mode&t) == t))

bool MyFile::is_directory() const
{
  struct stat buf;
  return STAT_TYPE_COND(S_IFDIR);
}
bool MyFile::is_fifo() const
{
  struct stat buf;
  return STAT_TYPE_COND(S_IFIFO);
}

StreamPosition MyFile::size() const
{
  StreamPosition rval=-1;
  struct stat buf;

  if (STAT_TYPE_COND(S_IFREG))
    {
      // size in bytes

      rval=buf.st_size;
    }

  // returns the size in bytes or -1 if error

  return rval;
}

StreamSize MyFile::read_bytes(void *data,int sz) const
{
  StreamSize rval = -1;
  FILE *f = fopen(get_name().c_str(),"rb");

  rval = fread((char*)data,1,sz,f);
  fclose(f);

  return rval;
}

bool MyFile::stat(struct stat &buf) const
{
  return (::stat(m_name.c_str(),&buf) == 0);
}

bool MyFile::dir
  (
  std::list<MyString> &elts,	//: I/O : list to fill
  bool hide_dirs,	//: I : do not list directories if set
  bool hide_files,	//: I : do not list files if set
  bool absolute_path,	//: I : list items with absolute path if set
  bool include_subdirs,	//: I : scan sub directories if set
  bool append_to_list	//: I : append to existing file list if set
) const

{


  bool retour=false;
  struct dirent *strdir;

  if (!append_to_list)
    {
      elts.clear();
    }

  // test existence repertoire et memoriser l'ancien chemin

  if (exists())
    {
      DIR *d;
      // ouvrir le repertoire

      d=opendir(m_name.c_str());

      if (d!=NULL)
	{
	  retour=true;

	  while ( (strdir=readdir(d))!=NULL )
	    {
	      // chemin complet;

	      MyString namebase=strdir->d_name;
	      MyString name_elt = m_name / namebase;

	      // repertoire?

	      MyFile rep(name_elt);

	      // soit on autorise les repertoires soit
	      // ce n'en est pas un

	      bool isrep=rep.is_directory();

	      if ((isrep)&&(include_subdirs)&&
		  (namebase!="..")&&(namebase!="."))
		{
		  // call the function with the name of the subdir
		  // the same list, and the append mode

		  if (!rep.dir(elts,
			       hide_dirs,
			       hide_files,
			       absolute_path,
			       include_subdirs,
			       true))
		    {
		      // an error has occured during the subdir scan
		    }


		}

	      if ((!hide_dirs)||(!isrep))
		{
		  // s'il s'agit d'un fichier ou d'un repertoire ne
		  // different de .. (parent) et . (courant UNIX)

		  if ((!isrep)||((namebase!="..")&&(namebase!=".")))
		    {
		      if ((isrep)||(!hide_files))
			{
			  // ajouter l'entree dans la liste avec le chemin
			  // absolu ou sans selon l'option desiree

			  //@ check if the filter is active
			  //@ if so (!="*") then check the pattern

			  {
			    if (absolute_path)
			      {
				elts.push_back(name_elt);
			      }
			    else
			      {
				// pas de chemin complet

				elts.push_back(namebase);

			      }
			  }
			}
		    }
		}

	    }

	  closedir(d);

	}

    }

  return retour;
}
#endif

MyVector<MyString> MyFile::read_all_lines() const
{

  StreamPosition length_read;

  char *c = (char*) read_all(length_read);

  MyString s(c);
  LOGGED_DELETE_ARRAY(c);

  s.substitute("\r","");
  return s.split('\n');

}


#if 0
MyString MyFile::temp_name()
{
    // create temporary file
    char tmp_string[L_tmpnam];
    tmpnam(tmp_string);

    return tmp_string;
}
#endif
