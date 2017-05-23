#!/bin/bash
foreman_hostname=foreman.internal
ip_foreman=192.168.111.100
consumer_key="AthHX2kCeWXA7xaEkxHxDt36bwhkmsJ8"
consumer_secret="TiAgioyMawKwvFKagWkdabNY2cqk3Hrr"

proxy_hostname=192.168.111.101
foreman_proxy=proxy.internal

# Pegar essas entradas no foreman server
# garantir o foreman server resolve o nome do proxy
#foreman-installer --help | grep oauth-consumer

grep $foreman_hostname /etc/hosts || echo "$ip_foreman $foreman_hostname foreman" >> /etc/hosts
grep $proxy_hostname /etc/hosts || echo "$ip_proxy $foreman_proxy foreman" >> /etc/hosts
yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://yum.theforeman.org/releases/1.15/el7/x86_64/foreman-release.rpm
yum -y install foreman-installer
setenforce permissive

clear_proxy(){
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
  --foreman-proxy-foreman-base-url=https://$foreman_hostname \
  --foreman-proxy-trusted-hosts=$foreman_hostname \
  --foreman-proxy-trusted-hosts=$HOSTNAME \
  --foreman-proxy-foreman-base-url=https://$foreman_hostname \
  --foreman-proxy-oauth-consumer-key=$consumer_key \
  --foreman-proxy-oauth-consumer-secret=$consumer_secret
}

scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/certs/ca.pem /etc/puppetlabs/puppet/ssl/certs/ca.pem
scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/certs/foreman.internal.pem /etc/puppetlabs/puppet/ssl/certs/foreman.internal.pem
scp root@$ip_foreman:/etc/puppetlabs/puppet/ssl/private_keys/foreman.internal.pem /etc/puppetlabs/puppet/ssl/private_keys/foreman.internal.pem

dns_proxy(){
foreman-installer \
  --no-enable-foreman \
  --no-enable-foreman-cli \
  --no-enable-foreman-plugin-bootdisk \
  --no-enable-foreman-plugin-setup \
  --no-enable-puppet \
  --enable-foreman-proxy \
  --foreman-proxy-tftp=false \
  --foreman-proxy-puppet=false \
  --foreman-proxy-puppetca=false \
  --foreman-proxy-dns=true \
  --foreman-proxy-dns-interface=eth0 \
  --foreman-proxy-dns-zone=example.com \
  --foreman-proxy-dns-reverse=0.0.10.in-addr.arpa \
  --foreman-proxy-dns-forwarders=8.8.8.8 \
  --foreman-proxy-dns-forwarders=8.8.4.4 \
  --foreman-proxy-foreman-base-url=https://foreman.example.com \
  --foreman-proxy-trusted-hosts=foreman.example.com \
  --foreman-proxy-oauth-consumer-key=$consumer_key \
  --foreman-proxy-oauth-consumer-secret=$consumer_secret
}

dhcp_proxy(){
foreman-installer \
  --no-enable-foreman \
  --no-enable-foreman-cli \
  --no-enable-foreman-plugin-bootdisk \
  --no-enable-foreman-plugin-setup \
  --no-enable-puppet \
  --enable-foreman-proxy \
  --foreman-proxy-puppet=false \
  --foreman-proxy-puppetca=false \
  --foreman-proxy-tftp=false \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface=eth0 \
  --foreman-proxy-dhcp-gateway=10.0.0.1 \
  --foreman-proxy-dhcp-range="10.0.0.100 10.0.0.200" \
  --foreman-proxy-dhcp-nameservers="10.0.1.2,10.0.1.3" \
  --foreman-proxy-foreman-base-url=https://foreman.example.com \
  --foreman-proxy-trusted-hosts=foreman.example.com \
  --foreman-proxy-oauth-consumer-key=$consumer_key \
  --foreman-proxy-oauth-consumer-secret=$consumer_secret
}

clear_proxy
