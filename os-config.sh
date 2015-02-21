#!/bin/bash

action="$1"
time=`date +%Y%m%d%H%M%S`

f-status(){
	ipaddr=`ifconfig eth0 |awk 'NR==2' |awk '{print $2}' |awk -F ':' '{print $2}'`
	echo "IP: "$ipaddr""
	mask=`ifconfig eth0 |awk 'NR==2' |awk '{print $4}' |awk -F ':' '{print $2}'`
	echo "Netmask: "$mask""
	gateway=`netstat -nr |grep '^0.0.0.0' |awk '{print $2}'`
	echo "Gateway: "$gateway""
	dns=`cat /etc/resolv.conf |awk 'NR==2' |awk '{print $2}'`
	echo "DNS: "$dns""
	host=`cat /etc/sysconfig/network |grep '^HOSTNAME=.*' |awk -F '=' '{print $2}'`
	echo "Hostname: "$host""
}

f-host(){
	echo -n "Hostname: "
	read host
	while :
	do
		echo -n "This Change will reboot the system. Do you want to continue?[Y/N]: "
		read ans
		case "$ans" in 
			"Y" | "y" )
				HOSTNAME=`sed -i "s/^HOSTNAME=.*/HOSTNAME="$host"/" /etc/sysconfig/network`
				init 6
				exit 0
				;;
			[Nn] )
				exit 0
				;;
			* )
				;;
		esac
	done
}

ip-addr(){
	cp -p /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0_"$time"
	echo -n "IP Address: "
	read IP
	echo -n "Netmask: "
	read MASK
	echo -n "Gateway: "
	read GATEWAY
	echo -n "DNS: "
	read DNS
	sed -i "s/^IPADDR=.*/IPADDR="$IP"/" /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i "s/^NETMASK=.*/NETMASK="$MASK"/" /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i "s/^GATEWAY=.*/GATEWAY="$GATEWAY"/" /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i "s/^DNS1=.*/DNS1="$DNS"/" /etc/sysconfig/network-scripts/ifcfg-eth0
}

case "$action" in
	"ip" ) 
		ip-addr
		;;
	"host" ) 
		f-host
		;;
	"status" ) 
		f-status
		;;
	"all" )
		echo -n ""
		;;
	* )
		echo "Usage: ./os-config.sh [ip|host|status|all]"
		;;
esac

