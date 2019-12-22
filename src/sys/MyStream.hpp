#ifndef MYSTREAM_H
#define MYSTREAM_H

#include "MyString.hpp"

class MyStream
{
 public:
    static const char endl;
    MyStream() {};
    virtual ~MyStream() {}

    virtual void close() = 0;
    virtual bool good() const = 0;
    virtual bool fail() const = 0;
    virtual bool is_open() const = 0;

    operator bool()
    { return !fail(); }

    virtual void set_name(const MyString &name) = 0;
    virtual const MyString &get_name() const = 0;
 private:
    MyStream &operator=(const MyStream &other);
    MyStream(const MyStream &other);
};

#endif
