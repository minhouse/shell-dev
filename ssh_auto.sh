#!/bin/bash

hosts=`grep ^Host ~/.ssh/config |awk '{print $2}'`
cmdlist="/Users/tokuharaminho/shell-lesson/commandlist.txt" 
cmd2="/sbin/ifconfig |sed -n 2p"
#csv="/Users/tokuharaminho/shell-lesson/result.csv"

for h in $hosts
do
	flag=0
	flag1=0
	rcmd=""
	while read IN
	do
		if [ $flag -lt 1 ];then
			scmd1=`ssh -n $h "$IN"`
			scmd2=`ssh -n $h "$cmd2"`
			scmd2=`echo $scmd2 |awk '{print $2}' |sed -e 's/^addr://'`
			rcmd="$scmd1,$scmd2"
			flag=1
		else
			scmd1=`ssh -n $h "$IN"`
			rcmd="$rcmd,$scmd1"
		fi
	done < $cmdlist
	echo $rcmd 
done 
