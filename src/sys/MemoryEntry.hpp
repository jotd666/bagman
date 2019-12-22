#ifndef MEMORYENTRY_H_INCLUDED
#define MEMORYENTRY_H_INCLUDED

#include "SysCompat.hpp"

#include <string>  // I'm not using MyString here because I want to log MyString object too

class MemoryEntry
{
public:
    MemoryEntry(int line, const char *filename, const char *item, void *address);

    int line;
    std::string filename;
    std::string item;
    void *address;

};


#endif // MEMORYENTRY_H_INCLUDED
