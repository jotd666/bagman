#ifndef ENDIAN_UTILS_H
#define ENDIAN_UTILS_H

#include "InputStream.hpp"

class EndianUtils
{
public:

    static inline int read_be_word(InputStream &f)
    {
        char w[2];
        f.read_bytes(w,2);

        return read_be_word(w);
    }
    static inline int read_le_word(InputStream &f)
    {
        char w[2];
        f.read_bytes(w,2);

        return read_le_word(w);
    }

    static inline  int read_be_long(InputStream &f)
    {
        char w[4];
        f.read_bytes(w,4);
        return read_be_long(w);
    }

    static inline int read_byte(InputStream &f)
    {
        char c;
        f.read_bytes(&c,1);
        return (int)c;
    }

    static inline int read_byte(const void *data)
    {
        const unsigned char *cdata = reinterpret_cast<const unsigned char*>(data);
        int c1 = cdata[0];

        return c1;

    }
    static inline int read_be_word(const void *data)
    {
        const unsigned char *cdata = reinterpret_cast<const unsigned char*>(data);
        int c1 = cdata[0];
        int c2 = cdata[1];
        return c1 * 256 + c2;

    }
    static inline int read_le_word(const void *data)
    {
        const unsigned char *cdata = reinterpret_cast<const unsigned char*>(data);
        int c1 = cdata[0];
        int c2 = cdata[1];
        return c2 * 256 + c1;

    }
    static inline int read_be_long(const void *data)
    {
        const unsigned char *cdata = reinterpret_cast<const unsigned char*>(data);
        int c1 = cdata[0];
        int c2 = cdata[1];
        int c3 = cdata[2];
        int c4 = cdata[3];

        return (c1 << 24) + (c2 << 16) + (c3 << 8) + c4;

    }

};

#endif
