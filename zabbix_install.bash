#!/bin/bash

# Variables
dbpw="zabbix"
zabbixdbpw="passwd" 		#For ZABBIX DB Password
mysqlcmd="mysql -uroot -p"$dbpw"" 

# Functions

chkconnect(){
	ping -c 1 192.168.11.1
		if [ $? -ne 0 ];then
			echo "Internet connection is lost!"
			exit 1
		fi
}

zabbixinstall(){
	rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm
	yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent mysql-server
}

mysqldbsetup(){
	/etc/init.d/mysqld start
	/usr/bin/mysqladmin -u root password 'zabbix'
	mysqltmp="/tmp/mysql_secure_installation.sql"

	cat <<-END > $mysqltmp 

	DELETE FROM mysql.user WHERE User='';
	DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1','::1');
	DROP DATABASE test;
	DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
	FLUSH PRIVILEGES;
	create database zabbix character set utf8 collate utf8_bin;
	grant all privileges on zabbix.* to zabbix@localhost identified by "$zabbixdbpw";

	END

	$mysqlcmd < $mysqltmp
}

mysqlinitial(){
	zabbixver=`yum list zabbix |grep zabbix |awk '{print $2}' |sed 's/^\(.*\)-.*/\1/'`
	zabbixdoc="/usr/share/doc/zabbix-server-mysql-"$zabbixver"/create"
	$mysqlcmd zabbix < "$zabbixdoc"/schema.sql
	$mysqlcmd zabbix < "$zabbixdoc"/images.sql
	$mysqlcmd zabbix < "$zabbixdoc"/data.sql
}

zabconfset(){
	cp -p /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf-Org
	sed -i "/^# DBPassword=$/a DBPassword=$zabbixdbpw" /etc/zabbix/zabbix_server.conf
	cp -p /etc/httpd/conf.d/zabbix.conf /etc/httpd/conf.d/zabbix.conf-Org
	sed -i '/^    # php_value date\.timezone.*$/c \    php_value date.timezone Asia/Tokyo' /etc/httpd/conf.d/zabbix.conf
}

# IPTABLES setting
iptablesset(){
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 10050 -j ACCEPT
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
	/etc/init.d/iptables save
}

# Disable SELinux

setselinux(){
	sed -i "s/^SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
	setenforce 0
}

# Starting Processes

startupzabbix(){
	chkconfig mysqld on
	chkconfig httpd on
	chkconfig zabbix-server on
	chkconfig zabbix-agent on
}

# Main Program

chkconnect >> /var/tmp/zabbixinstall.log 2>&1  		#add comment

echo "Installing ZABBIX"
zabbixinstall >> /var/tmp/zabbixinstall.log	2>&1	#add comment
echo "Installing ZABBIX done"

echo "Setting MySQLdb for zabbix"
mysqldbsetup >> /var/tmp/zabbixinstall.log 2>&1		#add comment
echo "Setting MySQLdb for zabbix done"

echo "Starting MySQL initial setup"
mysqlinitial >> /var/tmp/zabbixinstall.log 2>&1		#add comment
echo "Starting MySQL initial setup done"

zabconfset >> /var/tmp/zabbixinstall.log 2>&1		#add comment

service zabbix-server start >> /var/tmp/zabbixinstall.log 2>&1
service httpd restart >> /var/tmp/zabbixinstall.log 2>&1

echo "Setting IPTABLES"
iptablesset >> /var/tmp/zabbixinstall.log 2>&1
echo "Setting IPTABLES done"

echo "Setting SELinux"
setselinux >> /var/tmp/zabbixinstall.log 2>&1
echo "Disabling SELinux done"

echo "Setting runlevel"
startupzabbix
echo "Setting runlevel done"

echo "ZABBIX Installation Completed!"
IPADDR=`ifconfig | grep "inet addr:" | grep -v "127.0.0.1" | awk '{print $2}' | awk -F ':' '{print $2}' `
echo "------"
echo "Please access to ZABBIX server http://${IPADDR}/zabbix/"
echo "username/password is Admin/zabbix"
echo "------"
echo "Zabbix's DataBase setting parameter"
echo "Database: zabbix"
echo "Zabbix DB hostname: localhost"
echo "User: zabbix" 
echo "Password: $zabbixdbpw"
