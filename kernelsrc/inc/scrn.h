#ifndef SCRN_H
#define SCRN_H

#include <string.h>

void k_clear_screen() 
{
	char* vram = (char*)(0xb8000+(80*25*2) - 1);
	while (vram >= (char*)0xb8000)
		*vram-- = 0;
}

void k_printc(char* s, char color) 
{
	static char col = 0; // we only need a byte to represent the col
	static char row = 0; // ditto

	while(*s)
	{
		// If newline
		if (*s != '\n')
		{
			// setup a short pointer (short = 2 bytes) pointing to the char+attr
			// bitshift the color to the higher byte of the short and add the character.
			// (reverse order than normal since x86 uses the little endian format)
			*(short*)(0xb8000 + (row * 80 + col++) * 2) = *s + (color<<8);
		}
			
		if (*s == '\n' || col == 80)
		{
			row++;
			col = 0;
		}
		
		if(row == 25)
		{
			memmove((void*)0xb8000, (void*)0xb8000+160, 80*2*25);
			memset((void*)0xb8000+(80*2*24), 0, 80*2);
			row = 24;
		}
		
		s++;
	}
}

void k_print(char* s)
{
	k_printc(s, 0x07);
}

#endif
