void panic(char* msg)
{
	char* vram = (char*)0xb8000;

	char* kp = "KERNEL PANIC";
	while(*vram++ = *kp++)
		*vram++ = 0x4F;
	
	vram = (char*)(0xb8000 + 80*2*2);
	
	// loop through err string until reaching 0x00 (null terminator)
	while(*vram++ = *kp++)
		*vram++ = 0x4F; // white on dark red

	asm("hlt"); // halt cpu
}
