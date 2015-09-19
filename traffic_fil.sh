#!/bin/bash

if [ "$#" -ne 1 ];then
 echo "Usage:Please specify source file name"	
 exit 1
fi

if [ ! -f "$1" ];then
	echo "Usage:Source file doesn't exit, plese check file name"
	exit 1
fi

inputfile="$1"
tmpfile=`echo "$inputfile" |awk -F '.' '{print$1}'`
outfile="$tmpfile".pcap
echo $outfile

filter='((!udp.port == 5353) && !(tcp.port == 443) && !(udp.port == 8612) && !(udp.port == 57623))'

#tshark -Y '(((((!(udp.port==443)) && !(udp.port==8612) && !(arp) && !(ip.version == 6) && !(udp.port==17500)))))' -r "$file" -w fil20150801.pcap

counter=0

while :
do
	if [ -f "$outfile" ];then #check existence of file
		counter=`expr $counter + 1`
		counter=`printf %02d $counter`
		outfile="${tmpfile}-${counter}.pcap"
	else
		tshark -Y "$filter" -r "$inputfile" -w "$outfile"
		break		
	fi
done

#Check for mistakenly using an already-filterd file
#outfile_md5=`md5 "$outfile" |awk '{print $4}'`
outfile_shasum=`shasum "$outfile" |awk '{print $1}'`
#echo $outfile_md5
echo $outfile_shasum
#inputfile_md5=`md5 "$inputfile" |awk '{print $4}'`
inputfile_shasum=`shasum "$inputfile" |awk '{print $1}'`
#echo $inputfile_md5
echo $inputfile_shasum

#if [ "$outfile_md5" == "$inputfile_md5" ];then
if [ "$outfile_shasum" == "$inputfile_shasum" ];then
	echo "Usage:The same file already exist"
	rm "$outfile"
	exit 1
else
	echo ""$outfile" was created"
fi

