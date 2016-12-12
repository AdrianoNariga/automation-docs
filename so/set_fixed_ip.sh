#!/bin/bash

centos_ip(){
cat > /etc/sysconfig/network-scripts/ifcfg-$1 << EOF
BOOTPROTO=static
IPADDR=$2
NETMASK=$3
DEVICE=$1
ONBOOT=yes
TYPE=Ethernet
NAME="System $1"
DNS1=8.8.8.8
DNS2=8.8.4.4
#8.8.8.8
EOF
}

while test -n "$1"
do
        case $1 in
                -h | --help)
			echo "$0 iface ip_fixo netmask"
			echo "Exemplo....."
			echo "$0 eth1 192.168.0.0 255.255.255.0"
                ;;
		*)
			centos_ip $1 $2 $3
        esac

        shift
done
