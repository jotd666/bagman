#ifndef GS_MATHS_H
#define GS_MATHS_H

#include <cfloat>
#include <complex>
#include <vector>

#include <string.h>

#define EPS 1.E-7f
#define MODEL_EPSILON 1.19209E-07f /* Model'Epsilon value from ADA */

#ifndef M_PI
#define M_PI         3.14159265358979323846
#endif

#define TWO_PI    (2. * M_PI)

// disable the use of cos and sin functions without GsMaths:: prefix

#define cos USE_GS_MATHS_COSR_INSTEAD
#define sin USE_GS_MATHS_SINR_INSTEAD
#define tan USE_GS_MATHS_TANR_INSTEAD
#define atan USE_GS_MATHS_ATANR_INSTEAD
#define acos USE_GS_MATHS_COSR_INSTEAD
#define asin USE_GS_MATHS_SINR_INSTEAD


namespace GsMaths
{

    /**
     * compare 2 floating point numbers
     * @param left float 1
     * @param right float 2
     * @param relative_epsilon relative threshold
     * @param absolute_epsilon absolute threshold
     */
    bool are_equal(float  left, float  right,
			  float  relative_epsilon=EPS,
			  float  absolute_epsilon=0.0 );


    bool equal_0(float x, float ref,
			float  relative_epsilon=EPS,
			float  absolute_epsilon=0.0 );

    /**
     * compute ln(x!)
     * @param x input
     */
    float factorial_ln(const float x);

    /**
     * check if a number is really 0 (without any threshold, using
     * a memory comparison)
     * @param x input
     * @return true if @a x == 0.0
     */

    inline bool is_zero(double x)
    {
	const double z(0.0f);
	return memcmp(&x,&z,sizeof(x)) == 0;
    }

    /**
     * compute positive modulo
     * @param a value to compute modulo of
     * @param b modulo value
     * @return modulo value included between 0 and a-1
     */

    inline int positive_modulo(const int a,const int b)
    {
    int rval = a % b;

    if (rval < 0)
    {
	rval += b;
    }

    return rval;

 }

 void limit_value(const float in, int &out);
 void limit_value(const float in, short &out);

 /**
  * check that all values of a list are a multiple of a value
  * of the list
  * @param numlist the list
  * @param precision comparison precision
  * @param smallest_value_index smallest value index
  *
  * @return true if all values are divisible by the smallest value
  */

 bool smallest_divisor(const std::vector<float> &numlist,
			      const float precision,
			      int &smallest_value_index);

 /**
  * compute greatest common divisor
  */

 int pgcd(int i, int j);
 inline int gcd(int i,int j) {return pgcd(i,j);}

 /**
  * compute smallest common multiple
  */


 int ppcm(int i, int j);
 inline int scm(int i,int j) {return ppcm(i,j);}

    /**
     * get sign of the float value
     * @return 1 if 0 or above, -1 else
     */

template <class T>
 inline int sign(const T number)
 {
     return ((number >= 0) ? 1 : -1);
 }

/**
 * check if quotient is an integer number
 * @param numerator numerator
 * @param denominator denominator
 * @param epsilon relative epsilon for comparison
 * @return true if integer number
 */

 bool integer_quotient
 (const float numerator,
  const float denominator,
  const float epsilon=EPS);

 /**
  * cosine in degrees
  */
float cosd ( float angle );

 /**
  * sine in degrees
  */
float sind ( float angle );

 /**
  * tangent in degrees
  */
float tand ( float angle );

 /**
  * cosine AND sine in degrees
  */
void cos_and_sind ( const float angle,
			   float & cosValue, float & sinValue );

 /**
  * inverse cosine in degrees
  */
float acosd ( float value );
 /**
  * inverse sine in degrees
  */
 float asind ( float value );
 /**
  * inverse tangent in degrees
  */
float atand ( float value );
 /**
  * inverse bi-dimensional tangent in degrees
  */
float atan2d ( float y, float x );


 /**
  * cosine to sine conversion
  * @param cosx cosine
  * @param angle angle of the cosine in degree
  */

float cos2sin ( float cosx, float angle );
 /**
  * sine to cosine conversion
  * @param sinx sine
  * @param angle angle of the sine in degree
  */

float sin2cos ( float sinx, float angle );

/**
 * compute cos(phase) + i sin(phase)
 * @param phase in degrees
 */

std::complex<float> expi(const float phase);
/**
 * compute cos(phase) + i sin(phase)
 * @param phase in degrees (double precision)
 */
std::complex<float> expi(const double phase);

/////////////////////////

/**
 * Inf-protected inverse
 */

inline float safe_inverse(float x,float threshold = EPS)
{
    float rval;

    if (fabs(x) < threshold)
    {
	float sgn = x > 0 ? 1.0 : -1.0;
	rval = 1/threshold * sgn;
    }
    else
    {
	rval = 1/x;
    }

    return rval;
}

/**
 * absolute value
 */

