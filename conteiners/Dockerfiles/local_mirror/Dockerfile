# docker run -ti -h localmirror.home.jab \
#  -v /media/storage-00/local_repo/:/var/www/ \
#  -p 192.168.111.5:80:80 narigacdo/local_mirror
FROM debian
MAINTAINER NarigaCDO "narigacdo@gmail.com"

RUN apt update
RUN apt install apache2 -y
RUN apt-get clean all
RUN rm -rf /var/www/html

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
EXPOSE 443

CMD ls /var/run/apache2/apache2.pid && \
    rm -f /var/run/apache2/apache2.pid && \
    /usr/sbin/apache2ctl -D FOREGROUND || \
    /usr/sbin/apache2ctl -D FOREGROUND
