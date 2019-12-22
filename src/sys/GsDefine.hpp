#ifndef GSDEFINE_H
#define GSDEFINE_H

#include <climits>
#include <cfloat>
#include <cmath>
#include <string.h> // memcmp

/**
 * undefined values for index, integer, float
 * (I agree that the define is dirty, but I had so many
 * problems with static const variables cross-object references with icc ...)
 */

#define undefined_integer INT_MAX


// NAN would have been suitable for the undefined_float purpose
// but out-of-order elaboration of nan value causes problems in icc

#if 0
#define undefined_float NAN
#define is_undefined_float(x) isnan(x)
#else

#define undefined_float FLT_MAX

/**
 * check if passed float is undefined
 * (equal to undefined_float)
 */

static inline bool is_undefined_float(const float x)
{
    static const float z(undefined_float);
    return memcmp(&x,&z,sizeof(x)) == 0;
}    

#endif

/**
 * check if passed float is not undefined
 * (different from undefined_float)
 */
#define is_not_undefined_float(x) (!is_undefined_float(x))

static inline bool is_zero(const float x)
{
    static const float z(0.0f);
    return memcmp(&x,&z,sizeof(x)) == 0;
}

#endif
