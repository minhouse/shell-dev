#!/bin/bash

pname="$1"
pid=`ps -ef | grep -v grep | grep "$pname" |awk '{print $2}'`

for i in $pid
do
     echo -n "Do you want to kill "$i": "
     while :
     do
          read INPUT
          if [ "$INPUT" == yes -o "$INPUT" == no ];then
               break
          fi
          echo "Please input yes or no"
          echo -n "Do you want to kill "$i": "
     done
     if [ $INPUT == yes ];then
          kill -9 "$i"
     elif [ $INPUT == no ];then
          #exit 1; #Shell自体を終了する
          : #何もしない場合
     fi
done
