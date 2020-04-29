#!/bin/zsh
#
# Convert temperature from Celsius to Fahrenheit degrees
#
# $Id: celcius_conversion.sh,v 0.3 2020/02/12 14:53:39 kc4zvw Exp kc4zvw $

BC=$(which bc)
CALC=$(which calc)

echo "Running $0 using $CALC"
echo
echo -ne "Enter the temperature in degrees of Celsius: "
read ask

degreeC=$(( ask + 0 ))
#degreeF=$($BC -lq <<< "$degreeC * 1.8 + 32")
degreeF=$(echo "$degreeC * 1.8 + 32; quit" | "$CALC" -i)

printf "The input value is %0.02f Celsius degrees.\n" $degreeC
printf "The answer is %0.2f Fahrenheit degrees.\n" $degreeF
echo

# End of program
