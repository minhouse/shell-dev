#!/bin/bash

#-Variables

host=`hostname`
dt=`date +"%Y%m%d%I%M%S"`
logdir=/var/tmp/troublelog/var/log
OUTPUT_FILE="/var/tmp/troublelog/commands-${host}-${dt}.txt"
OUTPUT_FILE2="/var/tmp/scriptlog-${host}-${dt}.txt"
COMMAND_FILE="/home/scripts/command_file.txt"

#-Functions

syscommand(){
	while read line
		do
			if [[ "$line" =~ /etc ]];then 
				cp -p $line $logdir
			else
				echo "# $line" >>$OUTPUT_FILE
				eval $line >> $OUTPUT_FILE
				echo >> $OUTPUT_FILE
			fi
		done < $COMMAND_FILE
}

findcommand(){
	find /var/log -type f -ctime -30 -ctime +10 -print > findfile.txt
	#期間の指定方法を見直す
	while read line
		do
			cp -p $line $logdir >> $OUTPUT_FILE2
		done < findfile.txt
}

#-Main

mkdir -p /var/tmp/troublelog/var/log/

findcommand

syscommand

ls -l $logdir >> $OUTPUT_FILE2

cd /var/tmp/troublelog
tar cvf /var/tmp/result-$host-$dt.tar ./* >> $OUTPUT_FILE2
cd ../
tar rvf /var/tmp/result-$host-$dt.tar ./scriptlog-${host}-${dt}.txt 
gzip /var/tmp/result-$host-$dt.tar
#tarとgzipコマンドをあえて分けて実施しているその理由を確認、一緒に実行するコマンドも次回確認する
ls -l /var/tmp/result-$host-$dt.tar.gz

