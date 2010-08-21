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
#include "inc/include_lua.h"

#define K_LFUNC(x) int x (lua_State* L)

K_LFUNC(mset)
{
	char* a = (char*)lua_tointeger(L, -1);
	int c = lua_tointeger(L, -2);
	if(c >= 0 && c <= 255)
		*a = (char)c;
}

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
	
	lua_State* L = (lua_State*)luaL_newstate();
	
	luaL_openlibs(L);
	
	k_print("Passed");
	
	for(;;); // hang
}


