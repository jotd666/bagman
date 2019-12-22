/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   MyFile.H
 *
 * @brief  .
 *
 * @author Jean-Francois FABRE.
 *
 */

#ifndef MYFILE_H
#define MYFILE_H

/*------------*
 * Used units *
 *------------*/

#include "MyString.hpp"
#include "SysCompat.hpp"
#include <sys/stat.h>
#include <list>

#if defined __USE_LARGEFILE64 && !defined SunOS
#define stat stat64
#endif
/**
 * disk file object, with test functions
 */

class MyFile
{
public:
    /**
     * construction
     */

    MyFile(const MyString &name);

    const MyString &get_name() const
    {
        return m_name;
    }
    void set_name(const MyString &name)
    {
        m_name = name;
    }

    MyVector<MyString> read_all_lines() const;
/**
* @param I/O list to fill
* @param do not list directories if set
* @param do not list files if set
* @param list items with absolute path if set
* @param scan sub directories if set
* @param append to existing file list if set
*/
    bool dir
    (
        std::list<MyString> &elts,
        bool hide_dirs = false,
        bool hide_files = false,
        bool absolute_path = false,
        bool include_subdirs = false,
        bool append_to_list = false
    ) const;

    /**
     * remove file from disk
     */

    bool del();

    /**
     * mere existence test
     */

    bool exists() const;

    /**
     * @return file size (64-bit compliant)
     */

    StreamPosition size() const;

    /**
     * @return true if file name points on a directory
     */

    bool is_directory() const;

    /**
     * @return true if file name points on a fifo (aka pipe) file
     */

  bool is_fifo() const;

  bool create_as_dir();
    /**
     * allocates a buffer of the file size
     * and reads all the file contents into it
     *
     * @param max_size size limit
     * @param length_read read length returned (size of buffer)
     * if length_read = 0 (means return value = NULL) file is empty
     * if length_read = -1(means return value = NULL) file could not be read
     *
     * @return allocated buffer with file contents. The caller is
     * responsible of the memory free (using delete[])
     *
     */

void *read_all(StreamPosition &length_read, const StreamPosition max_size = -1) const;

    template <class T>
    void read_all(MyVector<T> &rval) const
    {
        StreamPosition length_read = size();
        if (length_read > 0)
        {
               rval.resize(length_read);
               read_bytes(rval.raw_data(),length_read);
        }
    }

    /**
     * write bytes to the file
     */

    StreamPosition write_all(const StreamPosition length_to_write,
                             const void *buffer) const;

    //static MyString temp_name();
  StreamSize read_bytes(void *b,int sz) const;
private:
    /**
     * encapsulates the Unix stat call
     */

    bool stat(struct stat &buf) const;


    MyString m_name;
};

#endif

