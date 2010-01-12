/****************************
* This program is currently *
*        not working.       *
****************************/

#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
	if(argc != 4)
	{
		printf("Usage: destfile sourcefile offset\nExample: over foo bar 42\n");
		return 1;
	}
	
	FILE* d = fopen(argv[1], "rb");
	FILE* s = fopen(argv[2], "rb");
	int o = atoi(argv[3]);
	
	fseek(d, 0, SEEK_END);
	int dlen = ftell(d);
	fseek(d, 0, SEEK_SET);
	
	fseek(s, 0, SEEK_END);
	int slen = ftell(d);
	fseek(s, 0, SEEK_SET);
	
	if(o < 0 || o > dlen)
	{
		printf("offset must be a positive integer not greater than the size of destfile\n");
		return 1;
	}
	
	int buffsize = (dlen >= slen+o) ? dlen : slen+o;
	char* buff = malloc(buffsize);
	fread(buff, dlen, 1, d);
	fclose(d);
	
	char* towr = malloc(slen);
	fread(towr, slen, 1, s);
	fclose(s);
	
	int i;
	for(i = o; i < slen+o; i++)
		buff[i] = *towr++;
	
	FILE* n = fopen(argv[1], "wb");
	fwrite(buff, buffsize, 1, n);
	fclose(n);
	
	free(buff);
	free(towr);
	
	printf("Done.\n");
	return 0;
}
