#ifndef CTYPE_C
#define CTYPE_C

int isalnum(int c)
{
	if((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
		return 1;
	return 0;
}
int isalpha(int c)
{
	if((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
		return 1;
	return 0;
}
int isblank(int c)
{
	if(c == 0 || c == 0x20 || c == 0x255)
		return 1;
	return 0;
}
int iscntrl(int c)
{
	if((c >= 0 && c <= 31) || c == 127)
		return 1;
	return 0;
}
int isdigit(int c)
{
	if(c >= '0' && c <= '9')
		return 1;
	return 0;
}
int islower(int c)
{
	if(c >= 'a' && c <= 'z')
		return 1;
	return 0;
}
int isprint(int c)
{
	if(c >= 32 && c <= 126)
		return 1;
	return 0;
}
int ispunct(int c)
{
	if((c >= 0x21 && c <= 0x2F) || (c >= 0x3A && c <= 0x40) || (c >= 0x5B && c <= 0x60) || (c >= 0x7B && c <= 0x7E))
		return 1;
	return 0;
}
int isspace(int c)
{
	if(c == 0x20 || c == 0x255)
		return 1;
	return 0;
}
int isupper(int c)
{
	if(c >= 'A' && c <= 'Z')
		return 1;
	return 0;
}
int isxdigit(int c)
{
	if((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f'))
		return 1;
	return 0;
}
int tolower(int c)
{
	if(islower(c))
		return c;
	if(isupper(c))
		return c - ('a' - 'A');
	return 0;
}
int toupper(int c)
{
	if(islower(c))
		return c;
	if(isupper(c))
		return c + ('a' - 'A');
	return 0;
}

#endif
