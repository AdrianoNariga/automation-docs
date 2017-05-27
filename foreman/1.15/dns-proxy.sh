#!/bin/bash
dns_iface=eth1
zona_name="local"
reverse="11.168.192"
dns_forward="192.168.111.254"

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
	  --foreman-proxy-dns-interface=$dns_iface \
	  --foreman-proxy-dns-zone=$zona_name \
	  --foreman-proxy-dns-reverse=$reverse.in-addr.arpa \
	  --foreman-proxy-dns-forwarders=$dns_forward \
	  --foreman-proxy-dns-forwarders=8.8.4.4
}
dns_proxy
