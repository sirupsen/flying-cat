#ifndef SPRINTF_C
#define SPRINTF_C

#include <stdarg.h>
#include <stdio.h>

int sprintf(char *buf, const char *fmt, ...)
{
	va_list vargs;
	va_start(vargs, fmt);
	
	int ret = vsprintf(buf, fmt, vargs);
	
	va_end(vargs);
	return ret;
}

#endif
