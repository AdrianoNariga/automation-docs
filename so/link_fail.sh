#!/bin/bash
# executar script passando os dois gateway e por ultimo um ip para ser monitorado
# bash link_fail.sh 192.168.22.1 192.168.111.1 8.8.8.8

gateway1=$1
gateway2=$2
ip_check=$3
ping -c3 $ip_check || {
	ip route del 0/0
	ip r a 0.0.0.0/0 via $gateway1
}
ping -c3 $ip_check || {
	ip route del 0/0
	ip r a 0.0.0.0/0 via $gateway2
}
