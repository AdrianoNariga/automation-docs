#!/bin/bash
mkdir ~/images
mkdir ~/templates
sudo yum install -y python-tripleoclient
sudo ln -s /usr/lib/systemd/system/docker-distribution.service /usr/lib/systemd/system/docker-registry.service

echo '
[DEFAULT]
image_path = /home/stack/images
local_ip = 192.0.2.1/24
network_gateway = 192.0.2.1
undercloud_public_vip = 192.0.2.2
undercloud_admin_vip = 192.0.2.3
local_interface = eth3
network_cidr = 192.0.2.0/24
dhcp_start = 192.0.2.5
dhcp_end = 192.0.2.24
inspection_interface = br-ctlplane
inspection_iprange = 192.0.2.100,192.0.2.120
[auth]' > ~/undercloud.conf

sudo ip l set up eth3
openstack undercloud install

sudo yum install -y virt-install

#names='controller1 controller2 controller3 compute1'
#for name in $names; do
#       qemu-img create -f qcow2 /var/disk/$name.qcow2 20G
#
#       if [ "$name" == "compute1" ]; then
#               ram=4096
#       else
#               ram=12288
#       fi
#
#       virt-install --name $name --ram $ram --vcpus 4 --network network=default,model=virtio \
#                --disk path=/var/disk/$name.qcow2,format=qcow2,device=disk,bus=virtio  \
#                --graphics type=vnc,listen=0.0.0.0 --os-type linux --os-variant rhl7.3
#done