 template <class T>
T abs ( const T x )
 {
     return ( x<0.0?(-x):x );
 }

#define DEF_TRIGO_METHOD(mname,type) \
type mname(const type x)
#define DEF_TRIGO_METHOD_2(mname,type) \
type mname(const type x, const type y)

    // all radian sin/cos/arccos/arcsin

    /**
     * acosr method
     */

DEF_TRIGO_METHOD(acosr,double);
DEF_TRIGO_METHOD(acosr,float);
DEF_TRIGO_METHOD(asinr,double);
DEF_TRIGO_METHOD(asinr,float);
DEF_TRIGO_METHOD(atanr,double);
DEF_TRIGO_METHOD(atanr,float);
DEF_TRIGO_METHOD(cosr,double);
DEF_TRIGO_METHOD(cosr,float);
DEF_TRIGO_METHOD(sinr,double);
DEF_TRIGO_METHOD(sinr,float);
DEF_TRIGO_METHOD(tanr,double);
DEF_TRIGO_METHOD(tanr,float);
DEF_TRIGO_METHOD_2(atan2r,double);
DEF_TRIGO_METHOD_2(atan2r,float);

#undef DEF_TRIGO_METHOD
#undef DEF_TRIGO_METHOD_2

/**
 * tell if a number is a power of 2
 */

bool is_power_of_2 (int n);

/**
 * get closest integer for a given float number
 * @param real_number input float number
 * @return closest integer
 *
 * ex: \a real_number = 0.43 -> returns 0
 * ex: \a real_number = 0.73 -> returns 1
 * ex: \a real_number = 0.5 -> returns 1
 * ex: \a real_number = -1.2 -> returns -1
 * ex: \a real_number = -1.7 -> returns -2
 * ex: \a real_number = -1.5 -> returns -1 (hopefully)
 */

 int closest_integer(const float real_number);


    /**
     * degree -> radian conversion
     */

  float degrees2radians ( const float degrees );
    /**
     * radian -> degree conversion
     */

  float radians2degrees ( const float radians );

    /**
     * reframe value between 0 and 2pi
     * @return reframed value
     */
  float set_bounds_0_2pi ( const float radians );

  //float set_bounds_90 ( const float degrees );

  /**
   * reframe value between -180 (included) and 180 (excluded)
   * @return reframed angle
   */
  float set_bounds_180 ( const float degrees );

/** interpolate an angle
 * @param running,  following: the two values between which interpolate
 *  @param delta, normalized gap , 0 -> running, 1 -> following.
 *  @return interpolated angle
 *  @brief linear interpolation and normalisation of angles
 */
  inline float interpolate(const float running,
			   const float following,
			   const float delta)
  {
      return set_bounds_180(running + delta * set_bounds_180(following - running));
  }
/** express an angle against a reference
* @param angle to be reframed
*  @param reference angle
*  @return reframed angle
*/

inline float reframe(const float angle, const float reference)
{
    return reference + set_bounds_180(angle - reference);
}
/**
   * reframe value between -@a half_window (included) and @a half_window (excluded)
   * @param angle in/out angle to reframe
   * @param half_window half window width
   */

  void  normalize_half_window(float & angle,const float half_window);
/**
   * reframe value between -180 (included) and 180 (excluded)
   * @param angle in/out angle to reframe
   */

  inline void  normalize180 ( float & angle )
  {
      normalize_half_window(angle,180.0);
  }
  void  normalize_window( float & angle,const float start, const float end );


  void restrict_angles (const float bearing, const float elevation,
			       float & restrict_bearing,
                               float & restrict_elevation );

  void restrict_pseudo_angles (const float pseudo_bearing,
				      const float pseudo_elevation,
				      float & restrict_pseudo_bearing,
				      float & restrict_pseudo_elevation );

  void calc_angles ( const float pseudo_bearing, float pseudo_elevation,
			    float & bearing, float & elevation );

  void calc_pseudo_angles(const float bearing,
				 const float elevation,
				 float & pseudo_bearing,
				 float &pseudo_elevation);

    /**
     * compute angular distance with [-180,180] range support
     * @param angle angle 1
     * @param origin angle 2
     * @return angle-origin (normalised so dist(-180,170) is 10 and not 350)
     */

  float angular_distance( float angle, float origin );

};

#endif // GS_MATHS_H
