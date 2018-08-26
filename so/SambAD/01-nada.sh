#/bin/bash
version=4.8.3

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
