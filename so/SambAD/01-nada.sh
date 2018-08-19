#/bin/bash
version=4.8.3
current_dir=$(pwd)

cd ~
wget -c https://ftp.samba.org/pub/samba/stable/samba-${version}.tar.gz
tar xzvf samba-${version}.tar.gz -C /opt/
cd /opt/samba-${version}

echo "Executando configure"
sleep 3
./configure.developer || {
	echo "Error no configure"
	exit 1
}

echo "Compilando com make"
sleep 3
make || {
	echo "Error no make"
	exit 1
}

echo "Instalando binarios"
sleep 3
make install || {
	echo "Erro make install"
	exit 1
}

cd $current_dir
source config/named.conf

#/usr/local/samba/bin/samba-tool domain provision --use-rfc2307 \
#	--interactive

/usr/local/samba/bin/samba-tool \
	domain provision \
	--domain=$(hostname -d | cut -d . -f 1 | tr 'a-z' 'A-Z') \
	--realm=$(hostname -d | tr 'a-z' 'A-Z') \
	--adminpass='nada@nada' \
	--dns-backend=BIND9_DLZ \
	--server-role=dc \
	--use-rfc2307

source config/samba.systemd
rm -f /etc/krb5.conf
cp /usr/local/samba/private/krb5.conf /etc/krb5.conf
chgrp named /usr/local/samba/private/dns.keytab
chmod g+r /usr/local/samba/private/dns.keytab
/usr/local/samba/sbin/samba_dnsupdate --verbose
