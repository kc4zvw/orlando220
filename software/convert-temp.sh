#!/bin/bash
#
#  $Id: convert-temp.sh,v 0.2 2020/07/18 00:13:37 kc4zvw Exp kc4zvw $
#
# Shell script to convert Fahrenheit to Celsius Temperature or Celsius
# to Fahrenheit Temperature
# -------------------------------------------------------------------------
# Copyright (c) 2005 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
# Fahrenheit and Celsius Temperature Scales more info:
# http://en.wikipedia.org/wiki/Temperature_conversion_formulas
# --------------------------------------------------------------------


function convert_c2f
{
	echo -n "Enter temperature (C) : "
	read -r degreesC
	# formula Tf=(9/5)*Tc+32
	degreesF=$(echo "scale=20; ((9/5) * $degreesC) + 32" | bc)
	printf "\n%0.2f degrees C = %0.2f degrees F\n\n" $degreesC $degreesF 
}

function convert_f2c
{
	echo -n "Enter temperature (F) : "
	read -r degreesF
	# formula Tc=(5/9)*(Tf-32)
	degreesC=$(echo "scale=20; (5/9) * ($degreesF - 32)" | bc)
	printf "\n%0.2f degrees F = %0.2f degrees C\n\n" $degreesF $degreesC 
}

function display_menu
{
	echo
	echo "*** Converting between the different temperature scales ***"
	echo "  1. Convert Celsius temperature in to Fahrenheit degrees"
	echo "  2. Convert Fahrenheit temperature in to Celsius degrees"
	echo "  3. Quit the program"
	echo
	echo -ne "Select your choice (1, 2 or 3) : "
}

function quit_program
{
	echo
	echo "Finished."
	echo
	exit 0
}

while : ;
do
	display_menu

	read -r choice
	echo

	case $choice in
		1)	convert_c2f
			continue ;;
		2)	convert_f2c
			continue ;;
		3)	quit_program
			break ;;
		*)	echo "Please select 1, 2 or 3 only"
			echo
			echo -e "** Error: '$choice' is not valid.\n" ; continue ;;
	esac

	echo
done

# End of File 
