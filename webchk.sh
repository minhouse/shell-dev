#!/bin/bash

#echo -ne 'HEAD / HTTP/1.0\n\n' | nc 127.0.0.1 80 &

ip="$1"
port="80"

if [ "$2" == "" ];then
	st="5"
elif [[ ! "$2" =~ ^[0-9]+$ ]];then
	echo "Sleep Time Must be Numbers"
	exit 1
else
	st="$2"
fi

cnt=0
while :
do
	timeout 3s nc "$ip" "$port" <<- EOS
		HEAD / HTTP/1.0

EOS
chk=`echo $?`
	if [ $chk -eq 1 ];then
		echo "HTTP is not Running"
	elif [ $chk -eq 0 ];then
		echo "HTTP is Running"
	else 
		echo "Service is not Responding"
		cnt=`expr $cnt + 1`
		if [ $cnt -eq 3 ];then
			echo "Trouble!"
			exit 1
		fi
	fi
sleep "$st"
done


