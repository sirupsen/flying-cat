#include "inc/consts.h"
#include "inc/multiboot.h"

void println(char* s, short line)
{
	char* vram = (char*)(0xb8000 + (80*line*2));
	
	while(*s)
	{
		*vram++ = *s++;
		*vram++ = 0x07; // light grey on black
	}
}

void clearScreen() {
	char* vram = (char*)(0xb8000+(80*25*2)-1);
	while (vram >= 0xb8000)
		*vram-- = 0;
	vram++;
}

void kmain(multiboot_info_t* mbi, unsigned int magic)
{
	// clear the screen
  clearScreen();
	
	// GRUB should have passed us 0x2BADB002 as well as the Multiboot info struct
	// if it didn't, die.
	if (magic != 0x2BADB002)
	{
		// setup error string
		char erra[] = OS_NAME " was not booted correctly.";
		char* err = erra;
		
		// loop through err string until reaching 0x00 (null terminator)
		while(*err)
		{
			*vram++ = *err++;
			*vram++ = 0x4F; // white on dark red
		}
		
		asm("hlt"); // halt cpu
	}
	
	// we booted successfully, so say hello world and dump some info
	println("Hello, World!", 0);
	println("This is project Flying Cat (c) Turbsen 2010", 1);
	println((char*)mbi->boot_loader_name, 3);
	println((char*)mbi->cmdline, 4);
	
	for(;;); // hang
}
