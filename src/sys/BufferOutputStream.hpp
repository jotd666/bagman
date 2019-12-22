#ifndef BUFFEROUTPUTSTREAM_INCLUDED
#define BUFFEROUTPUTSTREAM_INCLUDED

#include "InternalOutputStream.hpp"

class BufferOutputStream : public InternalOutputStream
{
 public:
    /**
     * build
     */
    
    BufferOutputStream(const StreamProperties &props =
		       StreamProperties());

    virtual ~BufferOutputStream();

    bool good() const;
    bool fail() const;
    const char *get_contents() const { return buffer; }
    char *steal_contents()
    {
	char *rval = buffer;
	buffer = NULL;
	bufsize = 0;
	ok = true;
	return rval; 
    }
    void flush();
    
    int get_size() const { return bufsize; }
 private:    
    void p_write(const void *ptr,StreamSize sz,bool flush_at_once);
    char *buffer;
    int bufsize;
    bool ok;
};

#endif
