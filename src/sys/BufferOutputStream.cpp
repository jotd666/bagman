#include "BufferOutputStream.hpp"
#include <stdlib.h>



BufferOutputStream::BufferOutputStream(const StreamProperties &props)
:
InternalOutputStream(props),
buffer(NULL),
bufsize(0),
ok(true)
{
    set_name("[output buffer]");
}

BufferOutputStream::~BufferOutputStream()
{
    flush();
}

void BufferOutputStream::flush()
{
    free(buffer);
}

void BufferOutputStream::p_write(const void *ptr,
			       StreamSize sz,
			       bool)
{
    int bytes_to_write = int(sz);

    // resize buffer
    buffer = (char *)realloc(buffer,bytes_to_write + bufsize);

    ok = (buffer != NULL);

    if (ok)
    {
	// append data to write to the buffer

	memcpy(buffer + bufsize,ptr,bytes_to_write);

	// update size

	bufsize += bytes_to_write;

    }

    m_position += sz;
}

bool BufferOutputStream::good() const
{
    return ok;
}

bool BufferOutputStream::fail() const
{
    return !ok;
}
