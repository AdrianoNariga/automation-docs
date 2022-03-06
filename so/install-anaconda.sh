#!/bin/bash
apt update
apt install curl wget -y

wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh \
	-O /tmp/anaconda.sh
bash /tmp/anaconda.sh -b -p /opt/anaconda

groupadd anaconda
chgrp -R anaconda /opt/anaconda
chmod 770 -R /opt/anaconda
adduser nariga anaconda
