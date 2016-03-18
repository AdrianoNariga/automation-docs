#!/bin/bash
echo "`ifconfig eth0 | grep broadcast | awk '{print $2}'` `hostname`.novalocal" >> /etc/hosts
setenforce permissive
sed -i.bak "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/selinux/config
sed -i.bak "s/#UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config
systemctl restart sshd
cat /etc/cloud/cloud.cfg | grep -v host > /tmp/cloud.cfg ; mv /tmp/cloud.cfg /etc/cloud/
yum -y install httpd
systemctl stop firewalld
echo "<h1>`hostname`</h1>" > /usr/share/httpd/noindex/index.html
systemctl start httpd
systemctl enable httpd
