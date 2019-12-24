#include "GfxObjectLayer.hpp"
#include "MPLevel.hpp"



void GfxObjectLayer::add(GfxObject *o)
{
  m_object_list.push_back(o);
}

void GfxObjectLayer::remove_moving_objects()
{
  List::iterator it,it_next;
  it = m_object_list.begin();

  while (it != m_object_list.end())
    {
      it_next = it;
      it_next++;
      const GfxObject *go = (*it);

      if (go->is_moving())
	{
	  m_object_list.erase(it,true);
	}

      it = it_next;
    }

}
void GfxObjectLayer::update(int elapsed_time)
{
  List::iterator it = m_object_list.begin();
  FOREACH(it,m_object_list)
  {

    GfxObject &o = *(*it);

    o.update(elapsed_time);

  }
}

GfxObject *GfxObjectLayer::get_item_intersecting(const Locatable *l)
{
  GfxObject *rval = 0;
  List::iterator it;

  FOREACH (it,m_object_list)
  {
    GfxObject *o = (*it);
    // amiga kludge
    // character detection looks ok but with bags, barrow
    // and pickaxe, it seems that bounds include the 16+ width added
    // (why not for characters???) anyway, this kludge allows to reduce width
    // of the objects, but not of the characters
    #ifdef __amigaos
    auto b = o->get_bounds();
    b.w -= 16;
    #else
    auto &b = o->get_bounds();
    #endif
    if (b.intersects(l->get_bounds()))
      {
	rval = o;
      }
  }
  return rval;
}

int GfxObjectLayer::get_nb_bags() const
{
  List::const_iterator it;
  int nb_bags = 0;

  FOREACH (it,m_object_list)
  {

    if ((*it)->is_bag())
      {
	nb_bags++;
      }

  }
  return nb_bags;
}
const GfxObject *GfxObjectLayer::get_barrow() const
{
  List::const_iterator it;
  const GfxObject *rval = 0;

  FOREACH (it,m_object_list)
  {
    const GfxObject *go = (*it);

    if (go->get_type() == GfxObject::BARROW)
      {
	rval = go;
	break;
      }

  }
  return rval;
}
GfxObject *GfxObjectLayer::get_barrow()
{
  List::iterator it;
  GfxObject *rval = 0;

  FOREACH (it,m_object_list)
  {
    GfxObject *go = (*it);

    if (go->get_type() == GfxObject::BARROW)
      {
	rval = go;
	break;
      }

  }
  return rval;
}

void GfxObjectLayer::remove_picks()
{
  List::iterator it,it_next;
  it = m_object_list.begin();

  while (it != m_object_list.end())
    {
      it_next = it;
      it_next++;
      const GfxObject *go = (*it);

      if (go->get_type() == GfxObject::PICK)
	{
	  m_object_list.erase(it,true);
	}

      it = it_next;
    }

}

void GfxObjectLayer::render(Drawable &screen) const
{
  // TODO optimize according to screen bounds

  List::const_iterator it;

  FOREACH (it,m_object_list)
  {
    const GfxObject &go = *(*it);

    go.render(screen);
    #ifdef DEBUG_BOUNDS
    auto b=go.get_bounds();
    //b.w -= 16;

    screen.fill_rect(&b,4);
        #endif

  }
}



