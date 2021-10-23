#!/bin/bash
apt install -y samba smbclient cifs-utils

mkdir -p /home/public
chmod 2777 /home/public
chgrp sambashare /home/public

mkdir -p /home/share
chmod 2770 /home/share
chgrp sambashare /home/share
chown nariga:sambashare /home/share/

cat > /etc/samba/smb.conf << EOF
[global]
  unix charset = UTF-8
  workgroup = WORKGROUP
  bind interfaces only = yes

[public]
  path = /home/public/
  writable = yes
  guest ok = yes
  guest only = yes
  create mode = 0777
  directory mode = 0777

[share]
  path = /home/share/
  read only = no
  browseable = yes
  force create mode = 0660
  force directory mode = 2770
  valid users = @nariga @sambashare

[nariga]
  path = /home/nariga/
  read only = no
  browseable = no
  force create mode = 0660
  force directory mode = 2770
  valid users = @nariga @sambashare
EOF
systemctl restart smbd nmbd

pass=123
(echo "$pass"; echo "$pass") | smbpasswd -s -a nariga
smbpasswd -e nariga
gpasswd -a nariga sambashare
