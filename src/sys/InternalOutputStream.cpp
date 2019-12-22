#include "InternalOutputStream.hpp"
#include "GsStringStream.hpp"

#include <iomanip>

using namespace std;

void InternalOutputStream::ascii_write(const char value)
{
    write(&value,1,false);
}
void InternalOutputStream::write_string(const MyString &str)
{
    write(str.c_str(),str.size(),false);
}

void InternalOutputStream::ascii_write(const double value)
{
    if (m_precision > 0)
    {
	write_string(MyString(value,m_precision));
    }
    else
    {
	write_string(MyString(value));
    }
}

StreamPosition InternalOutputStream::tellg()
{
    return m_position;
}

void InternalOutputStream::write(const void *ptr,
				 StreamSize sz,
				 bool flush_at_once)
{
    bool sr = swap_required() && (sz > 1);
    char *buf = 0;
    const char *to_write = reinterpret_cast<const char *>(ptr);

    if (sr)
    {
	buf = get_swapped_copy(to_write, sz);
	to_write = buf;
    }

    p_write(to_write,sz,flush_at_once);

    delete [] buf;
}


void InternalOutputStream::ascii_write(const int value)
{
    write_string(MyString(value));
}

void InternalOutputStream::ascii_write(const MyString &str)
{
    p_write(str.c_str(),str.length(),false);
}
/*
void InternalOutputStream::ascii_write(std::ostream & (*osfunc)(std::ostream &) )
{
#ifndef _NDS
    std::ostringstream oss;
    oss << osfunc;
    write_string(oss.str().c_str());
    #else
    warn("NDS write: not supported");
#endif
}
*/
void InternalOutputStream::setf(int prop)
{
    m_setf_properties = prop;
}

void InternalOutputStream::setprecision(int prec)
{
    my_assert(prec > 0);
    m_precision = prec;
}

InternalOutputStream::InternalOutputStream(const StreamProperties &prop) :
StreamProperties(prop),
m_setf_properties(-1),
m_precision(-1),
m_position(0)
{

}
