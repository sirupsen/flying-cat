#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
	if(argc != 4)
	{
		printf("Usage: input output offset\nExample: offset foo bar 42\n");
		return 1;
	}
	
	FILE* s = fopen(argv[1], "rb");
	FILE* d = fopen(argv[2], "wb");
	
	int o = atoi(argv[3]);
	if(o < 0)
	{
		printf("Offset must be a positive integer\n");
		return 1;
	}
	if(s == NULL)
	{
		printf("Can't open %s for reading\n", argv[1]);
		return 1;
	}
	if(d == NULL)
	{
		printf("Can't open %s for writing\n", argv[2]);
		return 1;
	}
	
	fseek(s, o, SEEK_SET);
	
	while(1)
	{
		char c = fgetc(s);
		if(c == EOF)
			break;
		fputc(c, d);
	}
	
	printf("Done\n");
}
