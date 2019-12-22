/*---------------------------------------------------------------------------*
 *         (C) 2005  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef POINTERVECTOR_H
#define POINTERVECTOR_H


#include "MyAssert.hpp"
#include "MyVector.hpp"
#include "PointerContainer.hpp"

/**
 * array of pointers.
 * can be set with other types (if dynamic cast is bound to succeed)
 *
 * simple access to l-values using [] operator
 * boundary check
 *
 * @author Jean-Francois FABRE.
 *
 */

template <class T, bool DELETE_MEMORY>
class PointerVector : public PointerContainer<T, MyVector<T *>, DELETE_MEMORY>
{
 public:
    typedef PointerContainer<T, MyVector<T *>, DELETE_MEMORY> Parent;

    /**
     * @param count number of items
     */

    PointerVector(const int count = 0)
    {
        Parent::m_items.resize(count,0);
    }

    void reserve(const int nb)
    {
	Parent::m_items.reserve(nb);
    }

    /**
     * set value at position
     *
     * @param ptr value to set (type must be derived from T or T)
     * @param pos position
     */

    template <class U>
    void set_value(U *ptr,int pos)
    {
	Parent::m_items[pos] = dynamic_cast<T *>(ptr);
	my_assert(Parent::m_items[pos] != 0);

    }


    /**
     * set the size afterwards (size must be empty to avoid
     * potential memory leaks. If a non-empty array must be
     * resized, call kill() first
     *
     * @param new_size size to dimension to
     */

    void resize(int new_size)
    {
	my_assert(Parent::empty());
	Parent::m_items.resize(new_size,0);
    }


    /**
     * append item
     */

    void push_back(T *item)
    {
	Parent::m_items.push_back(item);
    }

   /**
     * get item (non-const)
     *
     * @param idx index
     */

    T &operator[](const int idx)
    {
	return *(Parent::m_items[idx]);
    }

    /**
     * get item (const)
     *
     * @param idx index
     */

    const T &operator[](const int idx) const
    {
	return *(Parent::m_items[idx]);
    }

 private:

};


#endif
