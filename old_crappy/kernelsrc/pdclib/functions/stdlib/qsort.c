/* $Id: qsort.c 262 2006-11-16 07:34:57Z solar $ */

/* Release $Name$ */

/* qsort( void *, size_t, size_t, int(*)( const void *, const void * ) )

   This file is part of the Public Domain C Library (PDCLib).
   Permission is granted to use, modify, and / or redistribute at will.
*/

#include <stdlib.h>

#ifndef REGTEST

/* This implementation is losely based on Paul Edward's PDPCLIB, but
   uses pure recursion on the larger subarray instead of the iterative
   stack used by the original (and the v0.4 release of PDCLib), as a
   possible stack overflow was suspected.
*/

/* Wrapper for _PDCLIB_memswp protects against multiple argument evaluation. */
static inline void memswp( char * i, char * j, unsigned int size )
{
    _PDCLIB_memswp( i, j, size );
}

/* For small sets, insertion sort is faster than quicksort.
   T is the threshold below which insertion sort will be used.
   Must be 3 or larger.
*/
#define T 7

void qsort( void * base, size_t nmemb, size_t size, int (*compar)( const void *, const void * ) )
{
    char * i;
    char * j;
    size_t thresh     = T * size;
    char * base_      = (char *)base;
    char * limit      = base_ + nmemb * size;

    if ( ( nmemb == 0 ) || ( size == 0 ) || ( base == NULL ) )
    {
        return;
    }

    for ( ;; )
    {
        if ( limit - base_ > thresh ) /* QSort for more than T elements. */
        {
            /* We work from second to last - first will be pivot element. */
            i = base_ + size;
            j = limit - size;
            /* We swap first with middle element, then sort that with second
            and last element so that eventually first element is the median
            of the three - avoiding pathological pivots.
            */
            memswp( ( ( ( (size_t)( limit - base_ ) ) / size ) / 2 ) * size + base_, base_, size );
            if ( compar( i, j ) > 0 ) memswp( i, j, size );
            if ( compar( base_, j ) > 0 ) memswp( base_, j, size );
            if ( compar( i, base_ ) > 0 ) memswp( i, base_, size );
            /* Now we have the median for pivot element, entering main Quicksort. */
            for ( ;; )
            {
                do
                {
                    /* move i right until *i >= pivot */
                    i += size;
                } while ( compar( i, base_ ) < 0 );
                do
                {
                    /* move j left until *j <= pivot */
                    j -= size;
                } while ( compar( j, base_ ) > 0 );
                if ( i > j )
                {
                    /* break loop if pointers crossed */
                    break;
                }
                /* else swap elements, keep scanning */
                memswp( i, j, size );
            }
            /* move pivot into correct place */
            memswp( base_, j, size );
            /* recurse into larger subpartition, iterate on smaller */
            if ( j - base_ > limit - i )
            {
                /* left is larger */
                qsort( base, ( j - base_ ) / size, size, compar );
                base_ = i;
            }
            else
            {
                /* right is larger */
                qsort( i, ( limit - i ) / size, size, compar );
                limit = j;
            }
        }
        else /* insertion sort for less than T elements              */
        {
            for ( j = base_, i = j + size; i < limit; j = i, i += size )
            {
                for ( ; compar( j, j + size ) > 0; j -= size )
                {
                    memswp( j, j + size, size );
                    if ( j == base_ )
                    {
                        break;
                    }
                }
            }
            break;
        }
    }
    return;
}

#endif

#ifdef TEST
#include <_PDCLIB_test.h>
#include <string.h>
#include <limits.h>

int compare( const void * left, const void * right )
{
    return *( (unsigned char *)left ) - *( (unsigned char *)right );
}

int main()
{
    char presort[] = { "shreicnyjqpvozxmbt" };
    char sorted1[] = { "bcehijmnopqrstvxyz" };
    char sorted2[] = { "bticjqnyozpvreshxm" };
    char s[19];
    BEGIN_TESTS;
    strcpy( s, presort );
    qsort( s, 18, 1, compare );
    TESTCASE( strcmp( s, sorted1 ) == 0 );
    strcpy( s, presort );
    qsort( s, 9, 2, compare );
    TESTCASE( strcmp( s, sorted2 ) == 0 );
    strcpy( s, presort );
    qsort( s, 1, 1, compare );
    TESTCASE( strcmp( s, presort ) == 0 );
#if __BSD_VISIBLE
    puts( "qsort.c: Skipping test #4 for BSD as it goes into endless loop here." );
#else
    qsort( s, 100, 0, compare );
    TESTCASE( strcmp( s, presort ) == 0 );
#endif
    return TEST_RESULTS;
}

#endif

