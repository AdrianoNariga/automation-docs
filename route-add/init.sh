#!/bin/bash

arquivo_rotas="/opt/server-init/route-add/routes"
ips_liberados="/opt/server-init/iptables-firewall/ips_liberados"
ips_redirects="/opt/server-init/iptables-firewall/redirects"

echo "Criando rotas"
bash /opt/server-init/route-add/make-routes $arquivo_rotas
route -n

echo "Criando regras"
bash /opt/server-init/iptables-firewall/iptables-nariga $ips_liberados $ips_redirects
