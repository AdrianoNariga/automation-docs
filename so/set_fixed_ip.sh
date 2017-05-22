#!/bin/bash
get_so(){
        while test -n "$1"
        do
        case $1 in
                -s | --operatingsystem)
                        grep PRETTY_NAME= /etc/os-release | cut -d \" -f 2 | awk '{print $1}'
                ;;
                -v | --version)
                        grep VERSION_ID= /etc/os-release | cut -d \" -f2
                ;;
                *) echo "opcao invalida"
        esac
        shift
        done
}

centos_ip(){
	ipaddr=$(ip -o -4 a s $(ip r s | grep default | awk '{print $5}' | head -n1) | awk '{print $4}' | cut -d \/ -f 1)
	iface=$(ip -o -4 a s|grep "$ipaddr" | awk '{print $2}')
	cid=$(ip -o -4 a s|grep "$ipaddr" | awk '{print $4}' |cut -d / -f 2)
	gw=$(ip r s | grep ^default | awk '{print $3}')
	dns=$(grep nameserver /etc/resolv.conf | head -n1 | awk '{print $2}')

cat > /etc/sysconfig/network-scripts/ifcfg-$iface << EOF
BOOTPROTO=static
IPADDR=$ipaddr
CID=$cid
DEVICE=$iface
ONBOOT=yes
TYPE=Ethernet
NAME="System $iface"
GATEWAY=$gw
DNS1=$dns
DNS2=8.8.8.8
EOF

}

ubuntu_ip(){
cat > /etc/network/interfaces << EOF
auto lo
iface lo inet loopback

auto $1
allow-hotplug $1
iface $1 inet static
        address $2
        netmask $3
        dns-nameservers 8.8.8.8 8.8.4.4
        dns-namesearch home.jab
EOF
}

case `get_so -s` in
        Debian) ubuntu_ip ;;
        Ubuntu) ubuntu_ip ;;
        CentOS) centos_ip ;;
esac
