#!/bin/bash


while :
do
	#echo 'HEAD / HTTP/1.0' |nc 192.168.11.202 80 > /dev/null 2>&1
	echo -ne 'HEAD / HTTP/1.0\n\n' |nc 192.168.11.202 80
	r=`echo $?`
	if [ "$r" -eq 0 ];then
		sleep 2
	else
		echo 'HTTPD is not running'
		break
	fi
done
