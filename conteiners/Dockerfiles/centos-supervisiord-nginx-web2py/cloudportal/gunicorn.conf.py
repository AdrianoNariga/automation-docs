import multiprocessing

backlog = 2048
bind = "unix:/var/run/gunicorn.sock"
pidfile = "/var/run/gunicorn.pid"
daemon = False
debug = False
workers = 9
logfile = "/var/log/gunicorn.log"
loglevel = "info"
pythonpath = "/var/www/web2py"
