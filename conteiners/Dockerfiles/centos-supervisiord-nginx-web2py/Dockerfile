FROM centos

RUN yum install epel-release -y
RUN yum install nginx wget python-setuptools unzip -y
RUN wget -P /root http://www.web2py.com/examples/static/web2py_src.zip
RUN easy_install supervisor
RUN echo_supervisord_conf > /etc/supervisor/supervisord.conf
RUN /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
