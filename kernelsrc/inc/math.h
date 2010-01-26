#ifndef MATH_H
#define MATH_H

// These are the functions we need to implement to build Lua. No more, no less.

double pow(double base, double exponent);
double floor(double x);

// Implementations
double floor(double x)
{
	// WARNING: naive implementation
	// doesn't account for integer overflow, but it's all we need for now
	// i'll improve it later
	return (double)((int)x);
}

double pow(double base, double exponent)
{
	// WARNING: naive implmentation
	// doesn't account for a non-integer exponent.
	double ret = 1;
	int i;
	for(i = 0; i < exponent; i++)
		ret *= base;
		
	return ret;
}

#endif
