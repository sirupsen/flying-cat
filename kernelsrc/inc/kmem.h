#ifndef KMEM_H
#define KMEM_H

#include "panic.h"
#include "consts.h"

#ifndef _PDCLIB_CONFIG_H
	#define _PDCLIB_CONFIG_H _PDCLIB_CONFIG_H
	#include <_PDCLIB_config.h>
#endif

void* KERNEL_MEM_START 	= (void*) 0x7E00;
void* KERNEL_MEM_END 	= (void*)0x7FFFF;

void* kmem_alloc_ptr = NULL;

void* _PDCLIB_allocpages( int const n )
{
	if(kmem_alloc_ptr == NULL)
		kmem_alloc_ptr = KERNEL_MEM_START;
		
    void* ret = kmem_alloc_ptr;
    kmem_alloc_ptr += ( n * _PDCLIB_PAGESIZE );
    
    if ( kmem_alloc_ptr < KERNEL_MEM_END )
		return ret;
	
	if(n < 10)
	    kpanic("Out of memory in _PDCLIB_allocpages(<10)");
	    
	kpanic("Out of memory in _PDCLIB_allocpages()");
    return (void*)0;
}

#endif
