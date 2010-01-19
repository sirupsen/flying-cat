#ifndef KMEM_H
#define KMEM_H

#include "panic.h"

#ifndef _PDCLIB_CONFIG_H
	#define _PDCLIB_CONFIG_H _PDCLIB_CONFIG_H
	#include <_PDCLIB_config.h>
#endif

#define KERNEL_MEM_START	0x7E00
#define KERNEL_MEM_END		0x7FFF

void* kmem_alloc_ptr = (void*)KERNEL_MEM_START;

void* _PDCLIB_allocpages( int const n )
{
    void* ret = kmem_alloc_ptr;
    kmem_alloc_ptr += ( n * _PDCLIB_PAGESIZE );
    if ( kmem_alloc_ptr < (void*)KERNEL_MEM_END )
    {
        /* successful */
        return ret;
    }
    else
    {
        /* out of memory */
        //panic("Out of memory in _PDCLIB_allocpages()");
        return (void*)0;
    }
}

#endif
