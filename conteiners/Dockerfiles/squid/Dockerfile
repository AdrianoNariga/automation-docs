FROM debian

RUN apt update
RUN apt install squid3 -y \
 && mv /etc/squid3/squid.conf /etc/squid3/squid.conf.dist \
 && rm -rf /var/lib/apt/lists/*

COPY squid.conf /etc/squid3/squid.conf

EXPOSE 3128/tcp
CMD ["/usr/sbin/squid3"]
