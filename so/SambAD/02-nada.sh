#!/bin/bash
admin='Home@2018'

source config/named.conf

#/usr/local/samba/bin/samba-tool domain provision --use-rfc2307 \
#       --interactive

/usr/local/samba/bin/samba-tool \
        domain provision \
        --domain=$(hostname -d | cut -d . -f 1 | tr 'a-z' 'A-Z') \
        --realm=$(hostname -d | tr 'a-z' 'A-Z') \
        --adminpass=$adminpass \
        --dns-backend=BIND9_DLZ \
        --server-role=dc \
        --use-rfc2307

source config/samba.systemd
rm -f /etc/krb5.conf
cp /usr/local/samba/private/krb5.conf /etc/krb5.conf
chown root.named /etc/krb5.conf

chgrp named /usr/local/samba/private/dns.keytab
chmod g+r /usr/local/samba/private/dns.keytab
systemctl restart named
/usr/local/samba/sbin/samba_dnsupdate --verbose

kinit administrator
