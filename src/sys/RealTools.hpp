/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/

/**
 * @file   RealTools.H
 *
 * @brief  spec.
 *
 * @author Jean-Francois FABRE .
 *
 */

#ifndef REALTOOLS_H
#define REALTOOLS_H

/*------------*
 * Used units *
 *------------*/


#include "GsDefine.hpp"

#include <vector>

using namespace std;

/*-----------------*
 * Types & objects *
 *-----------------*/

class InputStream;
class OutputStream;

class RealTools
{
public:
    static const float default_relative_epsilon; ///< default epsilon
    

    
    /**
     * compute floating point modulo
     * @param a number to compute modulo for
     * @param m modulo value
     */

    static float modulo(const float a,const float m);
    
    /**
     * get next integer (higher than input)
     */
    
    static int floor(const float real_number);
    

    /**
     * get previous integer (lower than input)
     */
    
    static int ceil(const float real_number);
    


    /**
     * read some float numbers in a file
     * @param infile in/out file to read from
     * @param buffer out buffer to write into
     * @param count number of items to read
     */

    static bool read
    (
	InputStream &infile,
	float *buffer,
	const int count=1);
    
    /**
     * write some float numbers in a file
     * @param outfile in/out file to write into
     * @param buffer out buffer to read from
     * @param count number of items to write
     */

    static bool write
    (
	OutputStream &outfile,
	const float *buffer,
	const int count=1);

    protected:

    /**
     * protected to avoid instanciation
     */
    
    ~RealTools();
  private:

};

#endif /* -- End of unit, add nothing after this #endif -- */


