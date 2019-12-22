#include "InternalInputStream.hpp"

void InternalInputStream::read(void *ptr,StreamSize sz)
{
    char *buf = (char *)ptr;

    p_read(buf,sz);

    if (swap_required())
    {
	swap_bytes(buf,sz);
    }
}
InternalInputStream::InternalInputStream(const StreamProperties &prop)
: StreamProperties(prop)
{
}

