#pragma once
//#define SIMPLE_SIZE

#ifdef _NDS
#define SIMPLE_SIZE
#endif
#ifdef __amigaos__
#define SIMPLE_SIZE
#define PARTIAL_REFRESH
#endif

#ifdef SIMPLE_SIZE
#define SCALE_SIZE 1
#define SCALE_DIVIDE 2
#else
// default: scaled 200%
#define SCALE_SIZE 2
#define SCALE_DIVIDE 1
#endif

