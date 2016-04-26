FROM centos

RUN yum install epel-release -y
RUN yum install nginx wget python-setuptools unzip python-devel -y
RUN easy_install pip
RUN pip install gunicorn supervisor

RUN wget -P /root http://www.web2py.com/examples/static/web2py_src.zip
RUN mkdir -p /var/www /var/log/supervisor
RUN unzip /root/web2py_src.zip -d /var/www
ADD cloudportal/gunicorn.conf.py /var/www/web2py/gunicorn.conf.py
ADD cloudportal/wsgihandler.py /var/www/web2py/wsgihandler.py
ADD ssl /var/www/web2py/ssl
RUN rm -f /root/web2py_src.zip
ADD cloudportal/supervisord.conf /etc/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD web2py.conf /etc/nginx/conf.d/web2py.conf
ADD start-web2py /etc/init.d/start-web2py
RUN yum clean all

LABEL description="sn_web2py"

ENTRYPOINT python /var/www/web2py/web2py.py \
	-i 0.0.0.0 -p 443 -a nada@nada \
	-c /var/www/web2py/ssl/public.pem \
	-k /var/www/web2py/ssl/private.key -Y
#ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
