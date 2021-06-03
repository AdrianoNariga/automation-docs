#!/bin/bash
apt update
pacotes="flatpak docker.io git vim htop openssh-server linux-headers-$(uname -r) 
gnome-tweak-tool guake barrier vlc apt-transport-https curl ca-certificates 
gnupg nmap curl tmux screen wget telnet tcpdump add-apt-repository 
python3-cinderclient python3-glanceclient python3-neutronclient 
python3-novaclient python3-openstackclient"

for i in $pacotes
do
	apt install -y $i
done

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
echo 'deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main' > \
	        /etc/apt/sources.list.d/google-cloud-sdk.list

echo 'deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian hirsute contrib' > /etc/apt/sources.list.d/virtualbox.list
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
	        gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ hirsute main" | \
	        tee /etc/apt/sources.list.d/azure-cli.list

systemctl disable cups.path cups-browsed.service cups.service libvirt-guests.service openvpn.service cups.socket
grupos="administrator adm cdrom sudo dip plugdev lpadmin lxd sambashare"

useradd -s /bin/bash -c "Adriano Nariga" -g users -m -u 1001 nariga
usermod -p '$1$3janKNz4$OcQVkwwnDGPvTVEGWDE0V1' nariga

for i in $grupos
do
        gpasswd -a nariga $i
done

echo 'nariga  ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nariga

add-apt-repository ppa:linrunner/tlp
apt update
apt install -y tlp tlp-rdw tp-smapi-dkms acpi-call-dkms google-cloud-sdk azure-cli

grep vmx /proc/cpuinfo && {
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
	apt update
	apt install -y virtualbox-6.1
}

curl -sL https://aka.ms/InstallAzureCLIDeb | bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists nuvola https://dl.tiliado.eu/flatpak/nuvola.flatpakrepo
flatpak update
flatpak install -y nuvola eu.tiliado.Nuvola
flatpak install -y nuvola eu.tiliado.NuvolaAppYoutube
flatpak install -y nuvola eu.tiliado.NuvolaAppYoutubeMusic
apt autoremove -y
