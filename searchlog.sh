#!/bin/bash
#==========================================================================        =========
#
#         FILE: searchlog.sh
#
#        USAGE: Execute this file manually or set on /etc/crontab
#
#  DESCRIPTION: Extracting NW device ips from logfile to match iplist
#
#      OPTIONS: ---
# REQUIREMENTS: There must be iplist file. /dir/xxxlogiplist.txt
#         BUGS: ---
#        NOTES: ---
#       AUTHOR:  
#      COMPANY:  
#      VERSION: 1.2
#      CREATED: 10.08.2013 
#     REVISION: DD.MM.YYYY
#==========================================================================
#searchlog.sh Version1.2
#Originally created by 
#Date created: 2013/08/26
#Date modified: 2013/10/02
#You need to copy original script file create a new version of script
#Modified by 

LANG=C

#-Variables
MAIL_FROM="administrator"
MAIL_TO="root"
DATE_YMD=`date +%c`
IPLIST='/home/scripts/iplist.txt'
LOGFILE='/var/log/cisco'
HOSTNAME=`uname -n`

#RECIP=`cut -d ' ' -f4 $LOGFILE | sort -t '.' -k 4 -n |uniq`
#RECIP=`cat $LOGFILE | sed 's/\s{1,\}//g' | cut -d ' ' -f4 $LOGFILE | sort -n -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 |uniq`

RECIP=`cat $LOGFILE | sed 's/\s{1,\}/ /g' | cut -d ' ' -f5 | sort -n -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 |uniq`

while read i
do
	#echo "$RECIP" |grep "^${i}$" > /dev/null
	echo "$RECIP" |grep "$i" > /dev/null
	if [ $? -ne 0 ];then
		echo "NO $i" 
	fi
done < $IPLIST | mail -s "${HOSTNAME} NO IP LIST ${DATE_YMD}" -r $MAIL_FROM $MAIL_TO
