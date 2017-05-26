#!/bin/bash
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
