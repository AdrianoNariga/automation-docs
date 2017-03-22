#!/bin/bash
source ~/stackrc
names='controller1 controller2 controller3 compute1'
for name in $names
do
        ironic node-create -n $name -d pxe_ssh -i ssh_username='root' \
		-i ssh_password='a1b2c3d4' \
		-i ssh_address='172.16.129.218' \
		-i ssh_virt_type=$virsh

        UUID=$(ironic node-list | grep $name | awk '{print $2}' | grep -v id)
        MAC=$(virsh -c qemu+ssh://root@172.16.129.218/system domiflist $name | grep pxe | awk '{print $5}')
        ironic  port-create -a "$MAC" -n "$UUID"
done

openstack baremetal configure boot

for name in $names
do
        openstack baremetal node manage $UUID
        openstack overcloud node introspect $UUID --provide
        openstack baremetal node set --property capabilities="profile:$type,boot_option:local" $UUID
done

