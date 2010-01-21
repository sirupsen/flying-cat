#ifndef SCRN_H
#define SCRN_H

#include <string.h>

void k_clear_screen() 
{
	char* vram = (char*)(0xb8000+(80*25*2) - 1);
	while (vram >= (char*)0xb8000)
		*vram-- = 0;
}

char scrn_col = 0; // we only need a byte to represent the col
char scrn_row = 0; // ditto

void k_putc(char c, char color)
{
	// If newline
	if (c != '\n')
	{
		// setup a short pointer (short = 2 bytes) pointing to the char+attr
		// bitshift the color to the higher byte of the short and add the character.
		// (reverse order than normal since x86 uses the little endian format)
		*(short*)(0xb8000 + (scrn_row * 80 + scrn_col++) * 2) = c + (color<<8);
	}
		
	if (c == '\n' || scrn_col == 80)
	{
		scrn_row++;
		scrn_col = 0;
	}
	
	if(scrn_row == 25)
	{
		memmove((void*)0xb8000, (void*)0xb8000+160, 80*2*25);
		memset((void*)0xb8000+(80*2*24), 0, 80*2);
		scrn_row = 24;
	}
}
void k_put(char c)
{
	k_putc(c, 0x07);
}
void k_printc(char* s, char color) 
{
	while(*s)
		k_putc(*s++, color);
}

void k_print(char* s)
{
	k_printc(s, 0x07);
}

#endif
