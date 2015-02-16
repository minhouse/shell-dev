#!/bin/bash

#--Definition Variables---#

MAINDIR="analyz-acslog"				#DIRを要作成
FAIL_DIR="Failed Attempts"			#DIRを要作成
PERMIT_DIR="Passed Authentications"	#DIRを要作成
CONFIG_FILE="mail-list.conf"

declare -A nas_lst
declare -A dst_madd
declare -A mail_data
flag=0

#--Definition Date---#

OLD_DATE=`date -d '1 week ago' +%Y/%m/%d`
TODAY=`date +%Y/%m/%d`

#--Mail Setting---#

mail_subj="Weekly <$OLD_DATE - $TODAY> Scanning Report from external Deny/Permit logs"
#echo $mail_subj
mail_from=root

mailsend()
{
nc -i 2 localhost 25 <<EOT
HELO localhost
MAIL FROM: <$MAIL_FROM>
RCPT TO: <$MAIL_TO>
DATA
Subject: $MAIL_SUBJECT of ${dst_madd[${key1}]}
To: <$MAIL_TO>
From: <$MAIL_FROM>
MIME-Version: 1.0
Content-Type: text/plain;


$fail_mail /n/n $pass_mail

.
quit


EOT
}

#--Subroutine Definition---#
inputdata(){
	local group=$1
	local body=()
	echo $1

	if [ $flag -eq 0 ]
	then
		while read IN
		do
			body=(${body[@]} "$IN")
		done <"${group}-failed.out"
		flag=1
	elif [ $flag -eq 1 ]
	then
		while read IN
		do
			body=(${body[@]} "$IN")
		done <"${group}-success.out"
		flag=0
	fi
}

#--Input mail address---#

if [ ! -f $CONFIG_FILE ]; then
	echo "Cannot open file $CONFIG_FILE"
	exit 1
fi

IFS_BK="$IFS"
IFS=","

while read IN
do
        conf_line=($IN)
        if [ -z "${dst_madd[$conf_line[0]}]}" ]
        then
                dst_madd[${conf_line[0]}]="${conf_line[2]}"
        fi

#        echo "${dst_madd[${conf_line[0]}]}"

done < $CONFIG_FILE

for key1 in ${!dst_madd[@]} 

#Group名 !連想配列のキーの意味:！が先頭にあるとdst_maddのキー値を全てを取る 、！が先頭に無いと@をつける連想配列全てのバリューになる


	fail_mail=`inputdata $key1` #inputdata関数を実行時に引数としてkey1を渡す 
	pass_mail=`inputdata $key1`

echo "${fail_mail[@]}" #ここで出力される結果は、値ではなくkey値

    RMFILE1="${FAIL_DIR}/${key1}-failed.out"
    RMFILE2="${PERMIT_DIR}/${key1}-success.out"

        echo $key1             #連想配列各要素
        echo ${dst_madd[${key1}]} #連想配列要素のバリュー

       mailsend
	   	#maisend | nc -i 2 127.0.0.1 
		#mailsend関数内で定義しない場合（アドレスは変数等にする事）

       rm $RMFILE1
       rm $RMFILE2

done

