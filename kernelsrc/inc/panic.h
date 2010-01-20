#ifndef PANIC_H
#define PANIC_H

void kpanic(char* msg)
{
	char* vram = (char*)0xb8000;

	char* kp = "Kernel Panic";
	while(*vram++ = *kp++)
		*vram++ = 0x4F;
	
	vram = (char*)(0xb8000 + 80*2);
	
	// loop through err string until reaching 0x00 (null terminator)
	while(*vram++ = *msg++)
		*vram++ = 0x4F; // white on dark red

	asm("cli"); // cancel interrupts
	asm("hlt"); // halt cpu
}

#endif
