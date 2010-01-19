#ifndef KMEM_H
#define KMEM_H

#include "panic.h"

#define KERNEL_MEM_START	0x7E00
#define KERNEL_MEM_END		0x7FFF

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

#endif
