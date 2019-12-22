#include "MyAssert.hpp"
#include "MyMacros.hpp"
#include "MyString.hpp"
#include "OutputStream.hpp"
#include "InternalOutputStream.hpp"

#include <stdio.h>
#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#define _write ::write
#endif

OutputStream::OutputStream(InternalOutputStream *s) : ofs(s)
{

}

void OutputStream::set_supported_format_mask(const int fm)
{
    my_assert(ofs != NULL);
    ofs->set_supported_format_mask(fm);
}

int OutputStream::get_supported_format_mask() const
{
    my_assert(ofs != NULL);
    return ofs->get_supported_format_mask();
}


StreamPosition OutputStream::tellg()
{
    my_assert(ofs != NULL);
    return ofs->tellg();
}

void OutputStream::set_data_format(StreamProperties::DataFormat df)
{
    my_assert(ofs != NULL);
    ofs->set_data_format(df);
}


int OutputStream::write_bytes(int fd, const char *buffer, int bufsize)
{
    return ::write(fd,buffer,bufsize);
}

bool OutputStream::write_all(int fd,const char *contents,int bufsize)
{
    bool rval = true;
    int written_bytes;
    int left_to_write = bufsize;
    while ((left_to_write > 0) && (rval))
    {
	written_bytes = write_bytes(fd,contents,left_to_write);
	rval = (written_bytes>=0);

	left_to_write -= written_bytes;
    }

    return rval;
}

void OutputStream::close()
{
    LOGGED_DELETE(ofs);
}


void OutputStream::setf(int params)
{
    my_assert(ofs != NULL);
    ofs->setf(params);
}

void OutputStream::setprecision(int precision)
{
    my_assert(ofs != NULL);
    ofs->setprecision(precision);
}

void OutputStream::set_user_data_1(const int user_data_1)
{
    my_assert(ofs != NULL);
    ofs->set_user_data_1(user_data_1);
}


void OutputStream::write(const void *ptr,
			 StreamSize sz,
			 bool flush_at_once)
{
    if (good())
    {
	ofs->write(ptr,sz,flush_at_once);
    }
}

void OutputStream::flush()
{
    my_assert(ofs!=NULL);
    ofs->flush();
}


bool OutputStream::good() const
{
    my_assert(ofs!=NULL);
    return ofs->good();
}

bool OutputStream::fail() const
{
    my_assert(ofs!=NULL);
    return ofs->fail();
}



OutputStream::~OutputStream()
{
    close();
}

bool OutputStream::is_open() const
{
    return ofs != NULL;
}


bool OutputStream::open(InternalOutputStream *s)
{
    my_assert(ofs == NULL);
    ofs = s;
    return good();
}

void OutputStream::set_name(const MyString &name)
{
    my_assert(ofs != NULL);
    ofs->set_name(name);
}

const MyString &OutputStream::get_name() const
{
    my_assert(ofs != NULL);
    return ofs->get_name();
}

void OutputStream::write_eof()
{
    static const char end_of_file = EOF;

    ofs->write((void*)(&end_of_file),1,1);

}

