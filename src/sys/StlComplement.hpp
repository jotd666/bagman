#ifndef STL_COMPLEMENT_H
#define STL_COMPLEMENT_H
#ifdef _WIN32
#include <cmath>

/**
 * missing stuff in Visual C++ environment
 */

namespace std
{
   template <class T>
   T max(const T e1, const T e2)
   {
       return e1 > e2 ? e1 : e2;
   }
   template <class T>
   T min(const T e1, const T e2)
   {
       return e1 < e2 ? e1 : e2;
   }
#define DEF_TWO_ARG_FUNC(f) \
template <class T>  \
T f(const T v1,const T v2) \
   {  \
	return ::f(v1,v2); \
}
#define DEF_ONE_ARG_FUNC(f) \
template <class T>  \
T f(const T v) \
   {  \
	return ::f(v); \
}

	DEF_ONE_ARG_FUNC(fabs)
	DEF_ONE_ARG_FUNC(log)
	DEF_ONE_ARG_FUNC(log10)
	DEF_ONE_ARG_FUNC(sqrt)
	DEF_ONE_ARG_FUNC(exp)
	DEF_ONE_ARG_FUNC(floor)
	DEF_ONE_ARG_FUNC(ceil)
	DEF_TWO_ARG_FUNC(pow)

#undef DEF_TWO_ARG_FUNC
#undef DEF_ONE_ARG_FUNC

    typedef ::size_t size_t;
    typedef size_t size_type;
}
#endif
#endif
