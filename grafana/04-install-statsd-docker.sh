#!/bin/bash
docker run -d --name graphite --restart=always -p 81:81 -p 8125:8225/udp hopsoft/graphite-statsd
