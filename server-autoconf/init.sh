#!/bin/bash
sh_dir="/opt/server-init/sh/"
conf_dir="/opt/server-init/conf/"

arquivo_rotas="$conf_dir/routes"
ips_liberados="$conf_dir/ips_liberados"
ips_redirects="$conf_dir/redirects"

echo "Criando rotas"
bash $sh_dir/make-routes $arquivo_rotas

echo "Criando regras"
bash $sh_dir/iptables-nariga $ips_liberados $ips_redirects
bash $sh_dir/fixed_roles
