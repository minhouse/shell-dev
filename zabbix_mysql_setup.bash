#!/bin/bash

dbpw="zabbix"
mysqlcmd="mysql -uroot -p"$dbpw"" 

#/etc/init.d/mysqld start

#/usr/bin/mysqladmin -u root password 'zabbix'

mysqltmp="/tmp/mysql_secure_installation.sql"

cat << END > $mysqltmp 

DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1','::1');
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'
FLUSH PRIVILEGES;

END

$mysqlcmd < $mysqltmp
