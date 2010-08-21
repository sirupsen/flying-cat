// =============================================================================
// BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
// Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
//
// The BareMetal OS C library code.
//
// Version 1.0
//
// This allows for a C program to access OS functions available in BareMetal OS
//
// Compile:
// gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -o yourapp.o yourapp.c libBareMetal.c
// - or -
// clang -c -fomit-frame-pointer -o yourapp.o yourapp.c libBareMetal.c
//
// Link:
// ld -T app.ld -o yourapp.app yourapp.o
// =============================================================================


void b_print_string(char *str)
{
	asm volatile ("call 0x00100010" : : "S"(str)); // Make sure source register (RSI) has the string address (str)
}


void b_print_char(char chr)
{
	asm volatile ("call 0x00100018" : : "a"(chr));
}


void b_print_char_hex(char chr)
{
	asm volatile ("call 0x00100020" : : "a"(chr));
}


void b_print_newline(void)
{
	asm volatile ("call 0x00100028");
}


void b_print_string_with_color(char *str, unsigned char clr)
{
	asm volatile ("call 0x001001C8" : : "S"(str), "b"(clr)); // Make sure source register (RSI) has the string address (str)
}


void b_print_char_with_color(char chr, unsigned char clr)
{
	asm volatile ("call 0x001001D0" : : "a"(chr), "b"(clr));

}


unsigned char b_input_get_key(void)
{
	unsigned char chr;
	asm volatile ("call 0x00100030" : "=a" (chr));
	return chr;
}


unsigned char b_input_wait_for_key(void)
{
	unsigned char chr;
	asm volatile ("call 0x00100038" : "=a" (chr));
	return chr;
}


unsigned long b_input_string(unsigned char *str, unsigned long nbr)
{
	unsigned long len;
	asm volatile ("call 0x00100040" : "=c" (len) : "c"(nbr), "D"(str));
	return len;
}


unsigned long b_string_length(unsigned char *str)
{
	unsigned long len;
	asm volatile ("call 0x00100070" : "=c" (len) : "S"(str));
	return len;
}


unsigned long b_string_find_char(unsigned char *str, unsigned char chr)
{
	unsigned long pos;
	asm volatile ("call 0x00100078" : "=a" (pos) : "a"(chr), "S"(str));
	return pos;
}


void b_os_string_copy(unsigned char *dst, unsigned char *src)
{
	asm volatile ("call 0x00100080" : : "S"(src), "D"(dst));
}


void b_int_to_string(unsigned long nbr, unsigned char *str)
{
	asm volatile ("call 0x001000C0" : : "a"(nbr), "D"(str));
}


unsigned long b_string_to_int(unsigned char *str)
{
	unsigned long tlong;
	asm volatile ("call 0x001000E0" : "=a"(tlong) : "S"(str));
	return tlong;
}


void b_delay(unsigned long nbr)
{
	asm volatile ("call 0x00100048" : : "a"(nbr));
}


unsigned long b_get_argc()
{
	unsigned long tlong;
	asm volatile ("call 0x00100138" : "=a"(tlong));
	return tlong;
}


char* b_get_argv(unsigned char nbr)
{
	char* tchar;
	asm volatile ("call 0x00100140" : : "a"(nbr));
	return tchar;
}


unsigned long b_get_timercounter(void)
{
	unsigned long tlong;
	asm volatile ("call 0x00100158" : "=a"(tlong));
	return tlong;
}


void b_debug_dump_mem(void *data, unsigned int size)
{
	asm volatile ("call 0x001000D8" : : "S"(data), "c"(size));
}


void b_serial_send(unsigned char chr)
{
	asm volatile ("call 0x00100120" : : "a"(chr));
}


unsigned char b_serial_recv(void)
{
	unsigned char chr;
	asm volatile ("call 0x00100128" : "=a" (chr));
	return chr;
}


void b_file_read(unsigned char *name, void *mem)
{
	asm volatile ("call 0x00100190" : : "S"(name), "D"(mem));
}


void b_file_write(void *data, unsigned char *name, unsigned int size)
{
	asm volatile ("call 0x00100198" : : "S"(data), "D"(name), "c"(size));
}


void b_file_delete(unsigned char *name)
{
	asm volatile ("call 0x001001A0" : : "S"(name));
}


unsigned long b_smp_enqueue(void *ptr)
{
 	unsigned long tlong;
	asm volatile ("call 0x00100110" : "=a"(tlong) : "a"(ptr));
	return tlong;
}


unsigned long b_smp_dequeue(void)
{
	unsigned long tlong;
        asm volatile ("call 0x00100118" : "=a"(tlong));
	return tlong;
}


void b_smp_run(unsigned long ptr)
{
	asm volatile ("call 0x001001B0" : : "a"(ptr));
}


unsigned long b_smp_queuelen(void)
{
	unsigned long tlong;
	asm volatile ("call 0x00100148" : "=a"(tlong));
	return tlong;
}


void b_smp_wait(void)
{
        asm volatile ("call 0x00100150");
} 


void b_smp_lock(unsigned long ptr)
{
        asm volatile ("call 0x001001B8" : : "a"(ptr));
}


void b_smp_unlock(unsigned long ptr)
{
        asm volatile ("call 0x001001C0" : : "a"(ptr));
}


void b_speaker_tone(unsigned long nbr)
{
        asm volatile ("call 0x00100050" : : "a"(nbr));
}


void b_speaker_off(void)
{
        asm volatile ("call 0x00100058");
}


void b_speaker_beep(void)
{
        asm volatile ("call 0x00100060");
}


// =============================================================================
// EOF
