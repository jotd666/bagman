#include "GsMaths.hpp"
#include "GsDefine.hpp"

#include <climits>
#include <cmath>

using namespace std;


float GsMaths::factorial_ln(const float x)
{
    float rval=0.0;
    int i;

    for (i=2;i<=((int)x);i++)
    {
	rval += std::log(double(i)); // log(float(i)): trouble with icc link
    }

   return rval;

}

void GsMaths::limit_value(const float in, int &out)
{
    static const int min_value = -INT_MAX - 1;
    static const int max_value = INT_MAX;
    if (in > max_value)
    {
	out = max_value;
    }
    else if (in < min_value)
    {
	out = min_value;
    }
    else
    {
	out = (int)in;
    }
}

void GsMaths::limit_value(const float in, short &out)
{
    static const short min_value = -32768;
    static const short max_value = 32767;

    if (in > max_value)
    {
	out = max_value;
    }
    else if (in < min_value)
    {
	out = min_value;
    }
    else
    {
	out = (int)in;
    }

}

bool GsMaths::smallest_divisor(const std::vector<float> &numlist,
				const float precision,
				int &smallest_value_index)
{
    float smallest = FLT_MAX;
    bool over = numlist.empty(); // fails if list is empty
    int counter=0;
    std::vector<float>::const_iterator it;

    smallest_value_index = -1;

    // find the smallest value

    for (it=numlist.begin();it!=numlist.end();it++)
    {
	if (*it < smallest)
	{
	    smallest = *it;
	    smallest_value_index=counter;
	}

	counter++;
    }

    // check that the smallest value divides the others

    for (it=numlist.begin();it!=numlist.end() && !over;it++)
    {
	over = !integer_quotient(*it,smallest,precision);
    }

    return !over;

}

bool GsMaths::integer_quotient
(const float numerator,
 const float denominator,
 const float epsilon)
{
    bool rval = is_zero(denominator);

    if (!rval)
    {
	float quotient = numerator / denominator;

	// compare float value with closest integer

	rval = are_equal(quotient, (float)closest_integer(quotient),epsilon);

    }

    return rval;
}
//- Retourne le Plus Grand Commun Diviseur de deux nombres positifs.
//-

//+ Principe:
//-
//- GsMaths::pgcd(p,q) = GsMaths::pgcd(p modulo q,q)
//- GsMaths::pgcd(p,q) = GsMaths::pgcd(q,p)
//- GsMaths::pgcd(p,0) = p
//-
//- L'application de ces trois equations conduit au resultat.

int  GsMaths::pgcd(int p, int q) {


  int pl  = p;
  int ql  = q;

    // assertion: pl > 0 et ql > 0
    for (;;)
    {
        pl = pl % ql;
        if ( pl == 0 )
        {
            return ql;  // ql > 0
        }

        // assertion: ql > pl > 0

        ql = ql %  pl;

        if (ql == 0 )
        {
            return pl;  // pl > 0
        }

        // assertion: pl > ql > 0
    }
}

int GsMaths::ppcm(int p, int q)


//- Retourne le Plus Petit Commun Multiple de deux nombres positifs.

//+ Principe:
//-
//- GsMaths::pgcd(p,q) * GsMaths::ppcm(p,q) = p * q
//-
{
  return (p / pgcd(p,q)) * q; // attention aux parenthˆses -> Overflow

}

float GsMaths::cosd ( float angle ){
  return cosr ( (double)angle * M_PI / 180.0 );
}

float GsMaths::sind ( float angle ){
  return sinr ( (double)angle * M_PI / 180.0 );
}

float GsMaths::tand ( float angle ){
  return tanr ( (double)angle * M_PI / 180.0 );
}

void GsMaths::cos_and_sind ( const float angle,
			     float & cosValue, float & sinValue ){
    cosValue = cosd(angle);
    sinValue = sind(angle);
};

float GsMaths::acosd ( float value ){
  return ( 180.0 * acosr(value) / M_PI );
}

float GsMaths::asind ( float value ){
  return ( 180.0 * asinr(value) / M_PI );
}

float GsMaths::atand ( float value ){
  return ( 180.0 * atanr(value) / M_PI );
}

float GsMaths::atan2d ( float y, float x ){
  return ( 180.0 * atan2r (y,x) / M_PI );
}

float GsMaths::sin2cos ( float sinx, float angle ){
  float epsilon;
  if ( (angle >= -90.0 ) && (angle < 90.0 ) ){
    // right part of the trigonometric circle => cosx >= 0
    epsilon = 1.0;
  }
  else {
    // left part of the trigonometric circle => cosx <= 0
    epsilon = -1.0;
  }

  if ( fabs(sinx) <= 1.0 ){
    return ( epsilon * sqrt(1.0 - (sinx*sinx) ) );
  }
  else {
    return 0.0;
  }
}

