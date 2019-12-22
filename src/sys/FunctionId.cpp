#include "FunctionId.hpp"

#include <string.h>
bool FunctionId::operator==(const FunctionId &other) const
    {
	return ((strcmp(method_name,other.method_name) == 0) &&
		(class_name == other.class_name));
    }

    bool FunctionId::operator<(const FunctionId &other) const
    {
	const int cmp1 = strcmp(class_name.c_str(),other.class_name.c_str());

	bool rval = (cmp1 < 0);

	if (!rval)
	{
	    if (cmp1 == 0)
	    {
		// same class, test method names
		
		rval = (strcmp(method_name,other.method_name) < 0);
	    }
	}

	return rval;
    }
