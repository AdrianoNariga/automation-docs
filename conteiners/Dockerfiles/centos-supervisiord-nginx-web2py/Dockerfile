FROM centos

RUN yum install epel-release -y
RUN yum install nginx wget python-setuptools unzip -y
RUN wget -P /root http://www.web2py.com/examples/static/web2py_src.zip
RUN mkdir -p /var/www
RUN unzip /root/web2py_src.zip -d /var/www
RUN easy_install supervisor
RUN echo_supervisord_conf > /etc/supervisor/supervisord.conf
RUN /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

LABEL description="sn_web2py"
