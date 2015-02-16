#!/bin/bash

src="$1"
count=`echo "$src" |wc -c`
n=1

#if [ "$src" == "" ];then
if [ "$#" -ne 1 ];then
	echo "Please put numbers"
	exit 1
fi

while [ "$n" -lt "$count" ] 
#while :
do
	cmd=`echo "$src" |cut -b "$n"`
	#if [ "$cmd" != "" ];then
		num=`echo "$cmd"`
		n=`expr $n + 1`
		rslt=${num}${rslt}
	#else
		#break
	#fi
done
echo "$rslt"
