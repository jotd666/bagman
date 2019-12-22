#ifndef FILEINPUTSTREAM_H
#define FILEINPUTSTREAM_H


#include "InternalInputStream.hpp"
#include "FileStream.hpp"
#include "SeekDir.hpp"

/**
 * internal input stream specialisation for reading files
 */

class FileInputStream : public InternalInputStream, protected FileStream
{
 public:
    FileInputStream(const char *name,
		    const StreamProperties &props = StreamProperties());
    FileInputStream(const MyString &name,
		    const StreamProperties &props = StreamProperties());
    virtual ~FileInputStream();

    bool seekg(StreamPosition sp,SeekDir mode);
    StreamPosition tellg();
    bool good() const;
    bool fail() const;
    void ascii_read(float &value);
    void ascii_read(int &value);
 private:
    void p_read(void *ptr,StreamSize sz);
    void internal_build(const MyString &name);
    template <class T>
    void internal_ascii_read(const char *format,T &value);

    FILE *ifs;
    bool m_good;
};

#endif
