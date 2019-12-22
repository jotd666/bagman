#ifndef MYALLOC_H
#define MYALLOC_H

#include "SysCompat.hpp"
#ifndef _WIN32
#if defined SunOS || defined Linux || defined linux || !defined DONT_USE_ALLOCA
#define USE_ALLOCA
#endif
#endif

#include <stdlib.h>

#ifdef USE_ALLOCA
#include <alloca.h>

#define local_alloc(n,type) (type *)alloca((n) * sizeof(type))
#define local_free(s) (s = 0)
#else


#define local_alloc(n,type) (type *)malloc((n) * sizeof(type))
#define local_free(s) (free(s),s = 0)
#endif

#define local_alloc_zinit(n,type) (type *)memset(local_alloc((n),type),0,sizeof(type) * (n))
#endif
