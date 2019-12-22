
#ifndef  GSTIME_INCLUDED
#define  GSTIME_INCLUDED


#include "MyString.hpp"

/**
 * time manipulation & utility functions
 * @see MicrosecsClock for accurate timers
 */

class GsTime
{
 public:

  enum EnumDateCompare { DATE_ERROR, FIRST_OLDER, FIRST_NEWER, EQUAL };

  /**
   * returns the number of seconds since
   * 1970, 1st of January 00:00
   */

  static long get_seconds_since_1970();

  /**
  * returns the date in the following format
  * DD/MM/YYYY
  * @param  date separator to use
  */

  static MyString get_current_date
    (
     char separator='/'
     );

  /**
  * converts the date in seconds since 1970
  * The date must be of format DD/MM/YYYY
  * @param  date string to convert
  */

  static long date_to_seconds
    (
     const MyString &date_string
     );
  /**
  * converts the date in seconds since 1970
  * The date must be of format DD/MM/YYYY
  * @param  date_seconds date to convert
  * @param  separator char to use
  */

  static MyString seconds_to_date
    (
     long date_seconds,
     char separator='/'
     );

  /**
  * compares 2 dates
  * @param  first date to compare
  * @param  second date to compare
  */

  static EnumDateCompare compare_dates
    (
     const MyString &date1,
     const MyString &date2
);

  /**
  * check if the format of the date
  * is valid
  */

  static bool date_format_valid
  (
	const MyString &date_string
	);

/**
* waits some seconds
*/
  static void wait(int millis);

 protected:

 private:
  /**
  * Class constructor
  */
  GsTime(
  );

/**
* Class destructor
*/
  ~GsTime(
  );

};

#endif

