#include "RandomNumber.hpp"

#include <stdlib.h>

#ifdef _NDS
const int RandomNumber::rand_max = RAND_MAX >> 16;
#else
const int RandomNumber::rand_max = RAND_MAX;
#endif

void RandomNumber::randomize()
{
    ::rand();
}

int RandomNumber::rand(int max_value)
{
    int rval = ::rand();
    #ifdef _NDS
    // RAND_MAX is big
    rval >>= 16;
    #endif

    return (rval*max_value) / rand_max;
}

bool RandomNumber::happens_once_out_of(int one_time_out_of)
{
    return ::rand()<(RAND_MAX/one_time_out_of);
}
