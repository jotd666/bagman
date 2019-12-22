#ifndef BUFFERINPUTSTREAM_INCLUDED
#define BUFFERINPUTSTREAM_INCLUDED

#include "InternalInputStream.hpp"
#include "SeekDir.hpp"

class BufferInputStream : public InternalInputStream
{
 public:
    enum MapMode { MODE_COPY, MODE_STEAL, MODE_MAP };
    /**
     * constructor
     * @param data data to read from
     * @param size size of the @a data array
     * @param map_mode: if MODE_COPY, copy data, if MODE_STEAL, data will be
     * deleted on object deletion (destruction responsibility is ours), if MODE_MAP, just
     * use the passed buffer and suppose it is valid until the destruction of the object
     * @param props stream properties of the buffer
     */


    BufferInputStream
    (const char *data,
     const StreamSize size,
     const MapMode map_mode = MODE_COPY,
     const StreamProperties &props = StreamProperties());

    virtual ~BufferInputStream();

    bool seekg(StreamPosition sp,SeekDir mode);
    StreamPosition tellg();
    bool good() const;
    bool fail() const;
    void clear();
    void ascii_read(float &value);
    void ascii_read(int &value);
 private:
    MapMode m_map_mode;
    char *m_buffer;
    long int m_position;
    StreamSize m_size;
    bool m_failed;
    void p_read(void *ptr,StreamSize sz);
    void allocate(const char *data,const StreamSize size);
    void destroy();
};

#endif
