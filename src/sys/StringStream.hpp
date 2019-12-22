#if defined __GNUC__ &&  __GNUC__ == 2
// gcc 2
#include <strstream>
#define DEPRECATED_SSTREAM
#else
#include <sstream>
#endif
