#!/bin/bash
ls -ld /opt/server-init/sh/ || mkdir -p /opt/server-init/sh/
ls -ld /opt/server-init/conf/ || mkdir -p /opt/server-init/conf/

cp iptables-firewall/iptables-nariga /opt/server-init/sh/iptables-nariga
cp iptables-firewall/fixed_roles /opt/server-init/sh/fixed_roles
cp route-add/make-routes /opt/server-init/sh/make-routes

cp iptables-firewall/ips_liberados /opt/server-init/conf/ips_liberados
cp iptables-firewall/redirects /opt/server-init/conf/redirects

cp server-init.service /etc/systemd/system/server-init.service
systemctl daemon-reload
systemctl enable server-init.service
