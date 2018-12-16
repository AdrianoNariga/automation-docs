#!/bin/bash
get_so(){
        while test -n "$1"
        do
        case $1 in
                -s | --operatingsystem)
                        grep PRETTY_NAME= /etc/os-release | cut -d \" -f 2 | awk '{print $1}'
                ;;
                -v | --version)
                        grep VERSION_ID= /etc/os-release | cut -d \" -f2
                ;;
                *) echo "opcao invalida"
        esac
        shift
        done
}

install_pip(){

	if [ `get_so -v` = "18.04" ]
	then
		python3.6 -m venv /root/.ansible
	else
		virtualenv /root/.ansible
	fi

}

debian(){
	echo 1
}

ubuntu18(){
	echo 2
}

centos(){
	yum -y install http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
	yum install -y zabbix-agent
	sed -i 's/Server=127.0.0.1/Server=192.168.111.3/g' /etc/zabbix/zabbix_agentd.conf
	sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.111.3/g' /etc/zabbix/zabbix_agentd.conf

	systemctl start zabbix-agent
	systemctl enable zabbix-agent
}

case `get_so -s` in
        elementary|Debian) debian ;;
	Ubuntu)
		case `get_so -v` in
			18.04) ubuntu18 ;;
			*) debian ;;
		esac
		;;
        CentOS) centos ;;
        Red) centos ;;
esac
