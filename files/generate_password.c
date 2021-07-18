/*
 * randpass.c -- generate really random passwords.
 *
 * Written by Carl S. Gutekunst.
 * Released into the Public Domain: September 28, 1995
 *
 * $Id: generate_password.c,v 0.36 2021/07/18 00:36:02 kc4zvw Exp kc4zvw $
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define PASSWD_LEN 30				/* Number of chars in a password */

char passchars[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxuz";
char symbchars[] = "!$%&()*+,-./:;<=>?[]^{|}";

int main()
{
	int passIndex;
	int symbIndex1, symbIndex2;
	char passwd[PASSWD_LEN + 1];

	srand((int) time(0));			/* Set the seed for rand() */

	/*
	 *  Two positions will have symbols; the rest are alphanumeric only.  This
	 *  corresponds to meet and exceed the mandates of many UNIX password checkers.
	 */

	symbIndex1 = rand() % PASSWD_LEN;
	symbIndex2 = rand() % PASSWD_LEN;

	/*  Fill the password string with random characters. */

	for (passIndex = 0; passIndex < PASSWD_LEN; ++passIndex) {

		if (symbIndex1 == passIndex) {
			passwd[passIndex] = symbchars[rand() % (sizeof(symbchars) - 1)];
		} else if (symbIndex2 == passIndex) {
			passwd[passIndex] = symbchars[rand() % (sizeof(symbchars) - 1)];
		} else {
			passwd[passIndex] = passchars[rand() % (sizeof(passchars) - 1)];
		}
	}

	/* Write new password to stdout */

	passwd[PASSWD_LEN] = '\0'; 

	puts(passwd);

	return 0;
}

/* End of File */
