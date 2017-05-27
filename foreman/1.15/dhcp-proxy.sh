#!/bin/bash
range="192.168.11.2 192.168.11.13"
dns="192.168.11.14,8.8.8.8"
gateway=192.168.11.1
dhcp_iface=eth1

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
	  --foreman-proxy-dhcp-interface=$dhcp_iface \
	  --foreman-proxy-dhcp-gateway=$gateway \
	  --foreman-proxy-dhcp-range="$range" \
	  --foreman-proxy-dhcp-nameservers="$dns"
}

dhcp_proxy
