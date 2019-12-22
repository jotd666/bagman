#ifndef INTERNALINPUTSTREAM_INCLUDED
#define INTERNALINPUTSTREAM_INCLUDED

#include "MyAssert.hpp"
#include "StreamProperties.hpp"
#include "SeekDir.hpp"

#include <cstdio>

using namespace std;

class InternalInputStream : public StreamProperties
{
 public:
    InternalInputStream(const StreamProperties &props);

    /* required because inheritors use non-empty destructors */
    virtual ~InternalInputStream() {};

    void read(void *ptr,StreamSize sz);
    virtual StreamPosition tellg() = 0;
    virtual bool seekg(StreamPosition sp,SeekDir mode) = 0;
    virtual bool good() const = 0;
    virtual bool fail() const = 0;

    virtual void ascii_read(float &value) = 0;
    virtual void ascii_read(int &value) = 0;

    char get()
    {
	char rval;
	read(&rval,1);
	return fail() ? EOF : rval;
    }

    virtual void putback(const int )
    {
	my_assert(false);
    }

 private:
    virtual void p_read(void *ptr,StreamSize sz) = 0;

};

#endif
