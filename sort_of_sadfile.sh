#!/bin/bash

SAD_FILE=sad.out

declare -A nas_lst
declare -A dst_madd
declare -A mail_data
declare -A mail_group

if [ ! -f $SAD_FILE ]; then
	echo " Cannot open file $SAD_FILE"
	exit 1
fi

IFS_BK="$IFS"
IFS=","
while read IN
do
	sad_line=($IN)
	if [ -z "${nas_lst[$sad_line[3]}]}" ]
	then
		nas_lst[${sad_line[3]}]="0"
	fi
	
	#echo "${sad_line[3]}"

done < $SAD_FILE
IFS="$IFS_BK"

data_line=`sort -k 1 -t ',' $SAD_FILE`

echo "$data_line"

 
