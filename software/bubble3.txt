//
// Sample program to sort string data with a bubble sort 
//
//  ** https://stackoverflow.com/questions/40186977/sorting-strings-alphabetically-in-c-language
//
// $Id: bubble3.c,v 0.3 2020/05/23 18:47:16 kc4zvw Exp kc4zvw $
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define TRUE 1
#define ELEMENT 50
#define LISTLEN 100

/* function prototypes */
int exit_program(int);
int read_text_file();
int write_text_file(int);
void add_new_entry();
void display_author();
void display_list(int);
void display_title();
void remove_newline(char *, int);
void sort_entries();


/* global variables */
int nameCount = 0;
char Names[ELEMENT][LISTLEN];

/* main program begins here */

int main()
{
	int num = 0;

	display_title();

	while (TRUE) {
		printf("\n");
		printf("Press 1 to see author information.\n");
		printf("Press 2 to enter a new name.\n");
		printf("Press 3 to view list of names.\n");
		printf("Press 4 to alphabatize the list of names.\n");
		printf("Press 5 to read a file for inputting names.\n");
		printf("Press 6 to write a file to save the list of names.\n");
		printf("Press 7 to exit program.\n");
		printf("\n");
		printf("Option? : ");
		scanf("%d", &num);
		printf("\n");

		switch (num) {
			case (1):
				display_author(); break;
			case (2):
				add_new_entry(); break;
			case (3):
				display_list(nameCount); break;
			case (4):
				sort_entries(); break;
			case (5):
				read_text_file(); break;
			case (6):
				write_text_file(nameCount); break;
			case (7):
				exit_program(0); break;
			default:
				printf("Invalid user input!\n"); break;
		}
	}
}


void display_author()
{
	printf("==================================\n");
	printf("\n");
	printf("  Student: David Billsbrough\n");
	printf("  Class: COP-1002\n");
	printf("  Due Date: 05-23-2020\n");
	printf("  Email: student@example.edu\n");
	printf("  Telephone: 407-555-1212\n");
	printf("\n");
	printf("==================================\n");
}	

void display_title()
{
	printf("\n");
	printf("Sample program to sort strings with bubble sort\n");
	printf("No Warranty!  See GPL public license 2\n");
	printf("Mangled by David Billsbrough\n");
	printf("Written in ANSI C -- version C99\n");
	printf("\n");
}


void add_new_entry()
{
	char new_name[ELEMENT];

	printf("Enter the name (no spaces)\n");
	scanf("%s", new_name);
	strcpy(Names[nameCount], new_name);
	nameCount++;
}

void display_list(int entries)
{
	printf("*************************************************\n");
	printf(" Displaying %d entries:\n", entries);
	printf("\n");

	for (int c = 0; c < entries; c++) {
		printf("  %d.\t%s\n", c + 1, Names[c]);
	}

	printf("\n");
	printf("*************************************************\n");
}

int exit_program(int errcode)
{
	printf("Exiting the bubble sort program ...\n\n");

	exit(errcode);
}

int read_text_file()
{
	FILE *fp;
	char *filename = "names.txt";
	char str[ELEMENT];
	int count = nameCount;

	printf("Reading \"%s\" for input ...\n\n", filename);

	if ((fp = fopen(filename, "r")) == NULL) {
		printf("Could not open file: %s.\n", filename);
        printf("Error code opening file: %d\n", errno);
        printf("Error opening file: %s\n", strerror(errno));
		return 1;
	}

	while (! feof(fp)) {
		fgets(str, ELEMENT, fp);
		remove_newline(str, strlen(str) - 1);
		strcpy(Names[count], str);
		printf("%s\n", str);
		count++;
	}

	fclose(fp);
	nameCount = count - 1;

	return 0;
}

void remove_newline(char *str, int i)
{
	int len = strlen(str);

	for ( ; i < len - 1; i++) {
		str[i] = str[i + 1];
	}

	str[i] = '\0';
}

int write_text_file(int entries)
{
	FILE *fp;
	char *filename = "namesout.txt";

	printf("Writing \"%s\" for output ...\n\n", filename);

	if ((fp = fopen(filename, "w")) == NULL) {
		printf("Could not open file: %s.\n", filename);
        printf("Error code opening file: %d\n", errno);
        printf("Error opening file: %s\n", strerror(errno));
		return 2;
	}

	for (int c = 0; c < entries; c++) {
		fprintf(fp, "%s\n", Names[c]);
	}

	fclose(fp);

	return 0;
}

void sort_entries()
{
	char temp[ELEMENT] = "";

	printf("\n");
	printf("Sorting the elements of the list.\n");
	printf("\n");

	for (int ctrLv1 = 0; ctrLv1 < nameCount - 1; ctrLv1++) {

		for (int ctrLv2 = ctrLv1 + 1; ctrLv2 < nameCount; ctrLv2++) {

			if (strcmp(Names[ctrLv1], Names[ctrLv2]) > 0) {
	
				strcpy(temp, Names[ctrLv1]);
				strcpy(Names[ctrLv1], Names[ctrLv2]);
				strcpy(Names[ctrLv2], temp);
			}
		}
	}
}


/***** End of program *****/
