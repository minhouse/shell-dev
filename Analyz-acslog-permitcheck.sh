#!/bin/bash

PS4='${LINENO}${FUNCNAME[0]:+ ${FUNCNAME[0]}} |  '

#--Definition Date--- 

MONTH=`date +%m`
DAY=`date +%d`

#--Definition Variables---#

MAINDIR=/home/scripts
INFILE="$MAINDIR/PassedAuthenticationsactive.csv"
TMP_FILE1="$MAINDIR/tmp-log1.csv"
TMP_FILE2="$MAINDIR/tmp-log2.csv"
HOUR=`date +%k | sed "s/ //g"`
CONFIG_FILE="$MAINDIR/analyz.conf"

declare -A agent_group
declare -a hostlist
declare -a config_file_line
declare -a agent_host_list
declare -a agent_group_list

#--Name Resolution---#

gethost(){
	ipadd=$1
	if [ -z "${hostlist[$ipadd]}" ];then
		temp=`host $ipadd`
		ret=$?
		if [ $ret == 0 ];then
			hostlist[$ipadd]=`echo "$temp" |grep address | awk '{print $4}'`
		else
			hostlist[$ipadd]="unknown hostname"
		fi
	fi
}

#--Output Report---#

printreport(){
	declare -a data_array
	declare -A agent_group

	data_array=($@)
	echo ${data_array[@]}
	data_array[3]=`echo ${data_array[3]} |sed "s/\"//g"`	
	if [ "${data_array[3]}" != async ];then
		if [ "${data_array[3]}" = "" ];then
			data_array[3]="unknown" 
		fi
	fi
	#data_array[5]=`echo ${data_array[5]} |sed "s/\"//g"`
	data_array[3]=`echo ${data_array[3]} |sed "s/^\(.*\)$/\"\1\"/"`
	if [[ ${agent_group[${data_array[7]}]} =~ $agent_group_name ]];then
		gethost ${data_array[7]}
		printf "%-13s%-11s%-25s%-19s%-18s%15s\n" ${data_array[0]} ${data_array[1]} ${data_array[3]} ${data_array[5]} ${data_array[7]} ${hostlist[{${data_array[7]}}
		
		echo -ne i"${data_array[0]} ${data_array[1]},${data_array[3]},${data_array[5]},${data_array[7]},${agent_group[{${data_array[7]}},deny\n" >> $SAD_OUT
	else
		echo ${data_array[@]} |sed "s/\" \"/\",\"/g" > $TMP_OUT
		#echo ${data_array[@]} > $TMP_OUT
	fi	
}

#--Output Header---#

printheader(){
	declare -a head_array

	head_array=($@) #FailedAttempts.csvが入る
	
	echo -ne " +:+:+ Unsuccessful Telnet Attempts log +:+:+\n"
	echo -ne "============================================================================================================\n"
	echo -ne "Date Time User-Name Caller-ID NAS-IP-Address (hostname)\n"
	echo -ne "============================================================================================================\n"
	printreport ${head_array[@]}

}

#--Input Logging---#

inputlog(){

	local check=0
	local flag=1
	local i="$1"
	declare -a data_line
	declare -a time_line
	data_line=()

	OUT="$MAINDIR/Passed_Authentications/${agent_group_name}-success.out"
	
	if [ -e "$OUT" ];then
		flag=0

		if [ ! -s "$OUT" ];then
			flag=1

		fi
	else
		flag=1		
	fi
	
	SAD_OUT="$MAINDIR/SAD_OUT/sad.out"
		
	if [ -e "$TMP_FILE1" ];then
		check=1
	fi
	
	if [ $check -eq 0 ];then
		
		if [ ! -e $INFILE ];then 
			echo "No $INFILE"
			exit 1
		fi	
		TMP_OUT="$TMP_FILE1"
		IFS_BK="$IFS"
		#IFS=","

		while read IN
		do
			IN=`echo $IN | sed "s/,/\",\"/g"|sed "s/^\(.*\)$/\"\1\"/"`
			
			IFS=","
			data_line=($IN)
			echo ${data_line[@]}

			if [ $flag -eq 1 ];then
				printheader ${data_line[@]} >> "$OUT"
			 	flag=0
			else
				IFS=":"
				time_line=(${data_line[1]})
				time_line[0]=`echo ${time_line[0]} |sed "s/\"//g"`
				echo ${time_line[0]}
				IFS="$IFS_BK"
				echo ${data_line[@]}
				if [ "${time_line[0]}" = "$HOUR" ];then
					IFS=","
					printreport ${data_line[@]}
					echo ${data_line[@]}
					IFS="$IFS_BK"
				fi
			fi
	
		done < "$INFILE"

		IFS="$IFS_BK" #Whileの条件を見たささなくなった時の処理

	else
		if [ $i -lt 0 ];then
			TMP_IN="$TMP_FILE2"
			TMP_OUT="$TMP_FILE1"
		else
			TMP_IN="$TMP_FILE1"
			TMP_OUT="$TMP_FILE2"
		fi	
				
		IFS_BK="$IFS"
		while read IN
		do
			#IN=`echo $IN | sed "s/,/\",\"/g"|sed "s/^\(.*\)$/\"\1\"/"`
			
			IFS=","
			data_line=($IN)
			echo ${data_line[@]}
		
			if [ $flag -eq 1 ];then
				printheader ${data_line[@]} >> "$OUT"
				flag=0
			else
				IFS=":"
				time_line=(${data_line[1]})
				time_line[0]=`echo ${time_line[0]} |sed "s/\"//g"`
				echo ${time_line[0]}
				IFS="$IFS_BK"
				if [ "${time_line[0]}" = "$HOUR" ];then
					IFS=","
					printreport ${data_line[@]}
					echo ${data_line[@]}
					IFS="$IFS_BK"
				fi
			fi			

		done < "$TMP_IN"
	fi	
	
	IFS="$IFS_BK"
	
}

#--Main Routine---#

if [ ! -f $CONFIG_FILE ];then
	echo "Can't open file $CONFIG_FILE"
	exit 1
fi

p='-1'

IFS_BK="$IFS"
IFS=","

counter=0

while read CONF
do
	config_file_line=($CONF)
	agent_host_list=(${agent_host_list[@]} "${config_file_line[1]}")

	if [ $counter -eq 0 ];then
		agent_group_list[$counter]=${config_file_line[0]}
		counter=`expr $counter + 1` 
	else
		if [ "${agent_group_list[`expr $counter - 1`]}" != "${config_file_line[0]}" ];then
			agent_group_list[$counter]=${config_file_line[0]}
			counter=`expr $counter + 1`
		fi
	fi	
	agent_group[${config_file_line[1]}]=${config_file_line[0]}
	
done < $CONFIG_FILE

echo "${agent_group_list[@]}"

IFS="$IFS_BK"

for agent_group_name in ${agent_group_list[@]}
do
	inputlog $p
	p=`expr $p \* -1`
	echo $p
	echo $agent_group_name
 
done
