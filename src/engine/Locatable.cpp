#include "Locatable.hpp"

Locatable::Locatable(int x, int y, int w, int h)
{
    set_x(x);
    set_y(y);
    m_rect.w = w;
    m_rect.h = h;
}

int Locatable::square_distance_to(const Locatable &go) const
	{
		int dx = go.get_x_center() - get_x_center();
		int dy = go.get_y_center() - get_y_center();

		return dx*dx + dy*dy;
	}
