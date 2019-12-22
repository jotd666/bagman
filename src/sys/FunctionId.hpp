/*---------------------------------------------------------------------------*
 *         (C) 2004  -  JFF Software         *
 *---------------------------------------------------------------------------*/


#ifndef FUNCTIONID_H
#define FUNCTIONID_H

/*------------*
 * Used units *
 *------------*/

#include "MyString.hpp"

/*-----------------*
 * Types & objects *
 *-----------------*/


/**
 *
 * @author  Jean-Francois FABRE
 *
 */

class FunctionId
{
  public:
    FunctionId(const MyString &class_name,const char *method_name) :
    class_name(class_name),method_name(method_name)
    {}
    
    MyString class_name;
    const char *method_name;

    bool operator==(const FunctionId &other) const;

    bool operator<(const FunctionId &other) const;
};


#endif /* -- End of unit, add nothing after this #endif -- */
