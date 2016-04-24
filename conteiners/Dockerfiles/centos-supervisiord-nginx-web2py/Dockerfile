FROM centos

RUN yum install epel-release -y
RUN yum install nginx wget python-setuptools unzip -y
RUN wget -P /root http://www.web2py.com/examples/static/web2py_src.zip
RUN mkdir -p /var/www
RUN unzip /root/web2py_src.zip -d /var/www
RUN rm -f /root/web2py_src.zip
RUN easy_install supervisor
RUN echo_supervisord_conf > /etc/supervisord.conf

LABEL description="sn_web2py"
