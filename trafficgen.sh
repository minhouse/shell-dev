#!/bin/bash

#通信連続再現のシェル
#送信間隔はマイクロ秒単位
t=`date +%Y%m%d`
log="/home/minho/bittwist-linux-2.0/bittwistfile-"$t".txt"

arg-1(){
	echo -n "Please specify Microsecond: "
	read MS
}
arg-2(){
	echo -n "Please Specify PCAP File: "
	read PF
}

while :
do
	arg-1
	if [ -n "$MS" ];then
		break
	else
		echo "ERROR:Number is not specified"
	fi
done

while :
do
	arg-2
	if [ -n "$PF" ];then
		break
	else	
		echo "ERROR:File is not specified"
	fi
done

cnt=0

while :
do
	bittwist -i eth0 /home/minho/bittwist-linux-2.0/"$PF" >> "$log" 2>&1
	usleep "$MS" 
	cnt=`expr "$cnt" + 1` 
	if [ $cnt -eq 100 ];then
		echo "100 command sent successfully"	
		break
	fi	
done

