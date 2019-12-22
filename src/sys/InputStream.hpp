#ifndef INPUTSTREAM_INCLUDED
#define INPUTSTREAM_INCLUDED

#include "MyStream.hpp"
#include "InternalInputStream.hpp"


/**
 * input stream master class
 */

class InputStream : public MyStream
{
 public:
    InputStream(InternalInputStream *s = NULL);
    virtual ~InputStream();
    bool open(InternalInputStream *s);

    MyString read_line();

    void set_name(const MyString &name);
    const MyString &get_name() const;

    void set_supported_format_mask(const int fm);

    int get_supported_format_mask() const;


    /**
     * set to the beginning of the stream (if possible)
     */

    void rewind();

    /**
     * read some bytes
     * @params ptr output buffer
     * @params sz size in bytes
     */

    template <class T>
    void read(MyVector<T> &ptr)
    {
        read(ptr,ptr.size());
    }

    template <class T>
    void read(MyVector<T> &ptr,StreamSize sz,StreamPosition vpos=0)
    {
        my_assert(sz+vpos<=(StreamSize)(ptr.size()*sizeof(T)));
        read_bytes(((char*)ptr.raw_data())+vpos,sz);
    }
    /**
     * move within the stream (if supported)
     * @param sp position or offset
     * @param mode ios::beg: from start, ios::cur: from current,
     * ios::end: from end
     */

    void seekg(StreamPosition sp,SeekDir mode);

    /**
     * give file current position if supported by this stream type
     */

    StreamPosition tellg();

    /**
     * close stream
     */

    void close();

    /**
     * check if stream has no errors
     */

    bool good() const;

    /**
     * check if stream has errors
     */

    bool fail() const;

    /**
     * check if stream has been opened
     */

    bool is_open() const;

    /**
     * read a char
     */

    char get();

    /**
     * set stream properties from an existing set of properties
     */

    void set_properties(const StreamProperties &props);

    /**
     * set stream format (I2, R4, etc...)
     * @param df data format
     */

    void set_data_format(StreamProperties::DataFormat df);

    static bool read_all(int fd,char *contents,int size);
    static int read_bytes(int fd,char *contents,int size);


    template <class T>
    InputStream &operator>>(T &value)
    {
	ifs->ascii_read(value);
	return *this;
    }
   void read_bytes(void *ptr,StreamSize sz);

 private:

    InternalInputStream *ifs;
};

#endif
