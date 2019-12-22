#ifndef TYPENAMECOMPAT_INCLUDED
#define TYPENAMECOMPAT_INCLUDED

#if (defined __GNUC__ && __GNUC__ == 2) || (defined __INTEL_COMPILER)
#define TYPENAME
#else
#define TYPENAME typename
#endif


#endif
