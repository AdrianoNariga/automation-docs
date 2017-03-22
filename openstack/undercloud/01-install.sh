#!/bin/bash
IFACE_UNDERCLOUD='eth3'

mkdir ~/images
mkdir ~/templates
sudo ln -s /usr/lib/systemd/system/docker-distribution.service /usr/lib/systemd/system/docker-registry.service

echo "
[DEFAULT]
image_path = /home/stack/images
local_ip = 192.0.2.1/24
network_gateway = 192.0.2.1
undercloud_public_vip = 192.0.2.2
undercloud_admin_vip = 192.0.2.3
local_interface = $IFACE_UNDERCLOUD
network_cidr = 192.0.2.0/24
dhcp_start = 192.0.2.5
dhcp_end = 192.0.2.24
inspection_interface = br-ctlplane
inspection_iprange = 192.0.2.100,192.0.2.120
[auth]" > ~/undercloud.conf

openstack undercloud install
cat ~/stackrc >> ~/.bashrc

source ~/stackrc
cd ~/images

files_unpack="
/usr/share/rhosp-director-images/overcloud-full-latest-10.0.tar
/usr/share/rhosp-director-images/ironic-python-agent-latest-10.0.tar
"
for i in $files_unpack
do
	tar -xvf $i
done

openstack overcloud image upload --image-path ~/images/
neutron subnet-update $(neutron subnet-list|awk '{print $2}'|grep -v id|xargs) \
	--dns-nameserver 8.8.8.8 --dns-nameserver 8.8.4.4
