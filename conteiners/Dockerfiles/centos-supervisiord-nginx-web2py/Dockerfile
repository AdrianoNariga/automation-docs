FROM centos

RUN yum install epel-release -y
RUN yum install nginx wget python-setuptools unzip -y
RUN wget -P /root http://www.web2py.com/examples/static/web2py_src.zip
RUN mkdir -p /var/www
RUN unzip /root/web2py_src.zip -d /var/www
RUN rm -f /root/web2py_src.zip
RUN easy_install supervisor
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN yum clean all

LABEL description="sn_web2py"

EXPOSE 80

ENTRYPOINT python /var/www/web2py/web2py.py -i 0.0.0.0 -p 80 -a nada@nada &
