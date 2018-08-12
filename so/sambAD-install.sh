#!/bin/bash
yum -y groupinstall 'Development Tools'
yum -y install wget vim
yum -y install openldap-devel pam-devel git gcc make wget libacl-devel \
libblkid-devel gnutls-devel readline-devel python-devel cups-devel libaio-devel \
quota-devel ctdb-devel krb5-devel krb5-workstation acl \
setroubleshoot-server setroubleshoot-plugins policycoreutils-python \
libsemanage-python setools-libs-python setools-libs popt-devel libpcap-devel \
libidn-devel libxml2-devel libacl-devel libsepol-devel libattr-devel \
keyutils-libs-devel cyrus-sasl-devel cups-devel bind-utils bind-sdb bind-devel \
bind-libs bind avahi-devel mingw32-iconv gamin libcap-devel rpc2-devel \
glusterfs-devel python-dns pkgconfig gdb e2fsprogs-devel zlib-devel sqlite-devel \
perl attr acl krb5-user ntp bind bind-sdb

sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
setenforce permissive

iface=$(ip r s | grep default | awk '{print $5}')
ipadd=$(ip -o -4 a s $iface | awk '{print $4}' | cut -d / -f 1)
prefix=$(ip -o -4 a s $iface | awk '{print $4}' | cut -d / -f 2)
domain=$(hostname -d)
gateway=$(ip r s | grep default | awk '{print $3}')
cat > /etc/sysconfig/network-scripts/ifcfg-$iface << EOF
TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_FAILURE_FATAL=no
NAME=$iface
DEVICE=$iface
ONBOOT=yes
PEERDNS=no
PEERROUTES=yes
IPV6_PEERDNS=no
IPV6_PEERROUTES=no
IPADDR=$ipadd
GATEWAY=$gateway
PREFIX=$prefix
DNS1=$ipadd
DOMAIN=$domain
NM_CONTROLLED=no
USERCTL=no
EOF

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

cat > /etc/hosts << EOF
127.0.0.1 localhost localhost.localdomain
$ipadd $HOSTNAME $(hostname -s)
EOF

hostnamectl set-hostname $(hostname -s)

cat > /etc/sysconfig/network << EOF
NETWORKING=yes
HOSTNAME=$(hostname -s)
EOF

cat > /etc/resolv.conf << EOF
search $(hostname -d)
domain $(hostname -d)
nameserver $ipadd
nameserver 192.168.111.239
EOF

echo "Reinicie e check hostname e hostname -f"
echo "O resolv.conf nao deve mudar"
