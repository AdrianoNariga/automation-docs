#!/bin/bash
curl -sL https://deb.nodesource.com/setup_6.x | bash -
apt install -y nodejs git
git clone git://github.com/etsy/statsd.git /opt/statsd
cat >> /opt/statsd/localConfig.js << EOF
{
graphitePort:2003,
graphiteHost:'127.0.0.1',
port:8125
}
EOF

systemctl restart carbon-cache

node /opt/statsd/stats.js /opt/statsd/localConfig.js
