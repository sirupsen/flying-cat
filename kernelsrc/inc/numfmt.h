#ifndef NUMFMT_H
#define NUMFMT_H

#include <stdlib.h>
#include "consts.h"

char hexchars[] = "0123456789ABCDEF";

char* num2hex(uint n)
{
	char* str = malloc(11); // 2 bytes for '0x', 8 bytes for the unsigned 32-bit value, 1 byte for the null terminator
	strcpy(str, "0x00000000");
	
	ushort i = 9;
	while(n > 0)
	{
		str[i] = hexchars[n % 16];
		n /= 16;
	}
	
	return str;
}

#endif
