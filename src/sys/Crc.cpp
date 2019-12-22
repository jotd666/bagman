#include "Crc.hpp"

int Crc::crc(const int size,const void *data)
{
    int rval = 0;
    const char *cdata = reinterpret_cast<const char*>(data);
    
    // JFF: pas un vrai CRC pour l'instant
    for (int i = 0;i < size;i++)
    {
	rval += cdata[i];
    }

    return rval;
    
}
