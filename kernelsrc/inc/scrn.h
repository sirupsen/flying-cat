#ifndef SCRN_H
#define SCRN_H

void k_clear_screen() 
{
	char* vram = (char*)(0xb8000+(80*25*2) - 1);
	while (vram >= (char*)0xb8000)
		*vram-- = 0;
}

void k_print(char *message) 
{
	// Line number by default is 0
	static int line = 0;
	// @todo I don't want to know what happens if the lins is > 24, make scroll stuff
	char* vram = (char*) (0xb8000 + (80 * line * 2));

	while(*message) {
		// If newline
		if (*message == '\n') {
			line++;
			*message++;
			// Not newline
		} else {
			*vram++ = *message++;
			*vram++ = 0x07;
		}
	}

	line++;
}

#endif
