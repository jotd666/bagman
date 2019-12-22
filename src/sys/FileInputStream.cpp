#include "FileInputStream.hpp"
#include "LargeFile.hpp"

FileInputStream::FileInputStream(const char *name,
				 const StreamProperties &props) :
InternalInputStream(props),
ifs(NULL)
{
    internal_build(name);
}
FileInputStream::FileInputStream(const MyString &name,
				 const StreamProperties &props) :
InternalInputStream(props),
ifs(NULL)
{
    internal_build(name);
}

void FileInputStream::internal_build(const MyString &name)
{
    set_name(name);

    ifs = fopen64(name.c_str(),"rb");
    m_good = (ifs != NULL);

    if (m_good)
    {
	// set buffer size if necessary
	set_buffer_size(ifs,get_block_size());
	// skip bytes if necessary
	seekg(get_byte_skip(),sd_beg);
    }
}

FileInputStream::~FileInputStream()
{
    if (ifs != NULL)
    {
	LOGGED_FCLOSE(ifs);
	ifs = NULL;
	m_good = false;
    }
}


bool FileInputStream::seekg(StreamPosition sp,SeekDir mode)
{
    int rval = 0;

    switch (mode)
    {
      case sd_cur:
	rval = fseeko64(ifs,sp,SEEK_CUR);
	break;
      case sd_beg:
	rval = fseeko64(ifs,sp,SEEK_SET);
	break;
      case sd_end:
	rval = fseeko64(ifs,sp,SEEK_END);
	break;
      default:
	my_assert(false);
	break;
    }

    return rval == 0;

}

void FileInputStream::p_read(void *ptr,StreamSize sz)
{
    unsigned char *ptr_char = (unsigned char *)ptr;

    // read required bytes & check read size
    m_good = sz > 0 ? ((StreamSize)fread((void *)ptr_char,sz,1,ifs) == 1) : true;
}


StreamPosition FileInputStream::tellg()
{
    return ftello64(ifs);
}

bool FileInputStream::good() const
{
    return m_good;
}
bool FileInputStream::fail() const
{
    return !good();
}

template <class T>
inline void FileInputStream::internal_ascii_read(const char *format,T &value)
{
    if (get_block_size() != 1)
    {
	abort_run("called whereas block size == %d (!= 1)",
		 get_block_size());
    }

    m_good = (fscanf(ifs,format,&value) != EOF);
}

void FileInputStream::ascii_read(float &value)
{
    ENTRYPOINT(ascii_read_float);

    internal_ascii_read("%f",value);

    EXITPOINT;
}
void FileInputStream::ascii_read(int &value)
{
    ENTRYPOINT(ascii_read_int);

    internal_ascii_read("%d",value);

    EXITPOINT;
}