float GsMaths::cos2sin ( float cosx, float angle ){
  float epsilon;
  if ( (angle >= 0.0 ) && (angle < 180.0 ) ){
    // top part of the trigonometric circle => sinx >= 0
    epsilon = 1.0;
  }
  else {
    // bottom part of the trigonometric circle => sinx <= 0
    epsilon = -1.0;
  }

  if ( fabs(cosx) <= 1.0 ){
    return ( epsilon * sqrt(1.0 - (cosx*cosx) ) );
  }
  else {
    return 0.0;
  }
}

int GsMaths::closest_integer(const float real_number)
{
    return int(floor(real_number + 0.5));
}

bool GsMaths::are_equal ( float  left, float  right,
		 float  relative_epsilon,
		 float  absolute_epsilon){
  float ref, diff;
  bool undef_left = is_undefined_float(left);
  bool undef_right = is_undefined_float(right);
  bool rval = false;

  if ( (!undef_left) && (!undef_right))
  {
      ref  = 0.5*fabs(left+right);
      diff = fabs(left-right);
      rval = (diff <= absolute_epsilon + ref * relative_epsilon);
  }
  else if ( (undef_left) && (undef_right))
  {
      rval = true;
  }

  return rval;
}

bool GsMaths::equal_0(float  x, float  ref, float  relative_epsilon, float  absolute_epsilon ){
  return ( fabs(x) <= relative_epsilon * ref + absolute_epsilon );
}

bool GsMaths::is_power_of_2 ( int n)
{
    bool rval = false;
    if ( n > 0 )
    {
	int shifted = n;

	rval = true;

	while(rval && (shifted != 1))
	{
	    if ((shifted & 0x1) == 0)
	    {
		shifted = shifted >> 1;
	    }
	    else
	    {
		rval = (shifted == 1);
	    }
	}
    }

    return rval;
}

complex<float> GsMaths::expi(const float phase)
{
    return complex<float>(cosr(phase),sinr(phase));
}
complex<float> GsMaths::expi(const double phase)
{
    return complex<float>(cosr(phase),sinr(phase));
}
#ifdef USE_SUN_MATH

#include <sunmath.h>

#define DEF_TRIGO_METHOD(mname,realmeth,type) \
type GsMaths::mname(const type x)		\
{						\
    return ::realmeth##f(x);				\
}
#else
#define DEF_TRIGO_METHOD(mname,realmeth,type) \
type GsMaths::mname(const type x)		\
{						\
    return ::realmeth(x);				\
}
#endif

#define DEF_TRIGO_METHOD_2(mname,realmeth,type) \
type GsMaths::mname(const type x, const type y)		\
{						\
    return ::realmeth(x,y);				\
}
float GsMaths::degrees2radians ( const float degrees ){
  return ( degrees * M_PI /180.0 );
}

float GsMaths::radians2degrees ( const float radians ){
  return ( radians * 180.0 / M_PI );
}

float GsMaths::set_bounds_0_2pi ( const float radians ){
  float restrict = radians;

  while ( restrict < 0.0 ){
    restrict += TWO_PI;
  }

  while ( restrict > TWO_PI ) {
    restrict -= TWO_PI;
  }
  return restrict;
}


float GsMaths::set_bounds_180 ( const float degrees )
{
  float restrict = degrees;

  // slightly different since bounds are [ -180,180 [ now
  normalize180(restrict);

  return restrict;
}
void GsMaths::normalize_window( float & degrees, const float start, const float end)
{
    const float delta = end - start;

    while (degrees < start)
    {
	degrees += delta;
    }
    while (degrees > end)
    {
	degrees -= delta;
    }

}

void GsMaths::normalize_half_window( float & degrees, const float half_window)
{
    if (fabs(degrees) >= half_window)
    {
	const double window = (half_window + half_window);

	// double is better, less precision errors

	double quotient = (degrees + half_window) / window;
	double remainder = quotient - floor(quotient);

	degrees = remainder * window - half_window;
    }

}

void GsMaths::restrict_angles (const float bearing, const float elevation,
			           float & restrict_bearing,
                                   float & restrict_elevation ){
  float current_bearing = set_bounds_180 (bearing);
  float current_elev    = set_bounds_180 (elevation);

  if ( current_elev > 90.0 ){
    restrict_bearing   = current_bearing + 180.0;
    restrict_bearing   = set_bounds_180 (current_bearing );
    restrict_elevation = 180.0 - current_elev;
  }
  else if ( current_elev < -90.0 ){
    restrict_bearing   = current_bearing + 180.0;
    restrict_bearing   = set_bounds_180 (current_bearing );
    restrict_elevation = -180.0 - current_elev;
  }
  else {
    restrict_bearing   = current_bearing;
    restrict_elevation = current_elev;
  }
}


