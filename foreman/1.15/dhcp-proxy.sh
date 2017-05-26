#!/bin/bash
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
