#!/bin/bash
wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+bionic_all.deb -O \
	/tmp/zabbix_repo_all.deb
dpkg -i /tmp/zabbix_repo_all.deb
rm -f /tmp/zabbix_repo_all.deb
apt update

debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password'
apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-agent

mysql -uroot -pyour_password -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -pyour_password -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'password';"
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -ppassword zabbix
sed -i 's/# DBPassword=/DBPassword=password/g' /etc/zabbix/zabbix_server.conf
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone America\/Sao_Paulo/g' /etc/zabbix/apache.conf
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
