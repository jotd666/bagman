#include "MyAssert.hpp"
#include "MyMacros.hpp"
#include "InputStream.hpp"
#include "MyString.hpp"
#include "MemoryEntryMap.hpp"

#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#define _read ::read
#endif

using namespace std;

InputStream::InputStream(InternalInputStream *s) : ifs(s)
{

}

void InputStream::set_properties(const StreamProperties &props)
{
    my_assert(ifs != NULL);
    ifs->set_properties(props);
}

void InputStream::set_data_format(StreamProperties::DataFormat df)
{
    my_assert(ifs != NULL);
    ifs->set_data_format(df);
}

void InputStream::set_supported_format_mask(const int fm)
{
    my_assert(ifs != NULL);
    ifs->set_supported_format_mask(fm);
}

int InputStream::get_supported_format_mask() const
{
    my_assert(ifs != NULL);
    return ifs->get_supported_format_mask();
}
char InputStream::get()
{
    my_assert(ifs!=NULL);
    return ifs->get();
}

void InputStream::seekg(StreamPosition sp,SeekDir mode)
{
    my_assert(ifs!=NULL);
    ifs->seekg(sp,mode);
}
void InputStream::rewind()
{
    my_assert(ifs!=NULL);
    ifs->seekg(0,sd_beg);
}

void InputStream::close()
{
    LOGGED_DELETE(ifs);
}


bool InputStream::open(InternalInputStream *s)
{
    my_assert(ifs == NULL);

    ifs = s;
    return good();
}

void InputStream::read_bytes(void *ptr,StreamSize sz)
{
    my_assert(good());
    ifs->read(ptr,sz);
}

StreamPosition InputStream::tellg()
{
    my_assert(ifs!=NULL);
    return ifs->tellg();
}


bool InputStream::good() const
{
    my_assert(ifs!=NULL);
    return ifs->good();
}

bool InputStream::fail() const
{
    my_assert(ifs!=NULL);
    return ifs->fail();
}


MyString InputStream::read_line()
{
   char buffer[1000];
   unsigned int idx=0;
   while (good() && idx < sizeof(buffer))
   {
    read_bytes(buffer+idx,1);
    if (buffer[idx] == '\n') break;
    idx++;
   }
   buffer[idx] = '\0';

   return MyString(buffer);
}

InputStream::~InputStream()
{
    close();
}


bool InputStream::is_open() const
{
    return ifs != NULL;
}


int InputStream::read_bytes(int fd, char *buffer, int bufsize)
{
    return _read(fd,buffer,bufsize);
}

bool InputStream::read_all(int fd,char *contents,int size)
{
    bool rval = true;
    int bytes_read;
    int left_to_read = size;
    while ((left_to_read > 0) && (rval))
    {
	bytes_read = read_bytes(fd,contents,left_to_read);
	rval = (bytes_read>=0);

	left_to_read -= bytes_read;
    }

    return rval;
}


void InputStream::set_name(const MyString &name)
{
    my_assert(ifs != NULL);
    ifs->set_name(name);
}

const MyString &InputStream::get_name() const
{
    my_assert(ifs != NULL);
    return ifs->get_name();
}
