#include "SysCompat.hpp"
#include "StreamProperties.hpp"
#include "MyAssert.hpp"
#include "MyVector.hpp"


using namespace std;

#ifdef _HAS_THREADS
StreamProperties::ThreadLock &StreamProperties::ThreadLock::get_sem(int fd,SemListPool &slp)
{
    SemList &ssl = slp.get();
    SemList::iterator it = ssl.find(fd);

    if (it == ssl.end())
    {
	// create new mutex

	pair<SemList::iterator,bool> success = ssl.insert(make_pair(fd,ThreadLock()));

	my_assert(success.second);

	it = success.first;
    }

    return it->second;
}
#endif

static const char *data_format_str[] =
{
    "I1",  // char
    "U1",  // unsigned char
    "I2",
    "U2",
    "I4",
    "U4",
    "R4",
    NULL
};

static MyVector<int> create_data_size_table()
{
    MyVector<int> rval(1<<(((sizeof(data_format_str) - 2)/ sizeof(char *)) + 1));

    rval[StreamProperties::I1] = 1;
    rval[StreamProperties::U1] = 1;
    rval[StreamProperties::I2] = 2;
    rval[StreamProperties::U2] = 2;
    rval[StreamProperties::I4] = 4;
    rval[StreamProperties::U4] = 4;
    rval[StreamProperties::R4] = 4;

    return rval;
}

static const MyVector<int> data_size_table = create_data_size_table();

static const char *byte_ordering_str[] =
{
    "",  // native
    "BE", // big endian
    "LE", // little endian
    NULL
};

static bool endian_self_test()
{
    bool rval = true;

    /* test if big or little endian architecture */

    static const char *chr = "ABCD";
    int x;
    my_assert(sizeof(int) == 4);

    memcpy((void *)(&x),(void *)chr,sizeof(int));

    switch (x)
    {
      case 0x41424344:
	rval = true;
	break;
      case 0x44434241:
	rval = false;
	break;
      default:
	my_assert(false);
    }

    return rval;
}

static bool is_big_endian = endian_self_test();

bool StreamProperties::is_big_endian_architecture()
{
    return is_big_endian;
}

StreamProperties::StreamProperties()
: m_compound_size(1),
  m_supported_format_mask(-1) // all formats supported by default
{
    set_properties(I1);
}

StreamProperties::~StreamProperties()
{

}

// encoding is tricky because the format of most .e files must be preserved
// so the only way we have to introduce new features in the data read/write is
// to add information to the "format" field of the data header files
// First, there was R4, I2, I4
// Then I added optional endian information (BE, LE)
// Then I added optional blocksize information (32768, 2048k)
// Then I added optional byteskip information (skip_87)

void StreamProperties::set_data_encoding(const MyString &str)
{
    DataFormat data_format = UNDEFINED_FORMAT;
    int block_size = 1;
    int byte_skip = 0;
    ByteOrdering byte_ordering = NATIVE_ORDERING;
;

    if (str.contains('_'))
    {
	// complex format, ex: R4_BE_1024,
	// R4_2048k, or R4_BE, look for other part

	MyString right_part = str.right('_');

        // try blocksize, but can be BE, skip, ...

	if (!decode_block_size(right_part,block_size))
	{
	    // not a blocksize, is it composed?

	    if (right_part.contains('_'))
	    {
		// it is composed: BE_1024, BE_skip_10, BE_120_skip_1

		MyString right_right_part = right_part.right('_');

		// complex other part,
	        // BE_1024: endian & blocksize information

		if (decode_block_size(right_right_part,block_size))
		{
		    // try to decode skip size information
		    decode_skip_size(right_right_part.right('_'),byte_skip);
		    // blocksize information has been read, strip it
		    right_part = right_part.left('_');
		}
		else
		{
		    if (decode_skip_size(right_right_part,byte_skip))
		    {
			// skip information has been read, strip it
			right_part = right_part.left('_');
		    }
		    else
		    {
			// error: blocksize is not legal

			abort_run("Illegal blocksize for format %s",str);
		    }
		}
	    }


	    // decode byte ordering

	    byte_ordering = UNDEFINED_ORDERING;

	    string_to_enum(right_part,byte_ordering_str,
			   byte_ordering,NATIVE_ORDERING);
	    string_to_enum(str.left('_'),data_format_str,
			   data_format,I1,true);
	}
	// else other part is block size, native ordering is set, nothing to do
    }

    else
    {
	// simple format, ex: R4

	string_to_enum(str,data_format_str,data_format,
		       I1,true);
    }

    // set properties

    set_properties(data_format,byte_ordering,block_size,byte_skip);

}

bool StreamProperties::decode_skip_size(const MyString &str, int &bs) const
{
    // not a blocksize: can be skip_<number of bytes>
    bool rval = str.starts_with("skip_");

    if (rval)
    {
	if (!decode_block_size(str.substr(5),bs))
	{
	    abort_run("Illegal byteskip information for format %s",str);
	}
    }

    return rval;
}

