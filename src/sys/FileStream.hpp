#ifndef FILESTREAM_H
#define FILESTREAM_H

#include "SeekDir.hpp"
#include <cstdio>


class FileStream
{
 public:

    FileStream();
    virtual ~FileStream();
 protected:
    void set_buffer_size(FILE *fs, const int buffer_size);

 private:

    FileStream(const FileStream&);
    FileStream operator=(const FileStream&);
    char *m_file_buffer;

};

#endif
