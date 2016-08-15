FROM debian
MAINTAINER NarigaCDO "narigacdo@gmail.com"

RUN apt update
RUN apt install apache2 -y
RUN apt-get clean all
RUN rm -rf /var/www/html

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
