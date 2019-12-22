#include "BufferInputStream.hpp"
#include "MemoryEntryMap.hpp"
#include <string.h>


BufferInputStream::BufferInputStream(const char *data,
                                     const StreamSize size,
                                     MapMode map_mode,
                                     const StreamProperties &props) :
        InternalInputStream(props),
        m_map_mode(map_mode),
        m_buffer(NULL),
        m_position(0),
        m_failed(false)
{
    set_name("[input buffer, size "+MyString(size)+"]");
    allocate(data,size);
    if (props.get_byte_skip() != 0)
    {
        abort_run("Byteskip not supported");
    }

}

BufferInputStream::~BufferInputStream()
{
    destroy();
}

void BufferInputStream::allocate(const char *data,const StreamSize size)
{
    destroy();
    switch (m_map_mode)
    {
    case MODE_COPY:

    {
        LOGGED_NEW(m_buffer,char[size + 1]);

        memcpy(m_buffer,data,size);

        m_buffer[size] = '\0'; // to be more comfortable in debug, not necessary
    }
    break;
    case MODE_STEAL:
    case MODE_MAP:

    {
        m_buffer = (char *)data;
    }
    break;
    default:
        my_assert(1==0);
        break;
    }
    m_size = size;
}

void BufferInputStream::destroy()
{
    if (m_map_mode != MODE_MAP)
    {
        LOGGED_DELETE_ARRAY(m_buffer);
    }

    m_buffer = 0;
    m_failed = false;
    m_position = 0;
}


bool BufferInputStream::seekg(StreamPosition sp,SeekDir mode)
{
    switch (mode)
    {
    case sd_beg:
        m_position = sp;
        break;
    case sd_cur:
        m_position += sp;
        break;
    case sd_end:
        m_position = m_size + sp;
        break;
    default:
        my_assert(false);
    }

    return true;
}
void BufferInputStream::p_read(void *ptr,StreamSize sz)
{
    if (!m_failed)
    {
        m_failed = !good();

        if (!m_failed)
        {
            StreamSize sz_to_read = sz;
            m_failed = (m_size - tellg() < sz_to_read);

            if (m_failed)
            {
                sz_to_read = m_size - m_position;
            }
            if (sz_to_read > 0)
            {
                memcpy((char *)ptr,m_buffer+m_position,sz_to_read);
                m_position += sz_to_read;
            }
        }
    }
}


StreamPosition BufferInputStream::tellg()
{
    return m_position;
}

bool BufferInputStream::good() const
{
    // tells if next operation has some possibility to succeed
    return ((m_position >= 0) && (m_position < m_size));
}

void BufferInputStream::clear()
{
    m_failed = false;
}
bool BufferInputStream::fail() const
{
    // tells if last operation has failed and if next operation
    // will succeed

    return m_failed;
}

void BufferInputStream::ascii_read(float &)
{
    // not supported yet
    my_assert(false);
}
void BufferInputStream::ascii_read(int &)
{
    // not supported yet
    my_assert(false);
}

