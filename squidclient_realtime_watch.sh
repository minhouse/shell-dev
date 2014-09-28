#!/bin/bash

log="/root/scripts/file.csv"

count=1

while     :
     do
          cmd=`squidclient -p 3128 mgr:info 2> /dev/null`

          if [ -z "$cmd" ];then
               echo "Squid is not running"
               exit 1
          fi

          if [ ! -s $log ];then
               touch "$log"
               maxfd=`echo "$cmd" |grep 'Maximum number' |awk -F ':' '{print $2}'`
               echo "Maximum Number of File Descriptor:${maxfd}" > "$log"
               echo "Date,HTTP-Req,Ave-HTTP-Req,Access-Cache,FailureRate%,LargeFD,CurrentFD,AvailablbleFD" >> "$log"
          fi

          time=`echo "$cmd" |grep 'Current Time:' |awk -F ',' '{print $2}' |awk '{print $3,$2,$1,$4}' |sed 's/ Sep /\/09\//'`

          time=`date +%s --date "$time"`
          time=`expr 32400 + "$time"`

          jst=`date +"%Y/%m/%d %T" --date "@${time}"`

          hreq=`echo "$cmd" |grep 'Number of HTTP' |awk -F ':' '{print $2}'`
          avehreq=`echo "$cmd" |grep 'Average HTTP requests per minute' |awk -F ':' '{print $2}'`
          ncash=`echo "$cmd" |grep 'accessing cache' |awk -F ':' '{print $2}'`
          fratio=`echo "$cmd" |grep 'failure ratio' |awk -F ':' '{print $2}'`
          largefd=`echo "$cmd" |grep 'Largest file' |awk -F ':' '{print $2}'`
          curfd=`echo "$cmd" |grep 'Number of file desc currently' |awk -F ':' '{print $2}'`
          avaifd=`echo "$cmd" |grep 'Available number of file descriptors' |awk -F ':' '{print $2}'`
    
          hreq=`echo $hreq |sed 's/ //'`
          avehreq=`echo $avehreq |sed 's/ //'`
          ncash=`echo $ncash |sed 's/ //'`
          fratio=`echo $fratio |sed 's/ //'`
          maxfd=`echo $maxfd |sed 's/ //'`
          largefd=`echo $largefd |sed 's/ //'`
          curfd=`echo $curfd |sed 's/ //'`
          avaifd=`echo $avaifd |sed 's/ //'`
         
          echo ${jst},${hreq},${avehreq},${ncash},${fratio},${largefd},${curfd},${avaifd} >> file.csv
    
          sleep 3

          if [ ! -z $1 ];then
               cnt=`expr $cnt + 1`
               if [ $cnt -ge $1 ];then
                    exit 0
               fi
          fi
done