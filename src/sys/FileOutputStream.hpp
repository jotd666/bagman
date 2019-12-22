#ifndef FILEOUTPUTSTREAM_H
#define FILEOUTPUTSTREAM_H

#include <cstdio>

#include "InternalOutputStream.hpp"
#include "FileStream.hpp"
/**
 * internal output stream specialisation for writing files
 */

class FileOutputStream : public InternalOutputStream, protected FileStream
{
 public:
    FileOutputStream(const char *name,
		     const StreamProperties &props = StreamProperties(),
		     bool no_disk_write = false);
    FileOutputStream(const MyString &name,
		     const StreamProperties &props = StreamProperties(),
		     bool no_disk_write = false);

    virtual ~FileOutputStream();

    bool good() const;
    bool fail() const;

    void flush();
 private:
    void p_write(const void *ptr,StreamSize sz,bool flush_at_once);
    void internal_build(const MyString &name, bool no_disk_write);
    FILE *ofs;
    bool m_good;
    bool m_fifo_file;
};

#endif
