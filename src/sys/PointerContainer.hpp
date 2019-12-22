/*---------------------------------------------------------------------------*
 *         (C) 2004-2008  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef POINTERCONTAINER_H
#define POINTERCONTAINER_H

/*------------*
 * Used units *
 *------------*/

#include "MyAssert.hpp"
#include "MemoryEntryMap.hpp"

#include <cstddef>

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 * container used to contain derived classes of an abstract class
 *
 * list is protected against copy/affectation
 * list contents are deleted on destructor call
 *
 * CNT must be a stl-style container like list<T *> or vector<T *>
 *
 * @author  Jean-Francois FABRE
 *
 */

template <class T, class CNT, bool DELETE_MEMORY = true>
class PointerContainer
{
public:
    typedef CNT ListType;
    typedef typename ListType::const_iterator const_iterator;
    typedef typename ListType::iterator iterator;
    typedef typename ListType::reverse_iterator reverse_iterator;
    typedef typename ListType::const_reverse_iterator const_reverse_iterator;

    PointerContainer() {}

    virtual ~PointerContainer()
    {
        clear();
    }

    PointerContainer(const PointerContainer &other)
    {
        copy_from(other);
    }
    PointerContainer &operator=(const PointerContainer &other)
    {
        if (&other != this)
        {
        copy_from(other);
        }
        return *this;
    }
    const_iterator begin() const
    {
        return m_items.begin();
    }
    iterator begin()
    {
        return m_items.begin();
    }
    iterator end()
    {
        return m_items.end();
    }
    reverse_iterator rbegin()
    {
        return m_items.rbegin();
    }
    reverse_iterator rend()
    {
        return m_items.rend();
    }
    const_reverse_iterator rbegin() const
    {
        return m_items.rbegin();
    }
    const_reverse_iterator rend() const
    {
        return m_items.rend();
    }
    const_iterator end() const
    {
        return m_items.end();
    }

    void remove(T *o, bool free_memory = DELETE_MEMORY)
    {
        m_items.remove(o);

        if (free_memory)
        {
            LOGGED_DELETE(o); // also sets o to 0, hence the "remove" operation must be done first
        }
    }

    bool empty() const
    {
        return m_items.empty();
    }
    void clear(bool free_memory = DELETE_MEMORY)
    {

        if (free_memory)
        {
            free();
        }
        else
        {
            m_items.clear();
        }
    }

    void erase(iterator it, bool free_memory = DELETE_MEMORY)
    {
        if (free_memory)
        {
            LOGGED_DELETE (*it);
        }
       m_items.erase(it);
    }
    void free()
    {
        iterator it;
        for (it = begin(); it != end(); it++)
        {
            LOGGED_DELETE (*it);
        }

        m_items.clear();
    }
    size_t size() const
    {
        return m_items.size();
    }

    /**
     * @return internal storage
     */

    const ListType &contents() const
    {
        return m_items;
    }

protected:

    CNT m_items;
    // not possible to copy it
private:
    void copy_from(const PointerContainer &other)
    {
        // not allowed if DELETE_MEMORY is set
        // (too bad it cannot be checked at compile time)
        my_assert(!DELETE_MEMORY);
        m_items = other.m_items;
    }
};



#endif /* -- End of unit, add nothing after this #endif -- */
