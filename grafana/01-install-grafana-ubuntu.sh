#!/bin/bash
apt install -y wget
# https://grafana.com/grafana/download
wget -O /root/grafana.deb https://dl.grafana.com/oss/release/grafana_6.3.6_amd64.deb
dpkg -i /root/grafana.deb
apt -f install
systemctl start grafana-server
systemctl enable grafana-server
