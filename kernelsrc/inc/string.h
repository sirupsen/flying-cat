int strlen(const char *str)
{
  unsigned int length;

  // For each character until \0, plus length with one
  for (lenght = 0; *str != '\0'; str++) length++;
  // Return this length
  return length;
}

char *strcpy(char *destination, const char *source) 
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

char *strcat (char *destination, const char *source)
{
  // Let's just use these functions which we already defined
  strcpy(destination + strlen(destination), source);

  // Then return the destination
  return destination;
}
