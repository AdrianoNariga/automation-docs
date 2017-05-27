#!/bin/bash
tftp_server=192.168.11.14

foreman-installer \
  --foreman-proxy-tftp=true \
  --foreman-proxy-tftp-servername=$tftp_server
