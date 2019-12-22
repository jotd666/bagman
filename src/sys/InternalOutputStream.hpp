#ifndef INTERNALOUTPUTSTREAM_INCLUDED
#define INTERNALOUTPUTSTREAM_INCLUDED

#include "MyAssert.hpp"
#include "MyString.hpp"
#include "StreamProperties.hpp"


class InternalOutputStream : public StreamProperties
{
 public:
    void write(const void *ptr,
	       StreamSize sz,
	       bool flush_at_once);
    virtual bool good() const = 0;
    virtual bool fail() const = 0;
    virtual void flush() = 0;
    void setf(int prop);
    void setprecision(int prec);

    StreamPosition tellg();

    InternalOutputStream(const StreamProperties &props);

    /* required because inheritors use non-empty destructors */
    virtual ~InternalOutputStream() {};

    // better to avoid template implementation of ascii_write method

    void ascii_write(const double value);

    void ascii_write(const int value);

    void ascii_write(const MyString &str);

    //void ascii_write(std::ostream & (*osfunc)(std::ostream &) );

    void ascii_write(const char *str)
    {
	write(str,strlen(str),false);
    }

    void ascii_write(const char str);

    void ascii_write(const float value)
    {
	ascii_write((double)value);
    }

 private:
    void write_string(const MyString &str);
    virtual void p_write(const void *ptr,
			 StreamSize sz,
			 bool flush_at_once) = 0;

    int m_setf_properties;
    int m_precision;
 protected:
    StreamPosition m_position;
};

#endif
