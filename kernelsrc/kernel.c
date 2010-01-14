#include "inc/consts.h"
#include "inc/multiboot.h"
#include "inc/panic.h"
#include "inc/kmem.h"
 
void println(char* s, short line)
{
	char* vram = (char*)(0xb8000 + (80*line*2));
 
	while(*s)
	{
		*vram++ = *s++;
		*vram++ = 0x07; // light grey on black
	}
}

void kmain(multiboot_info_t* mbi, unsigned int magic)
{
	// clear the screen
	char* vram = (char*)(0xb8000+(80*25*2)-1);
	while (vram >= (char*)0xb8000)
		*vram-- = 0;
 
	// GRUB should have passed us 0x2BADB002 as well as the Multiboot info struct
	// if it didn't, die.
	if (magic != 0x2BADB002)
		panic(OS_NAME " was not booted correctly.");
 
	// we booted successfully, so say hello world and dump some info
	println("Hello, World!", 0);
	println("This is " OS_NAME " (c) Turbsen 2010", 1);
	println((char*)mbi->boot_loader_name, 3);
	println((char*)mbi->cmdline, 4);
 
	for(;;); // hang
}
