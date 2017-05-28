#!/bin/bash
foreman_hostname=foreman.local
ip_foreman=192.168.111.100

proxy_hostname=192.168.111.101
foreman_proxy=proxy.local

# Pegar essas entradas no foreman server
# garantir o foreman server resolve o nome do proxy
#foreman-installer --help | grep oauth-consumer

hostnamectl set-hostname $foreman_proxy

grep $foreman_hostname /etc/hosts || echo "$ip_foreman $foreman_hostname foreman" >> /etc/hosts
grep $proxy_hostname /etc/hosts || echo "$ip_proxy $foreman_proxy proxy" >> /etc/hosts
yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://yum.theforeman.org/releases/1.15/el7/x86_64/foreman-release.rpm
yum -y install foreman-installer dos2unix
setenforce permissive
systemctl stop firewalld
systemctl disable firewalld

clear_proxy(){
	consumer_key="$(ssh -t $ip_foreman 'foreman-installer --help | grep foreman-proxy-oauth-consumer-key | cut -d \" -f 2' | dos2unix)"
	consumer_secret="$(ssh -t $ip_foreman 'foreman-installer --help | grep foreman-proxy-oauth-consumer-secret | cut -d \" -f 2' | dos2unix)"
	echo $consumer_key
	echo $consumer_secret
	foreman-installer \
	  --no-enable-foreman \
	  --no-enable-foreman-cli \
	  --no-enable-foreman-plugin-bootdisk \
	  --no-enable-foreman-plugin-setup \
	  --no-enable-puppet \
	  --enable-foreman-proxy \
	  --puppet-server=false \
	  --foreman-proxy-puppet=false \
	  --foreman-proxy-puppetca=false \
	  --foreman-proxy-tftp=false \
	  --foreman-proxy-trusted-hosts=$foreman_hostname \
	  --foreman-proxy-trusted-hosts=$HOSTNAME \
	  --foreman-proxy-foreman-base-url=https://$foreman_hostname \
	  --foreman-proxy-oauth-consumer-key=$consumer_key \
	  --foreman-proxy-oauth-consumer-secret=$consumer_secret
}

get_certs(){
	ls ~/.ssh/id_rsa.pub || ssh-keygen
	ssh-copy-id root@$ip_foreman
	mkdir -p /etc/puppetlabs/puppet/ssl/certs/
	mkdir -p /etc/puppetlabs/puppet/ssl/private_keys/
	scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/certs/ca.pem \
	  /etc/puppetlabs/puppet/ssl/certs/ca.pem
	scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/certs/$foreman_proxy.pem \
	  /etc/puppetlabs/puppet/ssl/certs/$foreman_proxy.pem
	scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/private_keys/$foreman_proxy.pem \
	  /etc/puppetlabs/puppet/ssl/private_keys/$foreman_proxy.pem
}
get_certs
clear_proxy
