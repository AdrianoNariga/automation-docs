#!/bin/bash

gluster_centos(){
	yum -y install centos-release-gluster38
	sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-Gluster-3.8.repo
	yum --enablerepo=centos-gluster38,epel -y install glusterfs-server
	systemctl start glusterd
	systemctl enable glusterd
	firewall-cmd --add-service=glusterfs --permanent
	firewall-cmd --reload
	yum -y install rpcbind
	systemctl start rpcbind
	systemctl enable rpcbind
	systemctl restart glusterd
	firewall-cmd --add-service={nfs,rpc-bind} --permanent
	firewall-cmd --reload
}

gluster_configure(){
	mkdir /glusterfs/distributed
	gluster peer probe node02
	gluster peer status
	gluster volume create vol_distributed transport tcp \
		node01:/glusterfs/distributed \
		node02:/glusterfs/distributed
	gluster volume start vol_distributed
	gluster volume info
}
