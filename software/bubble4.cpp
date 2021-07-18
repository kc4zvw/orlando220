/****************************************************************************************************
 ****************************************************************************************************
 ***
 ***    Author: David Billsbrough <kc4zvw@earthlink.net>
 ***   Created: Thursday, May 20, 2021 at 08:54:57 AM (EDT)
 ***   License: GNU General Public License -- version 2
 ***   Version: $Revision: 0.23 $
 ***  Warranty: None
 ***
 ***   Purpose: Sample program to sort string data with a bubble sort
 ***
 ***  - https://stackoverflow.com/questions/40186977/sorting-strings-alphabetically-in-c-language
 ***
 ***   $Id: bubble4.cpp,v 0.23 2021/05/21 01:36:53 kc4zvw Exp kc4zvw $
 ***
 *********
 *********/

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>

using namespace std;

#define TRUE 1
#define ELEMENT 50
#define LISTLEN 100
#define STRLEN 128

/* global variables */
int nameCount = 0;

struct student_t {
	char Name[ELEMENT];
	int Age;
};

struct student_t Student[LISTLEN];

/* function prototypes */
int exit_program(int);
int mainDisplay();
int readTextFile();
int writeTextFile(int);
void addNewEntry();
void displayAuthor();
void displayList(int);
void displayTitle();
void removeNewline(char *, int);
void sortEntries();
void swapElements(struct student_t *p1, struct student_t *p2);


/* main program begins here */

int main(void)
{
	int ask = 0;

	displayTitle();

	while (true) {
		cout << endl;
		cout << "Press 1 to see author information." << endl;
		cout << "Press 2 to enter a new name." << endl;
		cout << "Press 3 to view list of names." << endl;
		cout << "Press 4 to alphabatize the list of names." << endl;
		cout << "Press 5 to read a file for inputting names." << endl;
		cout << "Press 6 to write a file to save the list of names." << endl;
		cout << "Press 7 to run sample routines in program." << endl;
		cout << "Press 8 to exit program." << endl;
		cout << endl;
		cout << "Option? : ";
		cin >> ask;
		cout << endl;

		switch (ask) {
			case (1):
				displayAuthor(); break;
			case (2):
				addNewEntry(); break;
			case (3):
				displayList(nameCount); break;
			case (4):
				sortEntries(); break;
			case (5):
				readTextFile(); break;
			case (6):
				writeTextFile(nameCount); break;
			case (7):
				mainDisplay(); break;
			case (8):
				exit_program(0); break;
			default:
				cout << "Invalid user input!" << endl; break;
		}
	}
}


void displayAuthor()
{
	cout << "  =========================================" << endl;
	cout << "  |                                       |" << endl;
	cout << "  |  Student: David Billsbrough           |" << endl;
	cout << "  |  Class: COP-1002                      |" << endl;
	cout << "  |  Due Date: 05-20-2021                 |" << endl;
	cout << "  |  Email: student@example.edu           |" << endl;
	cout << "  |  Telephone: 407-555-1212              |" << endl;
	cout << "  |                                       |" << endl;
	cout << "  =========================================" << endl;
}

void displayTitle()
{
	cout << endl;
	cout << "Sample program to sort strings with bubble sort" << endl;
	cout << "No Warranty!  See GPL public license 2" << endl;
	cout << "Mangled by David Billsbrough" << endl;
	cout << "Written in ANSI C++  (version C11)" << endl;
	cout << endl;
}

void addNewEntry()
{
	int myage;
	string str;
	int n = nameCount;

	cout << "Enter the student name: ";
	cin >> str;
	stringstream(str) >> Student[n].Name;
	cout << "Enter student age: ";
	cin >> myage;
	Student[n].Age = myage;
	nameCount++;
}

int mainDisplay()
{
	string animals[4] = {"Elephant", "Lion", "Deer", "Tiger"}; // The string type array;

	for (int i = 0; i < 4; i++)
		cout << animals[i] << endl;
	
	return 0;
}

void displayList(int entries)
{
	cout << "*************************************************" << endl;
	cout << " Displaying " << entries << " entries" << endl;
	cout << endl;

	for (int c = 0; c < nameCount; c++) {
		cout << Student[c].Name << " is " << Student[c].Age << endl;
	}

	cout << endl;
	cout << "*************************************************" << endl;
}

int exit_program(int errcode)
{
	cout << "Exiting the bubble sort program ..." << endl << endl;

	exit(errcode);
}

int readTextFile()
{
	char str[ELEMENT];
	int count = nameCount;
	string filename = "names.txt";

	// open a file in read mode.
	ifstream infile; 
	infile.open(filename);

	cout << "Reading '" << filename << " for input ...\n" << endl;

	if (!infile) {
		cerr << "Error: opening file for input failed!" << endl;
		abort();
	}

	while (! infile.eof()) {
		infile >> str;
    	stringstream(str) >> Student[count].Name;
    	Student[count].Age = 10;
		cout << str << " is " << 10 << endl;
		count++;
	}

	infile.close();
	nameCount = count - 1;

	return 0;
}

void removeNewline(char *str, int i)
{
	int len = strlen(str);

	for ( ; i < len - 1; i++) {
		str[i] = str[i + 1];
	}

	str[i] = '\0';
}

int writeTextFile(int entries)
{
	char filename[STRLEN] = "namesout.txt";

	// open a file in write mode.
	ofstream outfile;
	outfile.open(filename);

	printf("Writing \"%s\" for output ...\n\n", filename);

	if (!outfile) {
		cerr << "Error: opening file for output failed!" << endl;
		abort();
	}

	for (int c = 0; c < entries; c++) {
		outfile << Student[c].Name << ":" << Student[c].Age << endl;
	}

	// close the opened file.
	outfile.close();

	return 0;
}

void sortEntries()
{
	string name1 = "";
	string name2 = "";

	cout << endl;
	cout << "Sorting the elements of the list." << endl;
	cout << endl;

	for (int ctrLv1 = 0; ctrLv1 < nameCount - 1; ctrLv1++) {
		for (int ctrLv2 = ctrLv1 + 1; ctrLv2 < nameCount; ctrLv2++) {
			name1.assign(Student[ctrLv1].Name);
			name2.assign(Student[ctrLv2].Name);

			if (name1.compare(name2) > 0) {
				std::cout << Student[ctrLv1].Name << " is greater " << Student[ctrLv2].Name << endl;
				swapElements(&Student[ctrLv1], &Student[ctrLv2]);
			}
		}
	}
}

void swapElements(struct student_t *p1, struct student_t *p2)
{
	student_t temp = *p1;
	*p1 = *p2;
	*p2 = temp;
}

/********************
 **
 ** End of program
 **
 **/
