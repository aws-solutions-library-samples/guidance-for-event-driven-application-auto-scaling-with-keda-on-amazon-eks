from flask import Flask, jsonify
from prometheus_client import make_wsgi_app, Counter
from werkzeug.middleware.dispatcher import DispatcherMiddleware

app = Flask(__name__)

app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})
REQUEST_COUNT = Counter(
    'app_request_count',
    'Application Request Count',
    ['http_method', 'http_status']
)


@app.route('/')
def hello():
    REQUEST_COUNT.labels('GET', 200).inc()
    response = jsonify(message='Hey There!')
    return response


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
