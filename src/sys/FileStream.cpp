#include "FileStream.hpp"


#ifndef _SBFSIZ
#define _SBFSIZ 0
#endif

#include "MemoryEntryMap.hpp"

FileStream::~FileStream()
{
    LOGGED_DELETE_ARRAY(m_file_buffer);
}

FileStream::FileStream() : m_file_buffer(NULL)
{
}

void FileStream::set_buffer_size(FILE *fs, const int buffer_size)
{
    if (buffer_size != 1)
    {
	LOGGED_DELETE_ARRAY(m_file_buffer);
	const int len = buffer_size + _SBFSIZ;
	LOGGED_NEW( m_file_buffer,char[len]);
	setvbuf(fs,m_file_buffer,_IOFBF,len);
    }
}
