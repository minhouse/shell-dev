#!/bin/bash

# Functions

chkconnect(){
	ping -c 1 192.168.11.1
		if [ $? -ne 0 ];then
			echo "Internet connection is lost!"
			exit 1
		fi
}

zabbix-agentinstall(){
	osver=`cat /etc/redhat-release |awk '{print $3}' |awk -F '.' '{print $1}'`
	if [ $osver -eq 5 ];then 
		rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/5/x86_64/zabbix-release-2.2-1.el5.noarch.rpm
	elif [ $osver -eq 6 ];then
		rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm
	else
		echo "Couldn't get OS Version"
		exit 1
	fi
	yum -y install zabbix-agent
}

zabagentconfset(){
	cp -p /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf-Org
	
	name=`hostname`
	ipaddr=` ifconfig eth0 |awk 'NR==2' |awk '{print $2}' |awk -F ':' '{print $2}'` 
	
	sed -i "s/^Server=127.0.0.1/Server=192.168.11.50/" /etc/zabbix/zabbix_agentd.conf
	sed -i "s/^Hostname=Zabbix server/Hostname="$name"/" /etc/zabbix/zabbix_agentd.conf
	sed -i "s/^ListenIP=127.0.0.1/ListenIP="$ipaddr"/" /etc/zabbix/zabbix_agentd.conf
	sed -i "/^# ServerActive=$/a ServerActive=192.168.11.50:10051" /etc/zabbix/zabbix_agentd.conf 
}

# IPTABLES setting
iptablesset(){
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 10050 -j ACCEPT
	/etc/init.d/iptables save
}

# Disable SELinux

setselinux(){
	sed -i "s/^SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
	setenforce 0
}

# Starting Processes

startupzabbixagent(){
	chkconfig zabbix-agent on
	/etc/init.d/zabbix-agent start
}

# Main Program

chkconnect >> /var/tmp/zabbix-agentinstall.log 2>&1  		#add comment

echo "Installing ZABBIX"
zabbix-agentinstall >> /var/tmp/zabbix-agentinstall.log	2>&1	#add comment
echo "Installing ZABBIX done"

echo "Setting IPTABLES"
iptablesset >> /var/tmp/zabbix-agentinstall.log 2>&1
echo "Setting IPTABLES done"

echo "Setting SELinux"
setselinux >> /var/tmp/zabbix-agentinstall.log 2>&1
echo "Disabling SELinux done"

echo "Setting runlevel"
startupzabbixagent >> /var/tmp/zabbix-agentinstall.log 2>&1
echo "Setting runlevel done"

echo "Setting Zabbixagent conf"
zabagentconfset >> /var/tmp/zabbix-agentinstall.log 2>&1
echo "Setting Zabbixagent done"

echo "ZABBIX Agent Installation Completed!"
echo "------"
