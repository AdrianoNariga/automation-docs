FROM ubuntu:16.04
MAINTAINER NarigaCDO "narigacdo@gmail.com"

RUN apt update
RUN apt install apt-mirror -y
RUN apt-get clean all

ADD apt-mirror.conf /etc/apt/mirror.list

CMD /usr/bin/apt-mirror && \
    /media/mirror/var/clean.sh && \
    /media/mirror/var/clean.sh
