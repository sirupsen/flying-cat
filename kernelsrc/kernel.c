#include "inc/consts.h"
#include "inc/multiboot.h"
#include "inc/scrn.h"
#include "inc/string.h"
#include "inc/panic.h"
#include "inc/kmem.h"

void kmain(multiboot_info_t* mbi, unsigned int magic)
{
	k_clear_screen();

	if (magic != 0x2BADB002)
		panic(OS_NAME " was not booted correctly.");

	k_print("Hello, World!");
	k_print("This is " OS_NAME " (c) Turbsen 2010\n");

	k_print((char*)mbi->boot_loader_name);
	k_print((char*)mbi->cmdline);

	for(;;); // hang
}
