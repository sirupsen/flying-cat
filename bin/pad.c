#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
	if(argc != 4)
	{
		printf("Usage: outfile padchar totalbytes\nExample: pad foobar 0 1024\n");
		return 1;
	}
	
	FILE* f = fopen(argv[1], "wb");
	if(f == NULL)
	{
		printf("Can't open %s for writing", argv[1]);
		return 1;
	}
	
	int n = atoi(argv[2]);
	if(n < 0 || n > 255)
	{
		printf("padchar must be between 0 and 255\n");
		return 1;
	}
	
	int t = atoi(argv[3]);
	if(t < 0)
	{
		printf("totalbytes must be a positive integer\n");
		return 1;
	}
	
	int i;
	for(i = 0; i < t; i++)
		fputc((char)n, f);
		
	printf("Done\n");
	fclose(f);
	
	return 0;
}
