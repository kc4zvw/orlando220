#!/bin/zsh
#
# Convert temperature from Fahrenheit to Celsius degrees
#
# $Id: degree_conversion.sh,v 0.3 2020/02/12 13:20:18 kc4zvw Exp kc4zvw $

float degreeF  degreeC

BC=$(which bc)
CALC=$(which calc)

echo "Running $0 using $CALC"
echo
echo -ne "Enter the temperature in degrees of Fahrenheit: "
read ask

degreeF=$(( ask + 0.0 ))
#degreeC=$(bc -lq <<< "($degreeF - 32) * (5/9)")
degreeC=$(echo "($degreeF - 32) / 1.8; quit" | "$CALC" -i)

printf "The input value is %0.02f Fahrenheit degrees.\n" $degreeF
printf "The answer is %0.2f Celsius degrees.\n" $degreeC
echo

# End of program
