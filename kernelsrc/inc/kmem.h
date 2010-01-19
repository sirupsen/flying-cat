#ifndef KMEM_H
	#define KMEM_H

	#include "panic.h"
	#include <stdint.h>
	#include <stddef.h>

	#define KERNEL_MEM_START	0x7E00
	#define KERNEL_MEM_END		0x7FFF

	#ifndef _PDCLIB_CONFIG_H
		#define _PDCLIB_CONFIG_H _PDCLIB_CONFIG_H
	#include <_PDCLIB_config.h>
#endif

void* kmem_alloc_ptr = (void*)KERNEL_MEM_START;

void* kmalloc(int size)
{
	if(kmem_alloc_ptr + size > (void*)KERNEL_MEM_END)
		panic("Out of kernel memory");
	
	void* mem = kmem_alloc_ptr;
	
	kmem_alloc_ptr += size;
	
	return mem;
}

void kfree(void* ptr)
{
	return; // very simple memory manager, we don't bother about freeing
}

// allocpages - pdclib


int brk( void * );
void * sbrk( intptr_t );

static void * membreak = NULL;

void * _PDCLIB_allocpages( int const n )
{
    if ( membreak == NULL )
    {
        /* first call, make sure end-of-heap is page-aligned */
        intptr_t unaligned = 0;
        membreak = sbrk( 0 );
        unaligned = _PDCLIB_PAGESIZE - (intptr_t)membreak % _PDCLIB_PAGESIZE;
        if ( unaligned < _PDCLIB_PAGESIZE )
        {
            /* end-of-heap not page-aligned - adjust */
            if ( sbrk( unaligned ) != membreak )
            {
                /* error */
                return NULL;
            }
            membreak = (char *)membreak + unaligned;
        }
    }
    /* increasing or decreasing heap - standard operation */
    void * oldbreak = membreak;
    membreak = (void *)( (char *)membreak + ( n * _PDCLIB_PAGESIZE ) );
    if ( brk( membreak ) == 0 )
    {
        /* successful */
        return oldbreak;
    }
    else
    {
        /* out of memory */
        membreak = oldbreak;
        return NULL;
    }
}

#endif
