/* $Id: stdio.h 262 2006-11-16 07:34:57Z solar $ */

/* Release $Name$ */

/* Input/output <stdio.h>

   This file is part of the Public Domain C Library (PDCLib).
   Permission is granted to use, modify, and / or redistribute at will.
*/

/* TODO: This is a dummy header to avoid errors when mixing PDCLIB <stdarg.h> */
/* with glibc <stdio.h>.                                                      */

#ifndef _PDCLIB_STDIO_H
#define _PDCLIB_STDIO_H _PDCLIB_STDIO_H

#ifndef _PDCLIB_AUX_H
#define _PDCLIB_AUX_H _PDCLIB_AUX_H
#include <_PDCLIB_aux.h>
#endif

#include <stdarg.h>

#define BUFSIZ 1024

typedef void * FILE;

extern void * stderr;

int printf( const char * _PDCLIB_restrict format, ... );
int fputs( const char * _PDCLIB_restrict s, FILE * _PDCLIB_restrict stream );
int puts( const char * _PDCLIB_restrict s );

// ED: Flying Cat
// Added the vsprintf function from linux-0.1 [GPL]
int vsprintf(char *buf, const char *fmt, va_list vargs);

int sprintf(char *buf, const char *fmt, ...);

#endif
