#!/bin/bash
#==========================================================================        =========
#
#         FILE: service-monitering.sh
#
#        USAGE: service-monitering.sh <xxxProxy.sh>
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR:  
#      COMPANY:  
#      VERSION:
#      CREATED: 10.08.2013 
#     REVISION: DD.MM.YYYY
#==========================================================================
#check-services.sh Version1.0
#Originally created by 
#Date created: 2013/08/4
#Date modified:
#You need to copy original script file create a new version of script
#Modified by

#--Variables--

INTERVAL=3
FROM="root@localhost"
TO="root@localhost"
DATE_YMD=`date "+%Y%m%d%H%M%S"`

#--You can specify processes here e.g 'rsyslog radiusd' 

SERVICES='rsyslog httpd crond'

#--Functions

LOGGER(){
	logger -t "[Service Monitor]" -p user.error "$i is down"
}

PS(){
	ps -ef |grep "$i" |grep -v grep > /dev/null
}

SENDMAIL(){
	/usr/sbin/sendmail -t -i
}

MAILBODY(){
cat <<-EOT
	From: <${FROM}>
	To: <${TO}>
	Subject: "${HOSTNAME}: $i is down! ${DATE_YMD}"

 	$i is down
 	$DATE_YMD

EOT
}

#--Main Process

while :  
do
	for i in $SERVICES
	do
		if ! PS 
		then
			LOGGER
			/etc/init.d/${i} start
			MAILBODY | SENDMAIL
		fi
	done

sleep $INTERVAL

done
