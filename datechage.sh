#!/bin/bash

#日付を５秒おきに変更するスクリプト
#用途は日付が変わるとログのローテーションをするスクリプトの動作確認等をする時に利用する		
#使用後は公開NTPサーバーとの同期を実施し日付を戻す事
# ntpdate ntp.nict.go.jp


LANG=C
month=`date +%b`
day="06"
time="0000"

if [ $month = "Jan" -o $month = "Mar" -o $month = "May" -o $month = "July" -o $month = "Aug" -o $month = "Oct" -o $month = "Dec" ];then
	end_day=31
elif [ $month = "Feb" ];then
	end_day=28
else
	end_day=30
fi

month=`date +%m`

while [ $day -le $end_day ]
do
	day=`printf %02d $day`
	DATE_OPTION="${month}${day}${time}"
	echo "date $DATE_OPTION"
	date $DATE_OPTION
	
	day=`expr $day + 1`
	sleep 5
done
exit 1