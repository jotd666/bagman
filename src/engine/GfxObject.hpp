#ifndef GFXOBJECT_H_INCLUDED
#define GFXOBJECT_H_INCLUDED

#include "AnimatedSprite.hpp"
#include "GfxFrameSet.hpp"

class PrmIo;

class TileGrid;
class MPLevel;
class GfxPaletteSet;
class ImageFrame;
class SoundSet;

/**
* graphical object on screen
*/

class GfxObject : public AnimatedSprite
{
public:
    DEF_GET_STRING_TYPE(GfxObject);
    virtual ~GfxObject() {}

    enum Type { YELLOW_BAG, BLUE_BAG, PICK, BARROW };
    /*
    void spawn_linked_objects();
      LinkedList<GfxObject> get_linked_objects() const;
      void link_object(GfxObject go);*/

    virtual void update(int elapsed_time);
    GfxObject(const GfxFrameSet *frame_set, MPLevel *level, Type type);

    // offset for tile alignment
    int get_x_offset() const
    {
        return m_x_offset;
    }

    bool is_moving() const
    {
        return m_moving;
    }

    //void render(Drawable &screen) const;



    // virtual bool is_pickable() const;

    inline Type get_type() const
    {
        return m_type;
    }
    bool is_on_slope() const;

    inline bool is_bag() const
    {
        return m_type == YELLOW_BAG || m_type == BLUE_BAG;
    }
private:
    enum GroundType { GT_SOLID, GT_SLOPE_LEFT, GT_SLOPE_RIGHT, GT_GAP };

    GroundType compute_ground_type() const;
    MPLevel *m_level;
    GroundType m_previous_ground_type;
    const TileGrid *m_grid;
    GfxObject() : m_level(0)
    {
        init();
    }

    void set_frames(const GfxFrameSet *frame_set);


    void init();


    int m_timer;
    Type m_type;
    bool m_moving;
    int m_x_offset;
};

#endif
