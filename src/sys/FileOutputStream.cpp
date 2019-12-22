#include "FileOutputStream.hpp"
#include "LargeFile.hpp"
#include "MyFile.hpp"

FileOutputStream::FileOutputStream(const char *name,
				   const StreamProperties &props,
				   bool no_disk_write)
: InternalOutputStream(props)
{
  internal_build(name,no_disk_write);
}

FileOutputStream::FileOutputStream(const MyString &name,
				   const StreamProperties &props,
				   bool no_disk_write)
: InternalOutputStream(props)
{
  internal_build(name,no_disk_write);
}

void FileOutputStream::internal_build(const MyString &name,bool no_disk_write)
{
  set_name(name);
    
  ofs = NULL;
  m_good = true;
  m_fifo_file = MyFile(name).is_fifo();
    
  if (!no_disk_write)
    {
      ofs = fopen64(name.c_str(),"wb");
      m_good = (ofs != NULL);

      if (m_good)
	{
	  // set buffer size if necessary
	  set_buffer_size(ofs,get_block_size());
	}
    }
}

FileOutputStream::~FileOutputStream()
{
  if (ofs != NULL)
    {
      LOGGED_FCLOSE(ofs);
    }
}

void FileOutputStream::p_write(const void *ptr,StreamSize sz,bool)
{
    
  if (ofs != NULL)
    {
      m_good = (sz == 0); // always true if 0 bytes are written
	
      if (!m_good)
	{
	  // actual write to disk
	    
	  if (m_fifo_file)
	    {
	      // fifo file, cannot check
	      m_position += sz;
	      // write required bytes & check written size
	      m_good = (fwrite(ptr,sz,1,ofs) == 1);
	    }
	  else
	    {
	      // regular file, can get position to check for disk full...
		
	      StreamPosition before = ftello64(ofs);
	    
	      // write required bytes & check written size
	      m_good = (fwrite(ptr,sz,1,ofs) == 1);

	      if (m_good)
		{
		  // check against nasty filesystem bug
		  m_position = ftello64(ofs);

		  m_good = ((m_position - before) == sz);
		}
	    }
	}
    }
}

bool FileOutputStream::good() const
{
  return m_good;
}


bool FileOutputStream::fail() const
{
  return !good();
}


void FileOutputStream::flush()
{
  if (ofs != NULL)
    {
      fflush(ofs);
    }
}

