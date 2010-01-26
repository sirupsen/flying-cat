#ifndef SETJMP_H
#define SETJMP_H

typedef struct {
  unsigned long eax;
  unsigned long ebx;
  unsigned long ecx;
  unsigned long edx;
  unsigned long esi;
  unsigned long edi;
  unsigned long ebp;
  unsigned long esp;
  unsigned long eip;
} jmp_buf[1];

extern int setjmp(jmp_buf);
extern void longjmp(jmp_buf, int);

#endif
