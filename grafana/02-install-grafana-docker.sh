#!/bin/bash
## enable turn windows features on or off
## Hyper-V 
## docker.com -> Register now -> Products -> Docker Desktop
## Reboot Windows
## Open CMD Windows
docker --version
docker run --name grafana -d -p 3000:3000 grafana/grafana
## Pass: admin admin
