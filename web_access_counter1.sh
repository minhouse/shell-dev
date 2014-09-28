#!/bin/bash

#Shell実行時"24/Aug/2014:19:46"形式でサーチする期間を年月時分単位で指定可能
d=$1 

dir="/var/log/squid"
pe="24/Aug/2014"

#Shell実行時の引数に検索日時を与えた場合の処理

if [ "$#" -eq 1 ];then
	l=`(grep "$d" "$dir"/access.log;zgrep "$d" "$dir"/*.gz) |wc -l`
	echo ""$d" accessed "$l" times"
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