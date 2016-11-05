#include<stdio.h>

main()
{
printf("DEPTH=16384;\n");
printf("WIDTH = 32;\n");
printf("\n");
printf("ADDRESS_RADIX = DEC;\n");
printf("DATA_RADIX = HEX;\n");
printf("\n");
printf("CONTENT\n");
printf("BEGIN\n");
printf("\n");

char ch = (char)getchar();
int i = 0;
while(ch != EOF)
{
	if(ch != 0x0a)
	{
	if(i % 8 == 0)
	{
		printf("%i : %c", i/8, ch);
	}
	else
	{
		printf("%c", ch);
	}

	if(i % 8 == 7)
	{
		printf(";\n");
	}
	i++;
	}

	ch = (char)getchar();
}

printf("\n");
printf("END;\n");
}
