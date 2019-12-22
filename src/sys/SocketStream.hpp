#ifndef SOCKETSTREAM_INCLUDED
#define SOCKETSTREAM_INCLUDED

class SocketStream
{
 protected:
    SocketStream();
    ~SocketStream();
    bool ok;
    
 private:
    SocketStream(const SocketStream &);
    SocketStream &operator=(const SocketStream &);
};
#endif
