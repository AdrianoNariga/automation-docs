#!/bin/bash

##################################################################################
# instructions
##################################################################################
#   A. in hyper-v manager ensure Enhanced Sessions are allowed, may have to turn 
#      this off and then back on again
#   B. ensure that can connect ot vm guest using socket
#      run in windows host powershell
#        > Set-VM -vmname "<guest-vm-name>" -EnhancedSessionTransportType HvSocket

#  C. configure vm guest to connect to rdp
#     1. download from github/pjcrosbie/
#     2. execute this script on the target guest pop-os system
#          $ sudo bash install-hyperv-enhanced-session.bash
#     3. shutdown hyperv guest and restart

#  D. you should get resolution window, usually nicer to have fullscreen, can save 
#     settings for future sessions

#  E. if you save session settings you don't get resolution choice just rdp 
#     connect window

#  F. in full screen you get native resolution of display, on xps laptops with 
#     with UHD this will be too small to use so set scaling in at 200% to make
#     screen usuable (note the rdp login will remain in the full UHD (3840x2160)
#
# guest-vm-name should be ready to run now!
# 

################################################################################
# background
################################################################################

# see youtube:
#   a) [Install Pop!_OS on Hyper-V | Complete Guide 2021](https://www.youtube.com/watch?v=5JvUmBu3y84)
#   b) [Enable Enhanced Session for Pop!_OS or Ubuntu 20.04+ | Hyper-V Guide](https://www.youtube.com/watch?v=mveyMZrIOzc)
#   
# credit and src goes to:
#  https://gist.github.com/PAGuardado/eb82ffad8aebe0c3517cdcbe7a28bcd3


#
# This script is for Pop!_OS 20.04LTS to download and install XRDP+XORGXRDP via source.
#
# based on the following scripts:
# https://github.com/microsoft/linux-vm-tools/tree/master/ubuntu/18.04
# https://github.com/microsoft/linux-vm-tools/pull/106
# https://gist.github.com/phillipsj/a4b6e4a1070b4320ed19e061fe2dd83d
# https://gist.github.com/kaitwalla/9fbcef47c5ff2b58cd353ba3744be4e5
#

################################################################################
# script
################################################################################

# update and upgrade machine if needed.

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

apt update && apt upgrade -y

if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required in order to proceed with the install." >&2
    echo "Please reboot and re-run this script to finish the install." >&2
    exit 1
fi

###############################################################################
# XRDP
#

# install hv_kvp utils
apt install -y linux-tools-virtual
apt install -y linux-cloud-tools-virtual

# Install the xrdp service so we have the auto start behavior.
apt install -y xrdp

systemctl stop xrdp
systemctl stop xrdp-sesman

# Configure the installed XRDP ini files.
# use vsock transport.
sed -i_orig -e 's/port=3389/port=vsock:\/\/-1:3389/g' /etc/xrdp/xrdp.ini

# use rdp security.
sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini

# remove encryption validation.
sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini

# disable bitmap compression since its local its much faster
sed -i_orig -e 's/bitmap_compression=true/bitmap_compression=false/g' /etc/xrdp/xrdp.ini


# Add script to setup the Pop!_OS session properly
if [ ! -e /etc/xrdp/startpop.sh ]; then
cat >> /etc/xrdp/startpop.sh << EOF

#!/bin/sh
export GNOME_SHELL_SESSION_MODE=pop
export XDG_CURRENT_DESKTOP=pop:GNOME
exec /etc/xrdp/startwm.sh
EOF
chmod a+x /etc/xrdp/startpop.sh
fi

# use the script to setup the pop session
sed -i_orig -e 's/startwm/startpop/g' /etc/xrdp/sesman.ini

# rename the redirected drives to 'shared-drives'
sed -i -e 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' /etc/xrdp/sesman.ini

# Changed the allowed_users
sed -i_orig -e 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config

# Blacklist the vmw module
if [ ! -e /etc/modprobe.d/blacklist_vmw_vsock_vmci_transport.conf ]; then
cat >> /etc/modprobe.d/blacklist_vmw_vsock_vmci_transport.conf <<EOF
blacklist vmw_vsock_vmci_transport
EOF
fi

#Ensure hv_sock gets loaded
if [ ! -e /etc/modules-load.d/hv_sock.conf ]; then
echo "hv_sock" > /etc/modules-load.d/hv_sock.conf
fi
# Configure the policy xrdp session
cat > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla <<EOF
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

# reconfigure the service
systemctl daemon-reload
systemctl start xrdp

#
# End XRDP
###############################################################################

echo "Install is complete."
echo "Reboot your machine to begin using XRDP."
