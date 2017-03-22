#!/bin/bash
useradd stack
usermod -p '$5$ErGmpUVP$k7x4lrYHXkcRYPY4JTH/GwCxzJFO9RdTuyNcil9o9Q0' stack
echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack
chmod 0440 /etc/sudoers.d/stack
chown -R stack. /home/stack
yum install -y virt-install python-tripleoclient rhosp-director-images rhosp-director-images-ipa
su - stack
