#!/bin/bash
foreman_hostname=foreman.local
ip_foreman=192.168.111.100

proxy_hostname=proxy.local
ip_proxy=192.168.111.101

hostnamectl set-hostname $foreman_hostname

grep $foreman_hostname /etc/hosts || echo "$ip_foreman $foreman_hostname" >> /etc/hosts
grep $proxy_hostname /etc/hosts || echo "$ip_proxy $proxy_hostname" >> /etc/hosts
yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://yum.theforeman.org/releases/1.15/el7/x86_64/foreman-release.rpm
yum -y install foreman-installer

foreman-installer --enable-foreman-compute-libvirt

systemctl stop firewalld
systemctl disable firewalld

ls /etc/puppetlabs/puppet/ssl/certs/$proxy_hostname.pem || \
  /opt/puppetlabs/bin/puppet cert generate $proxy_hostname
