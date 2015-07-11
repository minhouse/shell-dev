#!/bin/bash

file="/home/TokuharM/scripts/HERAKey.log"

keyids=`grep -n "keyID:" HERAKey.log |awk -F ' ' '{print $1, $10}' |sed -e 's/,//g' |awk -F ':' '{print $2}' |awk -F ' ' '{print $2}'`

counter=0

echo -e "KeyID\t\tStart Time\t\tEnd Time\t\tElapsed Time(Sec)"

for i in $keyids
do
     tstamp=`grep $i $file |awk -F " " '{print $1, $2}'`

     if [ -n "$tstamp" ];then
          t1=`echo "$tstamp" |sed -n 1p`
          utime1=`date +%s --date "$t1"`
          t2=`echo "$tstamp" |sed -n 2p`
          utime2=`date +%s --date "$t2"`
          cal=`expr "$utime2" - "$utime1"`
          echo -e "$i\t$t1\t$t2\t$cal"
          counter=`expr $counter + 1`
     fi
done
echo -e "$counter\tkeys generated"
