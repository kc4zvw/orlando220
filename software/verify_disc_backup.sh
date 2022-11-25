#!/bin/bash
#
# RCS info - $Id: verify_disc_backup.sh,v 0.1 2022/06/13 14:12:44 kc4zvw Exp kc4zvw $
#
# Copyright (C) 2012,2022 by David Billsbrough, Steve Litt
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

### Global Variables

Dashes="============================================================"

function check_useage()
{
	let errcount=0

	if test `id -u` -ne 0 ; then
		echo 
		echo "Error: Must be root to use this program. Use sudo."
		echo
		let errcount=$errcount+1 
	fi
		
	num_args=$1

	if test "$num_args" != "2"; then
		echo
		echo "Error: Must have 2 arguments. You had $num_args"
		echo
		let errcount=$errcount+1
	fi

	#echo errcount is $errcount

	if test $errcount -ne 0; then
		echo "USAGE:"
		echo "  sudo $0 disc_device mountpoint"
		echo
		exit 1
	fi
}
	
function comp_one()
{
	echo
	fmd5=$1

	ftgz=`echo $fmd5 | sed -e "s/\.md5$/.tgz/"`

	echo -n Testing $fmd5 and $ftgz ...
	echo

	md5stored=`cut -b1-32 < $fmd5`
	md5live=`md5sum $ftgz | cut -b1-32`
	#md5live="simulateerror"

	echo Results, stored vs live:  $md5stored   $md5live

	echo -n `date +"%m-%d-%Y at %k:%M:%S (%Z) - "` | tee -a $logg

	if test "$md5live" == "$md5stored"; then
		echo " Md5sum OK for $fmd5" | tee -a $logg
		echo "    Md5 is $md5stored" | tee -a $logg
		#echo " Md5sum OK for $fmd5"
	else
		echo " Md5sum !!ERROR!! for $fmd5" | tee -a $logg
		echo "    Stored md5=$md5stored, live=$md5live" | tee -a $logg
		#echo " Md5sum !!ERROR!! for $fmd5"
		let numerrors=$numerrors+1
	fi

}

# need to write this one

function display_heading()
{
cat <<- _end_of_text | tee -a $logg
   ***** TITLE of PROGRAM *****

Running: $0

Your current working directory is: $PWD

_end_of_text
}


##### MAIN PROGRAM STARTS HERE #####

check_useage $#

DeviceName=$1
MountPoint=$2

mount $DeviceName $MountPoint

pushd $2 > /dev/null

let numerrors=0
export numerrors
logg=$HOME/verify_disc.log
export logg

echo "Creating log file : $logg"

touch $logg
echo | tee -a $logg

### VERIFY RUN HEADER

display_heading

echo $Dashes | tee -a $logg
echo `date +"%m-%d-%Y at %k:%M:%S"` | tee -a $logg
echo " Starting new disc verify." | tee -a $logg

echo $Dashes | tee -a $logg

### LOOP THROUGH DISC

shopt -s nullglob
let md5count=0
for i in *.md5; do
	comp_one $i
	let md5count=$md5count+1
done

### VERIFY RUN FOOTER

echo | tee -a $logg
echo $Dashes | tee -a $logg
echo `date +" %m-%d-%Y at %k:%M:%S (%Z)"` | tee -a $logg
echo " Disc verify finished. " | tee -a $logg

if test $numerrors -eq 0; then
	echo "Congratulations, all files, $md5count total, verified." | tee -a $logg
else
	printf " The error count is %d.\n" $numerrors | tee -a $logg
fi

echo $Dashes | tee -a $logg
echo -e "\n\n" | tee -a $logg

popd > /dev/null
#umount $1


# ***** End of script *****
