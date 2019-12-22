#ifndef OUTPUTSTREAM_H
#define OUTPUTSTREAM_H

#include "MyStream.hpp"
#include "MyAssert.hpp"
#include "InternalOutputStream.hpp"

class MyString;

/**
 * output stream pseudo interface
 * @author JF Fabre
 */

class OutputStream : public MyStream
{
 public:

    /**
     * build from a specialized stream
     *
     * @param s stream, intialized with a call to new
     * and from now on is managed by this object (no need to keep a reference
     * on the specialized stream object to delete it later)
     */

    OutputStream(InternalOutputStream *s = 0);

    virtual ~OutputStream();

    /**
     * kind of late constructor
     */

    bool open(InternalOutputStream *s);

    /**
     * name the stream
     */

    void set_name(const MyString &name);

    /**
     * get the name of the stream
     */

    const MyString &get_name() const;

    /**
     * close the stream
     */

    void close();

    /**
     * write to stream
     */

    void write(const void *ptr,
	       StreamSize sz,
	       bool flush_at_once = false);

    /**
     * write end-of-file (useful for streams with multi-ASCII files)
     */

    void write_eof();

    bool good() const;
    bool fail() const;
    bool is_open() const;
    void flush();
    void setf(int);


    /**
     * give file current position if supported
     * by this stream type
     */

    StreamPosition tellg();

    void set_supported_format_mask(const int fm);
    int get_supported_format_mask() const;

    void set_data_format(StreamProperties::DataFormat df);
    void set_user_data_1(const int user_data_1);

    static int write_bytes(int fd, const char *buffer, int bufsize);
    static bool write_all(int fd, const char *buffer, int bufsize);

    void setprecision(int precision);

    template <class T>
    OutputStream &operator<<(const T &value)
    {
	my_assert(ofs != NULL);
	ofs->ascii_write(value);

	return *this;
    }

 private:

    InternalOutputStream *ofs;
};


#endif
