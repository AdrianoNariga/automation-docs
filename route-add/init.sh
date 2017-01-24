#!/bin/bash

arquivo_rotas="route-add/routes"
ips_liberados="iptables-firewall/ips_liberados"
ips_redirects="iptables-firewall/redirects"

echo "Criando rotas"
bash route-add/make-routes $arquivo_rotas
route -n

echo "Criando regras"
bash iptables-firewall/iptables-nariga $ips_liberados $ips_redirects
iptables -nL FORWARD
iptables -t nat -nL PREROUTING
iptables -t nat -nL POSTROUTING
