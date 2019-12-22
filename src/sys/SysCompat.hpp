#ifndef SYSCOMPAT_H
#define SYSCOMPAT_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif


#if defined SunOS && !defined _XOPEN_SOURCE
#define _XOPEN_SOURCE
#define XOPEN_SOURCE_FORCED
#endif

#if defined Linux
#include <features.h>
#endif

#if defined SunOS && !defined _XOPEN_SOURCE
#define _XOPEN_SOURCE
#define XOPEN_SOURCE_FORCED
#endif

#include <csignal>

#if defined SunOS && defined XOPEN_SOURCE_FORCED
#undef _XOPEN_SOURCE
#endif

#ifdef __USE_LARGEFILE64

typedef __off64_t StreamSize;
typedef __off64_t StreamOffset;
typedef __off64_t StreamPosition;
#else
typedef long int StreamSize;
typedef long int StreamOffset;
typedef long int StreamPosition;
#endif



#endif
