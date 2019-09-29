#!/bin/bash
apt install -y graphite-web graphite-carbon apache2 libapache2-mod-wsgi

sed 's/^#SECRET_KEY/SECRET_KEY = 'log key here'/g' /etc/graphite/local_settings.py
sed 's/^#TIME_ZONE/TIME_ZONE = 'America/Sao_Paulo'/g' /etc/graphite/local_settings.py
sed 's/^#TIME_ZONE/TIME_ZONE = 'America/Sao_Paulo'/g' /etc/graphite/local_settings.py

cd /usr/bin
django-admin migrate --settings=graphite.settings --run-syncdb

sed 's/^CARBON_CACHE=false/CARBON-CACHE=true/g' /etc/graphite/local_settings.py
systemctl start carbon-cache
systemctl enable carbon-cache
a2dissite 000-default

cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available

chmod 0755 /var/log/graphite/*
chown _graphite /var/log/graphite/*
chown _graphite. /var/lib/graphite/graphite.db

a2ensite apache2-graphite
systemctl restart apache2
