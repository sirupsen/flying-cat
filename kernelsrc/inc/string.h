#ifndef STRING_H
#define STRING_H

int strlen(char* str)
{
	unsigned int length;

	// For each character until \0, plus length with one
	for (length = 0; *str != '\0'; str++)
		length++;
		
	return length;
}

char *strcpy(char *destination, char *source) 
{
	unsigned int i;

	/*
	 * Loop over source until end (\0), and put everything
	 * into destination.
	 */
	for (i = 0; source[i] != '\0'; i++)
		destination[i] = source[i];

	// Append \0 to destination 
	destination[i] = '\0';

	// Return the destination
	return destination;
}

char *strcat (char* a, char* b)
{
	unsigned int alen = strlen(a);
	
	char* s = malloc(alen + strlen(b) + 1);
	strcpy(s, a);
	strcpy(s+alen, b);

	// Then return the destination
	return s;
}

#endif
