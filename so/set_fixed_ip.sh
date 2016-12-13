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
        dns-namesearch home$1
EOF
}

run(){

        case `get_so -s` in
                Debian) ubuntu_ip $1 $2 $3 ;;
                Ubuntu) ubuntu_ip $1 $2 $3 ;;
                CentOS) centos_ip $1 $2 $3 ;;
        esac
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
                        run $1 $2 $3
        esac

        shift
done
