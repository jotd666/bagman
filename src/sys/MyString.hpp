/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   MyString.H
 *
 * @brief  .
 *
 * @author Jean-Francois FABRE.
 *
 */

#ifndef MYSTRING_H
#define MYSTRING_H

/*------------*
 * Used units *
 *------------*/


#include "Long64.hpp"
#include "MyVector.hpp"
#include <climits>


/*-----------------*
 * Types & objects *
 *-----------------*/

class MyString;

/**
 * enhanced string, with integer/float support and
 * basename/filename methods
 *
 * also provides simple string test methods
 */
class MyString
{
public:
  typedef unsigned long size_type;
    /**
     * empty
     */

    MyString();

    /**
     * from char array
     */
    MyString(const char *str, const int size);
    /**
     * from null terminated char array
     */
    MyString(const char *str);

    /**
      * from character
      */
    MyString(const char val);

  MyString(const void *p);

    /**
     * from integer number
     */
    MyString(const int val, bool hexadecimal = false);

    /**
     * from long integer number
     */
    MyString(const long int val, bool hexadecimal = false);

    /**
     * from unsigned integer number
     */
    MyString(const unsigned int val, bool hexadecimal = false);

    /**
     * from unsigned long integer number
     */
    MyString(const unsigned long int val, bool hexadecimal = false);

    /**
     * from an array of char *
     * @param string_list NULL terminated or not list of strings
     * @param quote_char_start left char to print before each item (\0: none)
     * @param quote_char_end left char to print after each item (\0: none)
     * @param separation_char char to print between each item
     * @param item_count number of items (needed if string_list is not NULL terminated)
     */

    MyString(const char *string_list[],
             char quote_char_start = '\0',
             char quote_char_end = '\0',
             char separation_char = '\n',
             const int item_count = -1);


#ifdef __GLIBC_HAVE_LONG_LONG
    /**
     * from long long integer number
     */
    MyString(const long long int val, bool hexadecimal = false);
    /**
     * from long long integer number
     */
    MyString(const unsigned long long int val, bool hexadecimal = false);
#endif
    /**
     * from floating number
     */
    MyString(const float val, const int precision=-1);

    /**
     * from double precision number
     */
    MyString(const double val, const int precision=-1);


    /**
     * compute basename from name
     */

    MyString basename() const;

    /**
     * compute dirname from name
     */

    MyString dirname() const;

    /**
    * split string
    **/

    MyVector<MyString> split(char split_char) const;

    /**
     * check if contains a string
     **/

    bool contains(const MyString &str) const;

    /**
     * allocate a char * buffer
     */

    char *dup() const;

    /**
     * pad current string with a char
     * @param pad_char character used to pad
     * @param limit numbers of characters to reach
     * @param start true: pads from start else end
     */
    void pad
    (
        const char pad_char,
        const int limit,
        const bool start = true
    );

#ifdef  __GLIBC_HAVE_LONG_LONG
    /**
     * convert to integer value
     */

    bool int_value(long long &value, const bool hexadecimal = false) const;

    /**
     * convert to integer value
     */

    bool int_value(unsigned long long &value, const bool hexadecimal = false) const;

#endif
    /**
     * convert to integer value
     */

    bool int_value(int &value, const bool hexadecimal = false) const;

    /**
     * convert to floating point value
     */

    bool float_value(float &value) const;

    /**
     * convert to floating point (double precision) value
     */

    bool float_value(double &value) const;


    /**
     * appends dirname (if relative path)
     */

    void append_dirname(const MyString &dirname);

    /**
     * check if path is absolute
     */

    bool is_absolute_path(bool eval_env_variables = true) const;


    /**
     * check if string ends with char sequence
     * @param endstr assumed string end
     * @return true if string ends with \a endstr
     */

    bool ends_with(const MyString &endstr) const;

    /**
     * environment variable evaluation
     */

    MyString eval_env_variables() const;

    /**
     * check if string starts with char sequence
     * @param startstr assumed string starts
     * @return true if string starts with \a startstr
     */

    bool starts_with(const MyString &startstr) const;

    bool operator<(const MyString &other) const;

