#!bin/bash

#Definition Variables

MAINDIR="/home/scripts/analyz-acslog";
SAD_FILE="${MAINDIR}/SAD_OUT/sad.out";
LST_FILE="${MAINDIR}/account_disable.lst";
CONFIG_FILE="${MAINDIR}/analyz.conf";
MAIL_LIST="${MAINDIR}/mail-list.conf";

declare -A nas_lst
declare -A dst_madd
declare -A mail_data
declare -A mail_group

#mail setting
mail_subj="OPEN Problem Ticket to LLFW Failed Login Alert";
mail_form="xxxx@xxx.com";

#Input device address
[! -f $CONFIG_FILE] && echo "Cannot openfile $CONFIG_FILE", exit 1
while read CONFIN
do
	CONFIN=`echo $CONFIN|sed -e 's/,/ /g'`
	conf_line=($CONFIN)
	mail_group["${conf_line[1]}"]=${conf_line[0]}

done <$CONFIG_FILE

#Input device address
[! -f $MAILLIST] && echo "Cannot openfile $MAILLIST", exit 1
while read MAILLIST
do
	MAILLIST=`echo $MAILLIST|sed -e 's/,/ /g'` #gは全てを置き換え
	mail_line=($MAILLIST)
	dst_add["${mail_line[0]}"]=${mail_line[1]}

done <$MAILLIST

