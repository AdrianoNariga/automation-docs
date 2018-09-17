#!/bin/bash
apt-get install cloud-init sudo -y
sed -i.bak 's/admin/administrator/g' /etc/cloud/cloud.cfg
sed -i.bak 's/#UseDNS no/UseDNS no/g' /etc/ssh/sshd_config
sed -i.bak 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
update-grub2
apt-get autoclean
apt-get clean autoclean
apt-get autoremove --yes
rm -rf /var/lib/{apt,dpkg,cache,log}/
rm -rf /var/log/apt/*
rm -rf /var/log/installer/*
> /var/log/alternatives.log
> /var/log/auth.log
> /var/log/dpkg.log
> /var/log/kern.log
> /var/log/syslog
cd
rm -rf /root/automation-all
history -cw
init 0
