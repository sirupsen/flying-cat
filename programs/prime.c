// Prime Test Program (v1.0, July 6 2010)
// Written by Ian Seyler
//
// This program checks all numbers between 0 and 'maxn' and determines if they are prime.
// On exit the program will display the execution time and how many prime numbers were found.
// Useful for testing runtime performance between Linux and BareMetal OS.
//
// BareMetal compile
// gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -o prime.o prime.c -DBAREMETAL
// gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -o libBareMetal.o libBareMetal.c
// ld -T app.ld -o prime.app prime.o libBareMetal.o

// Linux compile
// gcc -m64 -fomit-frame-pointer -o prime prime.c -DLINUX

// maxn = 300000  primes = 25997
// maxn = 400000  primes = 33860
// maxn = 1000000 primes = 78498

#ifdef LINUX
#include <stdio.h>
#include <time.h>
#endif

#ifdef BAREMETAL
#include "libBareMetal.h"
#endif

int main()
{
	register unsigned long i, j, maxn=400000, primes=0;

#ifdef BAREMETAL
	unsigned char tstring[25];
	unsigned long start, finish;
	start = b_get_timercounter();
#endif

#ifdef LINUX
	time_t start, finish;
	time(&start);
#endif

	for(i=0; i<=maxn; i++)
	{
		for(j=2; j<=i-1; j++)
		{
			if(i%j==0) break; //Number is divisble by some other number. So break out
		}
		if(i==j)
		{
			primes = primes + 1;
		}
	} //Continue loop up to max number

#ifdef LINUX
	time(&finish);
	printf("%u in %.0lf seconds\n", primes, difftime(finish, start));
#endif

#ifdef BAREMETAL
	finish = b_get_timercounter();
	b_int_to_string(primes, tstring);
	b_print_string(tstring);
	b_print_string(" in ");
	finish = (finish - start) / 8;
	b_int_to_string(finish, tstring);
	b_print_string(tstring);
	b_print_string(" seconds\n");
#endif

	return 0;
}

// EOF
