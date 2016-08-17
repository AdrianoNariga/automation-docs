from flask import Flask
from redis import Redis
import os

host_redis = os.environ.get('HOST_REDIS')
host_redis = os.environ.get('PORT_REDIS')

app = Flask(__name__)
redis = Redis(host=host_redis, port=host_redis)

@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello world! %s times.' % redis.get('hits')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
