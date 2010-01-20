#include "inc/consts.h"
#include "inc/multiboot.h"
#include "inc/scrn.h"
#include "inc/panic.h"
#include "inc/kmem.h"

// Lua
#include "lua/src/lua.h"

// PDCLib
#include <stdlib.h>
#include <string.h>

void kmain(multiboot_info_t* mbi, unsigned int magic)
{
	k_clear_screen();

	if (magic != 0x2BADB002)
		panic(OS_NAME " was not booted correctly.");

	k_print("Hello, World!\n");
	k_print("This is " OS_NAME " (c) Turbsen 2010\n\n");

	k_print((char*)mbi->boot_loader_name);
	k_print("\n");
	k_print((char*)mbi->cmdline);
	k_print("\n\n");

	k_print("Trying malloc()...\n");
	void* m = malloc(100);
	if(m == (void*)1)
	{
		k_print("bingo\n");
	}
	else
	{
		k_print("nope\n");
	}

	for(;;); // hang
}
