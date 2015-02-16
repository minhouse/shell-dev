#!/bin/bash


#-Variables

host=`hostname`
dt=`date +"%Y/%m/%d %I:%M:%S"`
ipaddr=`ifconfig eth0 |awk 'NR==2' |awk '{print $2}' |awk -F ':' '{print $2}'`
mask=`ifconfig eth0 |awk 'NR==2' |awk '{print $4}' |awk -F ':' '{print $2}'`
gateway=`netstat -nr |awk 'NR==5' |awk '{print $2}'`
dns=`cat /etc/resolv.conf |awk 'NR==2' |awk '{print $2}'`
tp=`top -n 1`
tn=`echo "$tp" |awk 'NR==2' |awk '{print $2}'`
la=`echo "$tp" |awk 'NR==1' |awk '{print $11,$12,$13}'`
mfree=`free`
mem=`echo "$mfree" |awk 'NR==3' |awk '{print $4}'`
sw=`echo "$mfree" |awk 'NR==4' |awk '{print $4}'`

#-Main

echo -e "Hostname\t\t:${host}"
echo -e "Date\t\t\t:${dt}"
echo -e "IP Address\t\t:${ipaddr}"
echo -e "Netmask\t\t\t:${mask}"
echo -e "Default Gateway\t\t:${gateway}"
echo -e "DNS Server\t\t:${dns}"
echo -e "Total Process\t\t:${tn}"
echo -e "Load Average\t\t:${la}"
echo -e "Memory Free\t\t:${mem}"
echo -e "Memory Swap\t\t:${sw}"




