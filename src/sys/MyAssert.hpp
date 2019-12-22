/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   MyAssert.H
 *
 * @brief  .
 *
 * @author Christophe Giuge, Jean-Francois FABRE.
 *
 */

#ifndef MY_ASSERT_INCLUDED
#define MY_ASSERT_INCLUDED

void assert_failed(const char *e,const char *f,const int l);


#ifdef NDEBUG
#define my_assert(EX) ((void)0)
#else
#define my_assert(EX) (void)((EX) || (assert_failed(#EX, __FILE__, __LINE__), 0))
#endif

#endif

