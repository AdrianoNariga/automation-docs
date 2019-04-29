#!/bin/bash
yum update -y
yum upgrade -y
yum -y install https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://yum.theforeman.org/releases/1.20/el7/x86_64/foreman-release.rpm
yum -y install foreman-installer

hostip=$(ip a s | grep global | awk '{print $2}' | cut -d \/ -f 1)
hostnamectl set-hostname $(hostname -f)
name_host=$(hostname)
simple_name=$(hostname -s)
cat > /etc/hosts << EOF
127.0.0.1 localhost.localdomain localhost
$hostip $name_host $simple_name
EOF
