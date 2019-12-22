#ifndef SPARSELAYER_H_INCLUDED
#define SPARSELAYER_H_INCLUDED

#include "Abortable.hpp"
#include "PointerList.hpp"
#include "PrmIo.hpp"
#include "MyMacros.hpp"
#include "MPLevel.hpp"

template <class T>
class SparseLayer : public Abortable
{
public:
    typedef PointerList<T,true> List;
    typedef PointerList<T,false> ListCopy;

    const List &get_items() const
    {
        return m_object_list;
    }
    List &get_items()
    {
        return m_object_list;
    }

    SparseLayer(int x_resolution, int y_resolution, MPLevel *level)
    {
        m_x_resolution = x_resolution;
        m_y_resolution = y_resolution;
        m_level = level;
        init();
    }

    int get_y_resolution() const
    {
        return m_y_resolution;
    }


    void add(T *item)
    {
        resolve_unnamed(item);
        m_object_list.push_back(item);
    }

    void remove(T *item, bool free_memory)
    {
        m_object_list.remove(item,free_memory);
    }

protected:
    void init()
    {
        m_naming_counter = 1;
    }

    int m_naming_counter;
    int m_x_resolution, m_y_resolution;
    MPLevel *m_level;

    virtual T* add_item(PrmIo &fr, int x_res, int y_res) = 0;
    virtual const char *get_block_name() const = 0;


    List m_object_list;

    const T *get(const MyString &name) const
    {
        const T *rval = 0;

        if (name != "")
        {
            typename List::const_iterator it;

            FOREACH(it,m_object_list)
            {
                if ((*it)->get_name() == name)
                {
                    rval = (*it);
                    break;
                }
            }
        }

        return rval;
    }


    T *get(const MyString &name)
    {
        T *rval = 0;

        if (name != "")
        {
            typename List::iterator it;

            FOREACH(it,m_object_list)
            {
                if ((*it)->get_name() == name)
                {
                    rval = (*it);
                    break;
                }
            }
        }

        return rval;
    }

    ListCopy get_items(int x, int y) const
    {
        ListCopy rval;

        typename List::iterator it;

        FOREACH(it,m_object_list)
        {
            const SDLRectangle &bounds = it->get_bounds();

            if (bounds.contains(x, y))
            {
                rval.push_back(&(*it));

            }
        }

        return rval;
    }


    SparseLayer()
    {
        init();
    }

private:
    void resolve_unnamed(T *o)
    {
        // generate a unique name for unnamed objects
        // or hash sets & sectors won't work
        if (o->get_name() == "")
        {
            o->set_name(MyString("_unnamed_")+m_naming_counter++);
        }
    }


    /*void move_objects(int x_len, int y_len)
    {
    for (T go : m_object_list)
        {
            go.set_coordinates(x_len + go.get_x(), y_len + go.get_y());
        }

    }
    void remove_invisible_objects(int width, int height)
    {
        ListIterator<T> it = m_object_list.listIterator();

        while (it.hasNext())
        {
            T go = it.next();
            boolean out_x = (go.get_x()+go.get_width() < 0) || (go.get_x() > width);

            if ( out_x || ((go.get_y()+go.get_height() < 0) || (go.get_y() > height)))
            {
                // completely off-screen: remove
                it.remove();
            }
        }

    }*/



};

#endif
