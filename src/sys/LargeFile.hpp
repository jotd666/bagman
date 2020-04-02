#ifndef LARGEFILE_GS_H
#define LARGEFILE_GS_H

#include "Long64.hpp"

#if defined _WIN32
// no 64-bit API available or directly supported
#define open64 open
#define fopen64 fopen
#define fseeko64 fseek
#define ftello64 ftell
#define O_LARGEFILE 0
#endif

#endif
