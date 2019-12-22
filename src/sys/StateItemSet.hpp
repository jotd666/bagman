/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   StateItemSet.H
 *
 * @brief  .
 *
 * @author Jean-Francois FABRE.
 *
 */

#ifndef STATEITEMSET_H
#define STATEITEMSET_H

/*------------*
 * Used units *
 *------------*/

#include <list>
#ifdef USE_STD_ASSERT
#include <cassert>
#define my_assert assert
#else
#include "MyAssert.hpp"
#endif


#include "typename_compat.hpp"

/*-----------------*
 * Types & objects *
 *-----------------*/

/**
 * multi-state lists
 */

template <class T, int list_count, int spare_list_index=0>
class StateItemSet
{
  public:
  // common type shortcuts
  
  typedef std::list<T> ItemArray; ///< the data
  typedef TYPENAME ItemArray::iterator iterator; ///< "pointer" on the data
  typedef TYPENAME ItemArray::const_iterator const_iterator; ///< "pointer" on the data
  
    /**
     * default constructor,
     * both lists are empty
     */
    
    StateItemSet() : max_used_items(0), used_items(0), item_count(0)
	{
	    
	}
    
    /**
     * @param max_size maximum size (checked in allocate() method)
     * @param item object to initialise the list with
     */
    StateItemSet(const int max_size, const T &item = T()) : max_used_items(0)
	{
	    init(max_size,item);
	}

    /**
     * virtual, empty destructor
     */
    
    virtual ~StateItemSet() {}
    
 
/**
 * returns list of items in use
 * @retval used_tracks
*/
#define SIS_CHECK_BOUNDS(idx) my_assert ((idx < list_count) && (idx>=0))

    inline ItemArray &get_items(const int idx)
	{
	    SIS_CHECK_BOUNDS(idx);
	    return item_array[idx];
	}
    
/**
 * return list of items in use
 * @retval allocated (const reference)
*/

    inline const ItemArray &get_items(const int idx) const
	{
	    SIS_CHECK_BOUNDS(idx);
	    return item_array[idx];
	}


    /**
     * return allocated begin const iterator
     */

    inline const_iterator begin(const int idx) const
    { return get_items(idx).begin(); }

    /**
     * return allocated begin iterator
     */

    inline iterator begin(const int idx)
    { return get_items(idx).begin(); }

    /**
     * return allocated end const iterator
     */

    inline const_iterator end(const int idx) const
    { return get_items(idx).end(); }

    /**
     * return allocated end iterator
     */

    inline iterator end(const int idx)
    { return get_items(idx).end(); }

    /**
     * get max number of allocated items
     * in the whole execution
     */

    inline size_t get_max_used_size() const { return max_used_items;}

    /**
     * return max capacity for item set
     */
    
    inline size_t capacity() const
	{
	    return item_count;
	}


    /**
     * return available items for item set
     */
    
    inline size_t avail() const
	{
	    return item_array[spare_list_index].size();
	}


    /**
     * free all allocated items
     * if some items have been stolen using "steal", spare list size
     * is lower than original spare list size, since some items are
     * missing in the allocated list
     */
    
    virtual void reset()
	{
	    int i=0;

	    for (i=0;i<list_count;i++)
	    {
		if (i!=spare_list_index)
		{
		    ItemArray &dst = item_array[spare_list_index];
		    
		    // could have used transfer()
		    // but we chose a faster method
		    // (transfer updates used_items by
		    // checking source list size, which is
		    // not necessary since we know it will be
		    // eventually 0)
		    //
		    // transfer(i,spare_list_index);
		    
		    dst.splice(dst.begin(),item_array[i]);
		}
	    }
	    // set used items to 0 (no item in any list but spare)
	    used_items = 0;
	}
    

    /**
     * free item
     * @param src source list index
     * @param it item reference to free
     */
    
    void free(const int src, const iterator it)
	{
	    transfer(src,spare_list_index,it,false);
	}

    /**
     * allocate item to a list
     * @param dest index of destination list
     * @return reference of allocated item or NULL if no free store
     */
    
    iterator allocate(const int dest)
	{
	    iterator rval = end(dest);

	    if (!item_array[spare_list_index].empty())
	    {
		transfer(spare_list_index,dest,
			 item_array[spare_list_index].begin(),
			 true);

		// last item is returned
		
		rval = item_array[dest].end();
		rval--;
	    }

	    return rval;
	}

    /**
     * transfer all items from one list to another
     * @param src index of source list
     * @param dest index of destination list
     * @param insert_at_end true: insert at end of dest. list, else at start
     */

    void transfer(const int src, const int dest,
		  const bool insert_at_end = false)
	{
	    // sanity checks
	    my_assert(src != dest);
	    SIS_CHECK_BOUNDS(src);
	    SIS_CHECK_BOUNDS(dest);
	    
	    // if destination is spare item list, decrease used_items count
	    
	    if (dest == spare_list_index)
	    {
		used_items -= item_array[src].size();
	    }

	    // else, if source is spare item list, increase used_items count
	    // (I doubt that this would be used, because that would mean
	    // allocating more than one item at a time)
	    
	    else if (src == spare_list_index)
	    {
		one_more_item(item_array[src].size());
	    }

            // move all items
	    
	    item_array[dest].splice(insert_at_end ? item_array[dest].end() :
				    item_array[dest].begin(),item_array[src]);
	    

	}
    
    /**
     * transfer items from one list to another
     * @param src index of source list
     * @param dest index of destination list
     * @param it reference of the item to move
     * @param insert_at_end true: insert at end of dest. list, else at start
     */
    
    void transfer(const int src, const int dest, const iterator it,
		  const bool insert_at_end = false)
	{
	    // sanity checks
	    my_assert(src != dest);
	    SIS_CHECK_BOUNDS(src);
	    SIS_CHECK_BOUNDS(dest);

	    // move item
	    
	    item_array[dest].splice(insert_at_end ? item_array[dest].end() :
				    item_array[dest].begin(),
				    item_array[src],it);

	    // if destination is spare item list, decrease used_items count
	    
	    if (dest == spare_list_index)
	    {
		used_items--;
	    }

	    // else, if source is spare item list, increase used_items count
	    
	    else if (src == spare_list_index)
	    {
		one_more_item();
	    }
		   
	}
    
#undef SIS_CHECK_BOUNDS
    
  protected:

    ItemArray item_array[list_count];  ///< array of lists
    
    /**
     * "late" constructor, used to set size after the object
     * has been built
     */
    
    void init(const int max_size, const T &item = T(),
	      const int index = spare_list_index)
	{
	    int i;
	    
	    used_items=0;
	    item_array[index].clear();
	    
	    for (i=0;i<max_size;i++)
	    {
		item_array[index].push_back(item);
	    }

	    item_count = max_size;
	}
    
    /**
     * increase used item count by \a added
     */

    void one_more_item(const size_t added = 1)
	{
	    used_items+=added;
	    
	    if (max_used_items < used_items)
	    {
		max_used_items = used_items;
	    }
	}

    size_t max_used_items; ///< maximum number of items used in the execution
    size_t used_items; ///< items currently used in the execution
    size_t item_count; ///< max number of items (sum of all items in lists)
  private:


};


#endif /* -- End of unit, add nothing after this #endif -- */
