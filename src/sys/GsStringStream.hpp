#ifndef GS_STRINGSTREAM_H

#if defined __GNUC__ &&  __GNUC__ == 2
// gcc 2
#include <strstream>
#define stringstream strstream
#define ostringstream ostrstream
#define istringstream istrstream

#define DEPRECATED_SSTREAM
#else
#include <sstream>
#endif
#endif

