#include "MemoryEntry.hpp"

MemoryEntry::MemoryEntry(int line, const char *filename, const char *item, void *address)
{
    this->line = line;
    this->filename = filename;
    this->item = item;
    this->address = address;
}

