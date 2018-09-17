#!/bin/bash
apt-get install cloud-init sudo -y
sed -i.bak 's/admin/administrator/g' /etc/cloud/cloud.cfg
sed -i.bak 's/#UseDNS no/UseDNS no/g' /etc/ssh/sshd_config
