#!/bin/bash
foreman_hostname=foreman.local
ip_foreman=192.168.111.100

proxy_hostname=puppet.local
ip_proxy=192.168.111.102

yum install -y dos2unix
hostnamectl set-hostname $proxy_hostname
ls ~/.ssh/id_rsa.pub || ssh-keygen
ssh-copy-id root@$ip_foreman
ssh -t $ip_foreman "grep $proxy_hostname /etc/hosts || echo \"$ip_proxy $proxy_hostname\" >> /etc/hosts"
ssh -t $ip_foreman "ls /etc/puppetlabs/puppet/ssl/certs/$proxy_hostname.pem || /opt/puppetlabs/bin/puppet cert generate $proxy_hostname"

mkdir -p /etc/puppetlabs/puppet/ssl/certs/
mkdir -p /etc/puppetlabs/puppet/ssl/private_keys/
scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/certs/ca.pem \
  /etc/puppetlabs/puppet/ssl/certs/ca.pem
scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/certs/$proxy_hostname.pem \
  /etc/puppetlabs/puppet/ssl/certs/$proxy_hostname.pem
scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/private_keys/$proxy_hostname.pem \
  /etc/puppetlabs/puppet/ssl/private_keys/$proxy_hostname.pem

consumer_key="$(ssh -t $ip_foreman 'foreman-installer --help | grep foreman-proxy-oauth-consumer-key | cut -d \" -f 2' | dos2unix)"
consumer_secret="$(ssh -t $ip_foreman 'foreman-installer --help | grep foreman-proxy-oauth-consumer-secret | cut -d \" -f 2' | dos2unix)"

grep $foreman_hostname /etc/hosts || echo "$ip_foreman $foreman_hostname foreman" >> /etc/hosts
grep $proxy_hostname /etc/hosts || echo "$ip_proxy $proxy_hostname proxy" >> /etc/hosts
yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://yum.theforeman.org/releases/1.15/el7/x86_64/foreman-release.rpm
yum -y install foreman-installer
setenforce permissive
systemctl stop firewalld
systemctl disable firewalld

foreman-installer \
  --no-enable-foreman \
  --no-enable-foreman-cli \
  --no-enable-foreman-plugin-bootdisk \
  --no-enable-foreman-plugin-setup \
  --foreman-proxy-tftp=false \
  --puppet-server-ca=false \
  --foreman-proxy-puppetca=false \
  --enable-puppet --enable-foreman-proxy \
  --foreman-proxy-trusted-hosts=$foreman_hostname \
  --foreman-proxy-trusted-hosts=$proxy_hostname \
  --puppet-ca-server=$foreman_hostname \
  --foreman-proxy-foreman-base-url=https://$foreman_hostname \
  --foreman-proxy-oauth-consumer-key="$consumer_key" \
  --foreman-proxy-oauth-consumer-secret="$consumer_secret"
