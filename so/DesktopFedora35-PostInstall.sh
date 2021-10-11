#!/bin/bash
dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-35.noarch.rpm -y
dnf install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-35.noarch.rpm -y
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-35
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-35
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-multimedia.repo
dnf install 'https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm' -y

dnf install deltarpm -y
echo deltarpm=1 >> /etc/dnf/dnf.conf

dnf install gnome-tweaks chrome-gnome-shell openssh-server \
	tmux kernel-devel system-config-language -y

systemctl disable firewalld.service cups.path cups.service cups.socket
systemctl start sshd.service
systemctl enable sshd.service

dnf install cabextract lzip p7zip p7zip-plugins \
	unrar libdvdcss vlc kodi amrnb amrwb faad2 \
	flac ffmpeg gpac-libs lame libfc14audiodecoder \
	mencoder mplayer x264 x265 gstreamer-plugins-espeak \
	gstreamer-plugins-bad gstreamer-plugins-bad-nonfree \
	gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-plugins-base \
	gstreamer1-libav gstreamer1-plugins-bad-free-extras \
	gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools \
	gstreamer1-plugins-good-extras gstreamer1-plugins-ugly \
	gstreamer1-plugins-bad-free gstreamer1-plugins-good -y

useradd -s /bin/bash -c "Adriano Nariga" -g users -m -u 1001 nariga
usermod -p '$1$3janKNz4$OcQVkwwnDGPvTVEGWDE0V1' nariga
gpasswd -a nariga administrator
echo 'nariga  ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nariga

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists nuvola https://dl.tiliado.eu/flatpak/nuvola.flatpakrepo
flatpak update
flatpak install -y nuvola eu.tiliado.Nuvola
flatpak install -y nuvola eu.tiliado.NuvolaAppYoutube
flatpak install -y nuvola eu.tiliado.NuvolaAppYoutubeMusic