bool StreamProperties::decode_block_size(const MyString &str,
					 int &bs) const
{
    bool rval = str.int_value(bs);

    if ((rval) && (bs>0))
    {
	switch(str[str.size()-1])
	{
	  case 'k':
	  case 'K':
	    // kilobyte
	    bs *= 1<<10;
	    break;
	  case 'm':
	  case 'M':
	    // megabyte
	    bs *= 1<<20;
	    break;
	  case '0':
	  case '1':
	  case '2':
	  case '3':
	  case '4':
	  case '5':
	  case '6':
	  case '7':
	  case '8':
	  case '9':
	    // digit, do nothing
	    break;
	  default:
	    // illegal multiplicator suffix
	    rval = false;
	    break;
	}
    }
    return rval;
}

void StreamProperties::set_byte_ordering(ByteOrdering bo)
{
    m_byte_ordering = bo;
}

StreamProperties::ByteOrdering StreamProperties::get_byte_ordering() const
{
    return m_byte_ordering;
}

MyString StreamProperties::get_data_encoding() const
{
    MyString string_data_format = enum_to_string(data_format_str,
						 m_data_format,
						 I1,
						 true);

    if (m_byte_ordering != NATIVE_ORDERING)
    {
	string_data_format += '_' +
	enum_to_string(byte_ordering_str,
		       m_byte_ordering,NATIVE_ORDERING);
    }

    if (m_block_size != 1)
    {
	string_data_format += '_' + MyString(m_block_size);
    }

    if (m_byte_skip != 0)
    {
	string_data_format += "_skip_" + MyString(m_byte_skip);
    }

    return string_data_format;
}

void StreamProperties::set_default_output_data_format()
{
    set_properties(R4);
    set_explicit_byte_ordering();
}

void StreamProperties::set_explicit_byte_ordering()
{
    m_byte_ordering = (is_big_endian) ? BIG_ENDIAN_ORDERING : LITTLE_ENDIAN_ORDERING;
}

/* static */ int StreamProperties::my_htonl(int n)
{
    int rval(n);
    if (!is_big_endian)
    {
	// we need to swap, network standard is big endian
	p_swap_bytes(&rval,1);
    }
    return rval;
}

bool StreamProperties::swap_required() const
{
    // if native, don't swap

    bool rval = (m_byte_ordering != NATIVE_ORDERING);

    if (rval)
    {
	if (is_big_endian)
	{
	    rval = (m_byte_ordering == LITTLE_ENDIAN_ORDERING);
	}
	else
	{
	    rval = (m_byte_ordering == BIG_ENDIAN_ORDERING);
	}
    }
    return rval;
}

void StreamProperties::set_data_format(DataFormat df)
{
    m_data_format = df;
    m_data_size = data_size_table[df];
    if ((m_supported_format_mask & (int)m_data_format) == 0)
    {
	abort_run("Format %q is unsupported by this stream "
		  "(mask 0x%x, dataformat 0x%x)",
		  get_data_encoding(),m_supported_format_mask,m_data_format);
    }
}

void StreamProperties::set_properties(const StreamProperties &other)
{
    set_data_format(other.get_data_format()); // check allowed type masks
    *this = other;
}

void StreamProperties::set_properties(DataFormat df,
				      ByteOrdering bo,
				      int block_size,
				      int byte_skip,
				      int user_data)
{
    m_byte_ordering = bo;
    m_block_size = block_size;
    m_byte_skip = byte_skip;
    m_user_data = user_data;

    set_data_format(df);

    if (block_size < 1)
    {
	abort_run("Blocksize cannot be < 1, %d passed",block_size);
    }
    if (byte_skip < 0)
    {
	abort_run("Byteskip cannot be < 0, %d passed",byte_skip);
    }

}

char *StreamProperties::get_swapped_copy(const char* bytes, const int bufsize) const
{
    char *swap_buffer;
    LOGGED_NEW(swap_buffer,char[bufsize]);
    memcpy(swap_buffer,bytes,bufsize);

    swap_bytes(swap_buffer,bufsize);

    return swap_buffer;
}

void StreamProperties::swap_bytes(char* bytes, const int bufsize) const
{
    switch (m_data_size)
    {
      case sizeof(char):
	// should not be called for that!
	break;
      case sizeof(short):
	p_swap_bytes((short *)bytes, bufsize / m_data_size);
	break;
      case sizeof(float):
	p_swap_bytes((float *)bytes, bufsize / m_data_size);
	break;
#if 0 //(sizeof(int) != sizeof(float))
      case sizeof(int):
	p_swap_bytes((int *)bytes, bufsize / m_data_size);
	break;
#endif
      default:
	my_assert(false);
	break;
    }
}

template <class T>
void StreamProperties::p_swap_bytes(T *bytes, const int count)
{
    char *char_bytes=(char *)bytes;
    char temp;
    const int halfsoft = sizeof(T)>>1;

    for (int i=0;i<count;i++)
    {
	for (int j=0;j<halfsoft;j++)
	{
	    char &byte1=char_bytes[j];
	    char &byte2=char_bytes[sizeof(T)-1-j];
	    temp=byte1;
	    byte1=byte2;
	    byte2=temp;
	}

	char_bytes+=sizeof(T);

    }
}

bool StreamProperties::is_signed_integer_format() const
{
    return ((m_data_format == I1) || (m_data_format == I2) ||
	    (m_data_format == I4));
}
bool StreamProperties::is_unsigned_integer_format() const
{
    return ((m_data_format == U1) || (m_data_format == U2) ||
	    (m_data_format == U4));
}
void StreamProperties::set_supported_format_mask(const int format_mask)
{
    m_supported_format_mask = format_mask;
}


