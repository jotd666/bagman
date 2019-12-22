#ifndef LONG64_H
#define LONG64_H

#include "SysCompat.hpp"
#include <limits.h>

#if defined __INTEL_COMPILER && !defined __GLIBC_HAVE_LONG_LONG
#define __GLIBC_HAVE_LONG_LONG
#endif

#if defined __GLIBC_HAVE_LONG_LONG

// windows compatibilty
#ifndef LONG_LONG_MAX
#define LONG_LONG_MAX _I64_MAX
#define ULONG_LONG_MAX _UI64_MAX
#endif

typedef long long long64_t;
typedef unsigned long long ulong64_t;
#define MAX_ULONG64_VALUE ULONG_LONG_MAX
#define MAX_LONG64_VALUE LONG_LONG_MAX
#else
typedef long int long64_t;
typedef unsigned long int ulong64_t;
#define MAX_ULONG64_VALUE ULONG_MAX
#define MAX_LONG64_VALUE LONG_MAX
#endif

#endif
