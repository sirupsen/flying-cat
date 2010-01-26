#include "inc/consts.h"
#include "inc/multiboot.h"
#include "inc/scrn.h"
#include "inc/panic.h"
#include "inc/kmem.h"
#include "inc/numfmt.h"

// PDCLib
#include <stdlib.h>
#include <string.h>

// Lua
#include <ldebug.h>
#include <ldebug.c>

#include <luaconf.h>

#include <lua.h>

#include <lapi.h>
#include <lapi.c>

#include <lauxlib.h>
#include <lauxlib.c>

#include <lbaselib.c>

#include <lcode.h>
#include <lcode.c>

#include <ldo.h>
#include <ldo.c>

#include <ldump.c>

#include <lfunc.h>
#include <lfunc.c>

#include <lgc.h>
#include <lgc.c>

#include <linit.c>

#include <llex.h>
#include <llex.c>

#include <llimits.h>

//#include <lmathlib.c>

#include <lmem.h>
#include <lmem.c>

#include <loadlib.c>

#include <lobject.h>
#include <lobject.c>

#include <lopcodes.h>
#include <lopcodes.c>

#include <lparser.h>
#include <lparser.c>

#include <lstate.h>
#include <lstate.c>

#include <lstring.h>
#include <lstring.c>

#include <lstrlib.c>

#include <ltable.h>
#include <ltable.c>

#include <ltablib.c>

#include <ltm.h>
#include <ltm.c>

#include <lualib.h>

#include <lundump.h>
#include <lundump.c>

#include <lvm.h>
#include <lvm.c>

#include <lzio.h>
#include <lzio.c>

void kmain(multiboot_info_t* mbi, unsigned int magic)
{
	k_clear_screen();

	if (magic != 0x2BADB002)
		kpanic(OS_NAME " was not booted correctly.");

	k_print("Hello, World!\n");
	k_print("This is " OS_NAME " (c) Turbsen 2010\n\n");

	k_print((char*)mbi->boot_loader_name);
	k_print("\n");
	k_print((char*)mbi->cmdline);
	k_print("\n\n");

	k_print("Trying malloc()...\n");
	void* m = malloc(100);
	if(m == NULL)
	{
		k_print("malloc failed\n");
	}
	else
	{
		char* addr = (char*)num2hex((uint)m);
		k_print(addr);
		k_print("\n");
		free(addr);
		free(m);
	}
	
	lua_State* L = (lua_State*)lua_open();
	
	for(;;); // hang
}