void GsMaths::restrict_pseudo_angles (const float pseudo_bearing,
					  const float pseudo_elevation,
				      float & restrict_pseudo_bearing,
				      float & restrict_pseudo_elevation ){
  float current_pseudo_bearing = set_bounds_180(pseudo_bearing);
  float current_pseudo_elev    = set_bounds_180(pseudo_elevation);

  if ( current_pseudo_elev > 90.0 ){
    restrict_pseudo_bearing   = - current_pseudo_bearing;
    restrict_pseudo_elevation = current_pseudo_elev - 180.0;
  }
  else if ( current_pseudo_elev < -90.0 ){
    restrict_pseudo_bearing   = -current_pseudo_bearing;
    restrict_pseudo_elevation = current_pseudo_elev + 180.0;
  }
  else {
    restrict_pseudo_bearing   = current_pseudo_bearing;
    restrict_pseudo_elevation = current_pseudo_elev;
  }
}

void GsMaths::calc_angles ( const float pseudo_bearing,
                                const float pseudo_elevation,
			        float & bearing, float & elevation ){
  float current_pseudo_bearing, current_pseudo_elev;
  float current_elev;

  restrict_angles(pseudo_bearing, pseudo_elevation,
		  current_pseudo_bearing, current_pseudo_elev );
  current_elev = GsMaths::asind ( fabs(GsMaths::sind(current_pseudo_bearing))
			 * GsMaths::sind(current_pseudo_elev) );

  if ( is_zero(fabs(current_elev) - 90.0) )
  {
      bearing   = current_pseudo_bearing;
      elevation = current_elev;
  }
  else {
      bearing = GsMaths::atan2d (GsMaths::sind(current_pseudo_bearing) * GsMaths::cosd(current_pseudo_elev),
				 GsMaths::cosd(current_pseudo_bearing));
      elevation = current_elev;
  }
}

void GsMaths::calc_pseudo_angles(const float bearing,
				     const float elevation,
				     float & pseudo_bearing,
				     float &pseudo_elevation){
  float current_bearing, current_elev;
  float current_pseudo_bearing, current_pseudo_elev;

  restrict_angles (bearing, elevation, current_bearing, current_elev);
  current_pseudo_bearing = GsMaths::acosd( GsMaths::cosd(current_bearing) * GsMaths::cosd(current_elev));

  if ( current_bearing < 0.0 ){
    current_pseudo_bearing = - current_pseudo_bearing;
  }

  if ( ( is_zero(current_pseudo_bearing) ) || ( is_zero(fabs(current_pseudo_bearing)-180.0 )))
  {
      pseudo_bearing   = current_pseudo_bearing;
      pseudo_elevation = 0.0;
  }
  else
  {
      current_pseudo_elev = GsMaths::atan2d( GsMaths::sind(current_elev),
					     GsMaths::cosd(current_elev) * fabs(GsMaths::sind(current_bearing)));
      pseudo_bearing   = current_pseudo_bearing;
    pseudo_elevation = current_pseudo_elev;
  }
}

float GsMaths::angular_distance(const float angle, const float origin )
{
  float dist = fabs(angle - origin);

  while ( dist > 180.0 ) {
    dist = 360.0 - dist;
  }

  return dist;
}

// remove the protections within the gs_maths body

#undef cos
#undef sin
#undef acos
#undef asin
#undef tan
#undef atan

DEF_TRIGO_METHOD(acosr,acos,double)
DEF_TRIGO_METHOD(acosr,acos,float)
DEF_TRIGO_METHOD(asinr,asin,double)
DEF_TRIGO_METHOD(asinr,asin,float)
DEF_TRIGO_METHOD(cosr,cos,double)
DEF_TRIGO_METHOD(cosr,cos,float)
DEF_TRIGO_METHOD(sinr,sin,double)
DEF_TRIGO_METHOD(sinr,sin,float)
DEF_TRIGO_METHOD(tanr,tan,double)
DEF_TRIGO_METHOD(tanr,tan,float)
DEF_TRIGO_METHOD(atanr,atan,double)
DEF_TRIGO_METHOD(atanr,atan,float)
DEF_TRIGO_METHOD_2(atan2r,atan2,double)
DEF_TRIGO_METHOD_2(atan2r,atan2,float)

#undef DEF_TRIGO_METHOD
#undef DEF_TRIGO_METHOD_2
