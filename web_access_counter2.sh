#!/bin/bash

d=$1 

dir="/var/log/squid"
pe="24/Aug/2014"

#Shell実行時の引数に"24/Aug/2014:19形式の日時を検索条件とした場合の分単位の処理

if [ "$#" -eq 1 ];then
	min=0
	r=`echo $1`
	while [ $min -lt 60 ]
		do
			min=`printf %02d $min`
			f=`echo $r:$min`
			cnt=`(grep -h $f $dir/access.log;zgrep -h $f $dir/*.gz) |wc -l`
			echo ""$f:$min" accessed "$cnt" times"
			min=`expr $min + 1`
		done
	exit 0
fi

#Shell実行時に引数を与えなかった場合の処理

if [ "$#" -eq 0 ];then
	hour=0
	hour=`printf %02d $hour`
	while [ $hour -lt 24 ]
	do
		min=0
		while [ $min -lt 60 ]
			do
				min=`printf %02d $min`
				cnt=`(grep -h $pe:$hour:$min $dir/access.log;zgrep -h $pe:$hour:$min $dir/*.gz) |wc -l`
				echo ""$pe:$hour:$min" accessed "$cnt" times"	
				min=`expr $min + 1`
			done
		hour=`expr $hour + 1`
		hour=`printf %02d $hour`
	done
	exit 0
fi