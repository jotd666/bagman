/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   my_assert.cc
 *
 * @brief  .
 *
 * @author Jean-Francois FABRE.
 *
 */


#ifdef _NDS
#define CLASS_TEST

#endif

#include <stdio.h>

#ifndef CLASS_TEST
#include "Abortable.hpp"
#endif

using namespace std;

// get him officer, he was trying to violate a segmentation

void assert_failed(const char *e,const char *f,const int l)
{
  // -----> WELCOME TO THE "ASSERTION FAILED" TRAP <-----

  // you have reached this point because the coder (or more likely
  // yourself) failed to code some feature and was catched just
  // before the segmentation violation or worse.
  //
  // Now, in order to get out from the pit, use "stack up one frame"
  // as many times as necessary to reach a context you know of
#ifdef _NDS
  printf("%s:%d: failed assertion `%s`\n",f,l,e);
#else
  fprintf(stderr,"%s:%d: failed assertion `%s`\n",f,l,e);
#endif

#ifndef CLASS_TEST
  // print stacktrace (remove if you don't have the Abortable
  // object stacktrace system)
#ifdef _HAS_THREADS
  fputs(Abortable::stack_trace().c_str(),stderr);
#endif
#endif
  // get out

  exit(EXIT_FAILURE);
}
