#!/bin/bash -ue
#===================================================================================
#
#         FILE: service-monitoring.sh
#
#        USAGE: service-monitoring.sh <SERVICE NAME>
#
#  DESCRIPTION:It's all about SLA requirement. Automatic process failure detection & recovery script to improve MTTR(Mean Time to Repair) 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Hiroshi Yasuda & Minho Tokuhara
#      COMPANY: at&t Japan
#      VERSION: 2.2
#      CREATED: 11.08.2013
#     REVISION: 11.08.2013
#=================================================================================
#----------------------------------------------------------------------
# valiables
#----------------------------------------------------------------------
LANG=C
SERVICE="$1"                
#INTERVAL=60 
MAIL_TO="root"
DATE_YMD=`date +%c`
PS_CMD='ps -ef |grep "$SERVICE" |grep -v grep |grep -v $0'
LOCK_FILE="/tmp/`basename $0`-"$SERVICE".lock"

NG_LOGGER_CMD='logger -t [Service Monitor] -p user.error ${SERVICE} is down'
OK_LOGGER_CMD='logger -t [Service Monitor] -p user.error ${SERVICE} is start'
FAIL_LOGGER_CMD='logger -t [Service Monitor] -p user.error ${SERVICE} is Restart Fail'
HOST_NAME=`uname -n`
MAIL_BODY=""
MAIL_FOOTER=""
PROC_STATE=""
SUBJECT=""
MBODY=""

#=== FUNCTION ================================================================
#        NAME: Mail_Send
# DESCRIPTION: mail send function
# PARAMETER 1: ---
#=============================================================================
function Mail_Send(){ 
PROC_STATE=$1 
case $PROC_STATE in
   "FAIL")
         SUBJECT="${HOST_NAME} : ${SERVICE} is Restart Fail! : $DATE_YMD "
         MAIL_BODY="SERVER:${HOST_NAME}\nSTATE:${SERVICE} is Restart Fail!\nDATE: $DATE_YMD "
         ;;
     "NG")
         SUBJECT="${HOST_NAME} : ${SERVICE} is down! : $DATE_YMD "
         MAIL_BODY="SERVER:${HOST_NAME}\nSTATE:${SERVICE} is down!\nDATE: $DATE_YMD "
         ;;
    "OK")
         SUBJECT="${HOST_NAME} : ${SERVICE} is START! : $DATE_YMD "
         MAIL_BODY="SERVER:${HOST_NAME}\nSTATE:${SERVICE} is START!\nDATE: $DATE_YMD "
         ;;
       *)
         :
         ;;
esac

MBODY=`echo -e $MAIL_BODY`
MFOOT=`echo -e $MAIL_FOOTER`
mailx -s "$SUBJECT" $MAIL_TO <<_MB 
$MBODY
$MFOOT
_MB
}


#----------------------------------------------------------------------
# MAIN
#----------------------------------------------------------------------

#In case script was executed without argument
if [ $# -ne 1 ];then
	echo "USAGE: service-monitoring.sh <SERVICE NAME>"
	exit 1
fi

if ! eval $PS_CMD;then
  eval $NG_LOGGER_CMD && Mail_Send NG 
  case $SERVICE in
    rsyslog)
           /etc/init.d/rsyslog restart
           ;;
     squid)
          /etc/init.d/squid restart 
           ;;
         *)
           MAIL_FOOTER="Not Defined Restart Logic"
           ;; 
  esac
	if eval $PS_CMD;then
		eval $OK_LOGGER_CMD && Mail_Send OK
  		
		else 
     		eval $FAIL_LOGGER_CMD && Mail_Send FAIL
  	fi     
fi
