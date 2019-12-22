#ifndef GFXOBJECTLAYER_H_INCLUDED
#define GFXOBJECTLAYER_H_INCLUDED

#include "GfxObject.hpp"
#include "Abortable.hpp"
#include "PointerList.hpp"

class GfxPaletteSet;
class MPLevel;

class GfxObjectLayer : public Abortable
{
public:
    DEF_GET_STRING_TYPE(GfxObjectLayer);

    void add(GfxObject *o);
    typedef PointerList<GfxObject> List;

    void remove_picks();
    void remove_moving_objects();

    const List &get_items() const
    {
        return m_object_list;
    }

    List &get_items()
    {
        return m_object_list;
    }

    GfxObject *get_item_intersecting(const Locatable *l);
    const GfxObject *get_barrow() const;
    GfxObject *get_barrow();
int get_nb_bags() const;

    void update(int elapsed_time);

    void render(Drawable &screen) const;

private:
    List m_object_list;
};

#endif
