from covidtrackapi import app
from flask import send_file, current_app, flash, send_from_directory, make_response
# from momedoapi import create_app

# app = create_app()

# Initiate the sw and manifest


@app.route('/manifest.json')
def manifest():
    return send_from_directory('static', filename='manifest.json')


@app.route('/service_worker.js')
def serviceworker():
    response = make_response(send_from_directory(
        'static', filename='service_worker.js'))
    response.headers['Content-Type'] = 'application/javascript'

    return response


# Initiate the favicon
@app.route('/favicon.ico')
def favicon():
    return send_from_directory('static', filename='favicon.ico')


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5800)
