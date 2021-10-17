#!/bin/bash
apt install -y samba
mkdir -p /home/share
chmod 0777 /home/share

cat > /etc/samba/smb.conf << EOF
[global]
  unix charset = UTF-8
  workgroup = WORKGROUP
  bind interfaces only = yes

[Docs]
  path = /home/share
  writable = yes
  guest ok = yes
  guest only = yes
  create mode = 0777
  directory mode = 0777
EOF

chgrp sambashare /home/share
useradd -M -d /home/share/user1 -s /usr/sbin/nologin -G sambashare user1
mkdir /home/share/user1
chown user1:sambashare /home/share/user1
chmod 2770 /home/share/user1

smbpasswd -a user1
smbpasswd -e user1

useradd -M -d /home/share/smbadmin -s /usr/sbin/nologin -G sambashare smbadmin
mkdir /home/share/smbadmin
smbpasswd -a smbadmin
smbpasswd -e smbadmin
chown smbadmin:sambashare /home/share/smbadmin
chmod 2770 /home/share/smbadmin

cat > /etc/samba/smb.conf <<EOF
  [user1]
      path = /home/share/user1
      read only = no
      browseable = no
      force create mode = 0660
      force directory mode = 2770
      valid users = @user1 @sambashare
  [smbadmin]
      path = /home/share/smbadmin
      read only = no
      browseable = yes
      force create mode = 0660
      force directory mode = 2770
      valid users = @sambashare @smbadmin
EOF

systemctl restart smbd nmbd
apt -y install smbclient cifs-utils
