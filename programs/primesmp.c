// Prime SMP Test Program (v1.0, July 6 2010)
// Written by Ian Seyler
//
// This program checks all odd numbers between 3 and 'maxn' and determines if they are prime.
// On exit the program will display the execution time and how many prime numbers were found.
// Useful for testing system performance between different computers running BareMetal OS.
//
// BareMetal compile using GCC (Tested with 4.5.0)
// gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -finline-functions -o primesmp.o primesmp.c
// gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -finline-functions -o libBareMetal.o libBareMetal.c
// ld -T app.ld -o primesmp.app primesmp.o libBareMetal.o

// maxn = 300000  primes = 25997
// maxn = 400000  primes = 33860
// maxn = 1000000 primes = 78498


#include "libBareMetal.h"

void prime_process();

// primes is set to 1 since we don't calculate for '2' as it is a known prime number
unsigned long maxn=400000, primes=1, local=0, lock=0, process_stage=0, processes=8;
unsigned char tstring[25];

int main()
{
	unsigned long start, finish, k;
	
	process_stage = processes;

	start = b_get_timercounter();		// Grab the starting time

// Spawn the worker processes
	for (k=0; k<processes; k++)
	{
		b_smp_enqueue(&prime_process);
	}

// Attempt to run a process on this CPU Core
	while (b_smp_queuelen() != 0)		// Check the length of the queue. If greater than 0 then try to run a queued job.
	{
		local = b_smp_dequeue();	// Grab a job from the queue. b_smp_dequeue returns the memory address of the code
		if (local != 0)			// If it was set to 0 then the queue was empty
			b_smp_run(local);	// Run the code
	}

// No more jobs in the queue
	b_smp_wait();				// Wait for all CPU cores to finish

	finish = b_get_timercounter();		// Grab the finish time

// Print the results
	b_int_to_string(primes, tstring);	// Print the amount of primes for verification
	b_print_string(tstring);
	b_print_string(" in ");
	finish = (finish - start) / 8;
	b_int_to_string(finish, tstring);
	b_print_string(tstring);
	b_print_string(" seconds\n");

	return 0;
}


// prime_process() only works on odd numbers.
// The only even prime number is 2. All other even numbers can be divided by 2.
// 1 process	1: 3 5 7 ...
// 2 processes	1: 3 7 11 ...	2: 5 9 13 ...
// 3 processes	1: 3 9 15 ...	2: 5 11 17 ...	3: 7 13 19 ...
// 4 processes	1: 3 11 19 ...	2: 5 13 21 ...	3: 7 15 23 ...	4: 9 17 25...
// And so on.

void prime_process()
{
	register unsigned long h, i, j, tprimes=0;

	// Lock process_stage, copy it to local var, subtract 1 from process_stage, unlock it.
	b_smp_lock(lock);
	i = (process_stage * 2) + 1;
	process_stage--;
	b_smp_unlock(lock);

	h = processes * 2;

	// Process
	for(; i<=maxn; i+=h)
	{
		for(j=2; j<=i-1; j++)
		{
			if(i%j==0) break; // Number is divisble by some other number. So break out
		}
		if(i==j)
		{
			tprimes = tprimes + 1;
		}
	} // Continue loop up to max number

	// Add tprimes to primes.
	b_smp_lock(lock);
	primes = primes + tprimes;
	b_smp_unlock(lock);
}

// EOF
