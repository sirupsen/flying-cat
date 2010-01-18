#ifndef SYSCALL_H
#define SYSCALL_H

// Here's our minimal syscall functions. Newlib (a C std lib implementation) relies on these, but we don't want these to be implemented on the kernel level.

int close(int file)
{
	return -1;
}

char *_empty_enviro[1] = {0};
char *environ = _empty_enviro;

//extern int errno;
int execve(char* name, char** argv, char** env)
{
	// @todo
	return -1;
}

int fork()
{
	// @todo
	return -1;
}

int fstat(int file, void* st)
{
	// @todo
	return 0;
}

int getpid()
{
	return 1;
}

int isatty(int file)
{
	return 1;
}

int kill(int pid, int sig)
{
	// @todo
	return -1;
}

int link(char* old, char* new)
{
	// @todo;
	return -1;
}

int lseek(int file, int ptr, int dir)
{
	return 0;
}

int open(const char* name, int flags, int mode)
{
	return -1;
}

int read(int file, char* ptr, int len)
{
	return 0;
}

void sbrk(int incr)
{
	// @todo
}

int stat(const char* file, void* st)
{
	// @todo
	return 0;
}

void times(void* buf)
{
	// @todo
}

int unlink(char* name)
{
	// @todo
	return -1;
}

int wait(int* status)
{
	// @todo
	return -1;
}

int write(int file, char* ptr, int len)
{
	return 0;
}

#endif