    MyString &operator+=(const MyString &val);
    MyString &operator+=(const char val);
    MyString &operator+=(const int val);
    MyString &operator+=(const long int val);
    MyString &operator+=(const float val);
    MyString operator+(const MyString &) const;

    friend MyString operator+(const char *str, const MyString &me);
    friend MyString operator+(const char str, const MyString &me);

    /**
     * concat with '/' insertion
     */

    MyString operator/(const MyString &other) const;

    /**
     * extract the left part of the string
     * @param separator separator string of left & right parts
     * @param start from end Y/N
     * @return left part of the string or full string if separator
     * is not present
     */

    MyString left
    (
        const char *separator,
        const bool end = false
    ) const;

    /**
     * extract the left part of the string
     * @param separator separator char of left & right parts
     * @param start from end Y/N
     * @return left part of the string or full string if separator
     * is not present
     */

    MyString left
    (
        const char separator,
        const bool end = false
    ) const;

    /**
     * extract the right part of the string
     * @param separator separator string of left & right parts
     * @param start from end Y/N
     * @return right part of the string or empty string if separator
     * is not present
     */

    MyString right
    (
        const char *separator,
        const bool end = false
    ) const;

    /**
     * extract the right part of the string
     * @param separator separator char of left & right parts
     * @param start from end Y/N
     */

    MyString right
    (
        const char separator,
        const bool end = false
    ) const;

    bool compare(const MyString &other,bool respect_case = true) const;

    MyString uppercase() const;

    MyString lowercase() const;

#ifdef HAS_REGEX
    bool regex_match(const char *regex) const;
#endif

    //inline operator const char *() const { return c_str(); }

    MyString &operator=(const char *other);
    MyString &operator=(const MyString &other);
    MyString(const MyString &other);
    ~MyString();
    bool operator==(const MyString &other) const;
    bool operator!=(const MyString &other) const;

    //friend std::ostream &operator<<(std::ostream &,const MyString &);

    typedef const char * const_iterator;
    typedef char * iterator;

    /**
     * extract sub string
     * @param pos start
     * @param n number of chars to extract
     */

    MyString substr(size_type pos = 0, size_type n = UINT_MAX) const;

    /**
    * replaces a string by another, returns replaced
    */

    MyString replace(const MyString &name1,const MyString &name2) const;

    /**
     * replaces a string by another, lenghts can differ, in-place
     */


    bool substitute(const MyString &looked_for,const MyString &replacer);

    size_type find_first_of(const char *x,size_type pos = 0) const;
    size_type find_first_not_of(const char *x,size_type pos = 0) const;
    size_type find_last_not_of(const char *chars,const size_type pos = UINT_MAX) const;
    size_type find_last_of(const char *x,size_type pos = UINT_MAX) const;
    size_type find_last_of(const char x,size_type pos = UINT_MAX) const;

    /**
     * finds the position of a substring
     * in the current string
    */


    size_type string_find(const MyString &substr,size_type start_pos = 0) const;

    size_type size() const
    {
        return m_size;
    }
    size_type length() const
    {
        return m_size;
    }
    const char *c_str() const
    {
        return m_contents;
    }
    char &operator[](const int pos);
    char operator[](const int pos) const;

    iterator begin()
    {
        return m_contents;
    }
    iterator end()
    {
        return m_contents+m_size;
    }
    const_iterator begin() const
    {
        return m_contents;
    }
    const_iterator end() const
    {
        return m_contents+m_size;
    }

protected:
private:
    size_type find_xxx_of(const char *chars,
                       const size_type start_pos,
                       const bool forward,
                       const bool negative
                      ) const;
    void allocate();
    void destroy();
    void build(const char *str);
    void build(const char *str, const int length);

    template <class T>
    void ostream_build(const T &val, const char *format);
    template <class T>
    void ostream_build_float(const T &val, int precision);

    template <class INT_TYPE>
    bool p_int_value(INT_TYPE &value, const bool hexadecimal = false) const;
    template <class FLT_TYPE>
    bool p_float_value(FLT_TYPE &value) const;
    //static char * realpath(const char *path, char *resolved);
    char *m_contents;
    int m_size;
};


#endif /* -- End of unit, add nothing after this #endif -- */
