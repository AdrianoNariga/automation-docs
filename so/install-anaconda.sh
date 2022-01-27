#!/bin/bash
apt update
apt install curl -y
cd /tmp

curl –O https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
bash Anaconda3-2021.11-Linux-x86_64.sh
