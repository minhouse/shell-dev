#!/bin/bash

#-Variables

SYSTEM_FILE="/etc/hosts /etc/resolv.conf /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/crontab /etc/sudoers /etc/passwd /etc/group /etc/redhat-release"
OUTPUT_FILE="/home/scripts/getsysinfo.txt"
COMMAND_FILE="/home/scripts/command_file.txt"

#-Functions

syscommand(){
	while read line
		do
			echo "# $line" >>$OUTPUT_FILE
			eval $line >> $OUTPUT_FILE
			echo >> $OUTPUT_FILE
		done < $COMMAND_FILE
}

#-Main

for i in $SYSTEM_FILE
do
	echo "# $i"
	cat "$i"
	echo
done > $OUTPUT_FILE

syscommand

#echo "# rpm -qa" >> $OUTPUT_FILE
#rpm -qa >> $OUTPUT_FILE
#echo "# ifconfig -a" >> $OUTPUT_FILE
#ifconfig -a >> $OUTPUT_FILE
#echo "# route -n" >> $OUTPUT_FILE
#$route -n >> $OUTPUT_FILE
#echo "# ps -ef" >> $OUTPUT_FILE
#ps -ef >> $OUTPUT_FILE
#echo "# hostname" >> $OUTPUT_FILE
#hostname >> $OUTPUT_FILE
#echo "# uname -a" >> $OUTPUT_FILE
#uname -a >> $OUTPUT_FILE
#echo "# chkconfig" >> $OUTPUT_FILE
#chkconfig >> $OUTPUT_FILE
#echo "# df -k" >> $OUTPUT_FILE
#df -k >> $OUTPUT_FILE
#echo "# crontab -l" >> $OUTPUT_FILE
#crontab -l >> $OUTPUT_FILE
#echo "# dmesg" >> $OUTPUT_FILE
#dmesg >> $OUTPUT_FILE

