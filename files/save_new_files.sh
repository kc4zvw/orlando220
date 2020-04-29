#!/bin/bash
#
# $Id: save_new_files.sh,v 0.18 2020/03/08 00:52:00 kc4zvw Exp kc4zvw $

# define globals variables

declare -g myfilename="*****"

#
# define the new functions
#

function find_newest_file
{
	local newest_file
	local -r path=$1
	local -r pattern=$2

	newest_file=$(find "$path" -name "$pattern" -print0 | xargs -0 ls -1 -t | head -1)

	echo $newest_file > $HOME/.newest_text_file

	return 0
}

function newest_matching_file
{
	local -r glob_pattern=$2
	local -r search_path=$1

	# To avoid printing garbage if no files match the pattern, set
	# 'nullglob' if necessary
	local -i need_to_unset_nullglob=0

	if [[ ":$BASHOPTS:" != *:nullglob:* ]] ; then
		shopt -s nullglob
		need_to_unset_nullglob=1
	fi

	newest_file=
	for file in $search_path/$glob_pattern ; do
		[[ -z $newest_file || $file -nt $newest_file ]] \
			&& newest_file=$file
	done

	# To avoid unexpected behaviour elsewhere, unset nullglob if it was
	# set by this function
	(( need_to_unset_nullglob )) && shopt -u nullglob
	
	# Use printf instead of echo in case the file name begins with '-'
	[[ -n $newest_file ]] && printf '%s\n' "$newest_file"


    echo $newest_file > $HOME/.newest_text_file

	return 0
}

function search_number_four
{
	local newest_file
	local -r path=$1
	local -r pattern=$2


	dir1=$path

	#while inotifywait -qqre modify "$dir1"; do
	#	### /run/backup/to/B
	#	/home/kc4zvw/bin/send-text-files.sh
	#done

	newest_file="@@@@@"

    echo $newest_file > $HOME/.newest_text_file

	return 0
}

function erase_output_file
{
	echo "Erase log file ..."
	`rm -f $HOME/.newest_text_file`
	echo
}

###================================================================== ###

# main program

echo
echo "Running $0"
echo
echo "Find newest file in directory ..."
echo

MYDIR=$HOME/Text

# Bash, GNU coreutils
newest=0
newest_t=0

for f in $MYDIR/*.txt;
do
	t=$(stat -c "%Z" -- "$f")		# mtime

	if [[ $t > $newest_t ]]; then
		newest_t=$t
		newest=$f
		#printf "%d : %s\n" $newest_t $newest
	fi
done

myfilename=$newest

echo "Run function number one:"
echo
printf "Newest file: %s\n" $myfilename
echo

erase_output_file

echo "Run function number two:"
mystatus2=`find_newest_file "$MYDIR" "*.txt"`
myfilename=`cat $HOME/.newest_text_file`
echo
printf "Newest file: %s\n" $myfilename
echo

erase_output_file

echo "Run function number three:"
echo
mystatus3=`newest_matching_file "$MYDIR" "*.txt"`
myfilename=`cat $HOME/.newest_text_file`
printf "Newest file: %s\n" $myfilename
echo

erase_output_file

echo "Run function number four:"
echo
mystatus4=$(search_number_four "$MYDIR" "*.txt")
myfilename=`cat $HOME/.newest_text_file`
printf "Newest file: %s\n" $myfilename
echo

echo "Finished."

# End of File
