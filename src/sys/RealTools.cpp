/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   real_tools.cc
 *
 * @brief  body.
 *
 * @author Jean-Francois FABRE .
 *
 */

/*------------*
 * Used units *
 *------------*/

#include "InputStream.hpp"
#include "OutputStream.hpp"
#include "RealTools.hpp"

#include <cmath>
#include <vector>

/*-----------------*
 * Types & objects *
 *-----------------*/

const float RealTools::default_relative_epsilon = 1e-10;

/*-----------*
 * Functions *
 *-----------*/

bool RealTools::read
(
    InputStream &infile,
    float *buffer,
    const int count
    )
{
    infile.read_bytes((void *)buffer,count*sizeof(float));

    return (infile.good());
}

bool RealTools::write
(
    OutputStream &outfile,
    const float *buffer,
    const int count
    )
{
    outfile.write((void *)buffer,count*sizeof(float));

    return (outfile.good());
}

float RealTools::modulo(const float a,const float m)
{
    float quotient = a / m;
    float remainder = quotient - floor(quotient);

    return remainder * m;
}


/**
     * get previous integer (lower than input)
     */

int RealTools::ceil(const float real_number)
{
    return int(::ceil(real_number));
}
    /**
     * get next integer (higher than input)
     */

int RealTools::floor(const float real_number)
{
    return int(::floor(real_number));
}
