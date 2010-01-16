#include "inc/consts.h"
#include "inc/multiboot.h"
#include "inc/scrn.h"
#include "inc/string.h"
 
void kmain(multiboot_info_t* mbi, unsigned int magic)
{
  k_clear_screen();
 
	// GRUB should have passed us 0x2BADB002 as well as the Multiboot info struct
	// if it didn't, die.
	if (magic != 0x2BADB002)
	{
		// setup error string
		char erra[] = OS_NAME " was not booted correctly.";
		char* err = erra;
    char* vram = (char*)0xb8000;
 
		// loop through err string until reaching 0x00 (null terminator)
		while(*err)
		{
			*vram++ = *err++;
			*vram++ = 0x4F; // white on dark red
		}
 
		asm("hlt"); // halt cpu
	}

  k_print("Hello, World!");
  k_print("This is " OS_NAME " (c) Turbsen 2010\n");

	k_print((char*)mbi->boot_loader_name);
	k_print((char*)mbi->cmdline);
 
	for(;;); // hang
}
