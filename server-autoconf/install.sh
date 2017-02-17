#!/bin/bash
install(){
	ls -ld /opt/server-init/sh/ || mkdir -p /opt/server-init/sh/
	ls -ld /opt/server-init/conf/ || mkdir -p /opt/server-init/conf/
	
	cp iptables-firewall/ips_liberados /opt/server-init/conf/ips_liberados
	cp iptables-firewall/redirects /opt/server-init/conf/redirects
	cp route-add/routes /opt/server-init/conf/routes
}

update(){
	cp iptables-firewall/iptables-nariga /opt/server-init/sh/iptables-nariga
	cp iptables-firewall/fixed_roles /opt/server-init/sh/fixed_roles
	cp route-add/make-routes /opt/server-init/sh/make-routes

	cp init.sh /opt/server-init/init.sh
	cp server-init.service /etc/systemd/system/server-init.service
	systemctl daemon-reload
	systemctl enable server-init.service
}

while test -n "$1"
do
        case $1 in
                -i | install)
			install
			update
                ;;
		-u | update)
			update
		;;
        esac

        shift
done
