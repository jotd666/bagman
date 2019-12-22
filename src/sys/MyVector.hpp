/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   MyVector.H
 *
 * @brief  .
 *
 * @author Jean-Francois FABRE.
 *
 */

#ifndef MYVECTOR_H
#define MYVECTOR_H

/*------------*
 * Used units *
 *------------*/


#include <vector>

#include "MyAssert.hpp"

/*-----------------*
 * Types & objects *
 *-----------------*/

/**
 * same as standard library std::vector object, but with bound check
 */

template <class T>
class MyVector : public std::vector<T>
{
  public:
  typedef T value_type;
  typedef typename std::vector<T>::iterator iterator;
  typedef typename std::vector<T>::const_iterator const_iterator;
  typedef typename std::vector<T>::reference reference;
  typedef typename std::vector<T>::const_reference const_reference;

  typedef unsigned long size_t;
  typedef long ptrdiff_t;
  typedef size_t size_type;
  typedef ptrdiff_t difference_type;

    /**
     * default constructor
     */
    MyVector() : std::vector<T>() {}

    /**
     * constructor with size and value
     */

    MyVector(size_t n, const T& value) : std::vector<T>(n, value) {}

MyVector(size_t n,const T *value) : std::vector<T>(n)
{
    for (size_t i = 0; i < n; i++)
    {
        (*this)[i] = value[i];
    }
}
    /**
     * constructor with size and default value
     */
    MyVector(size_t n) : std::vector<T>(n) {}

    /**
     * raw data
     */

    const T *raw_data() const
    {
	const std::vector<T> &v = *this;
	return &v[0];
    }

    /**
     * raw data
     */

    T *raw_data()
    {
	std::vector<T> &v = *this;
	return &v[0];
    }

    /**
     * size of the vector
     */

    size_t size() const
    {
	const std::vector<T> &v = *this;
	return v.size();
    }

#define MYV_CHECK_BOUNDS(n) my_assert (n >= 0);my_assert (n < (int)size())

    /**
     * [] operator protected against out of bound indexes
     */

    inline reference operator[](const int n)
	{
	    MYV_CHECK_BOUNDS(n);
	    std::vector<T> &v = *this;
	    return v[n];
	}

    /**
     * [] const operator protected against out of bound indexes
     */

    inline const_reference operator[](const int n) const
	{
	    MYV_CHECK_BOUNDS(n);
	    const std::vector<T> &v = *this;
	    return v[n];
	}
#undef MYV_CHECK_BOUNDS
  protected:

};


#endif /* -- End of unit, add nothing after this #endif -- */
