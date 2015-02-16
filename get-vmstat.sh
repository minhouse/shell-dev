#!/bin/bash

#Variables

INTERVAL_SEC=1
EXECUTE_TIME=1

let EXECUTE_NUM=${EXECUTE_TIME}*60/$INTERVAL_SEC
echo $TMP
DATE_YMD=`date "+%Y%m%d%H%M%S"`

RESULT_DIR=/home/scripts
VMSTAT_OUT=${RESULT_DIR}/vmstat_`uname -n`_`date "+%Y%m%d%H%M%S"`.log

#Execution

vmstat -n -a $INTERVAL_SEC $EXECUTE_NUM | gawk '{ print strftime("%Y/%m/%d %H:%M:%S"), $0 } { fflush() }' >> $VMSTAT_OUT
