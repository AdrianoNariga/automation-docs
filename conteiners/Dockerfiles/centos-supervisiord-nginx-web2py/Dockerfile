FROM centos

RUN yum install epel-release -y
RUN yum install nginx wget python-setuptools unzip python-devel python-gunicorn -y
RUN wget -P /root http://www.web2py.com/examples/static/web2py_src.zip
RUN mkdir -p /var/www
RUN unzip /root/web2py_src.zip -d /var/www
ADD cloudportal/gunicorn.conf.py /var/www/web2py/gunicorn.conf.py
#ADD cloudportal/ssl /var/www/web2py/ssl
ADD ssl /var/www/web2py/ssl
RUN rm -f /root/web2py_src.zip
RUN easy_install supervisor
ADD cloudportal/supervisord.conf /etc/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD cloudportal/web2py.conf /etc/nginx/conf.d/web2py.conf
RUN yum clean all

LABEL description="sn_web2py"

ENTRYPOINT python /var/www/web2py/web2py.py \
	-i 0.0.0.0 -p 443 -a nada@nada \
	-c /var/www/web2py/ssl/public.pem \
	-k /var/www/web2py/ssl/private.key
#ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
