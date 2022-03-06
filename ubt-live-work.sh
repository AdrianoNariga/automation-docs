#!/bin/bash

cat > /etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu/ impish main restricted multiverse universe
deb http://security.ubuntu.com/ubuntu/ impish-security main restricted multiverse universe
deb http://archive.ubuntu.com/ubuntu/ impish-updates main restricted multiverse universe
EOF

apt update

apt install vim openssh-server curl dislocker barrier -y

mkdir -p /media/bitlocker
mkdir -p /media/bitlockermount

dislocker /dev/sda4 -u134266-246697-280346-203720-186230-046266-701019-656524 -- /media/bitlocker

barrierc -f --no-tray --debug INFO --name ubuntu [192.168.111.65]:24800
