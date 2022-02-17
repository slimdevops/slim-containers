#!/usr/bin/env python3
from flask import Flask, jsonify, make_response, request, send_file
from markupsafe import escape
from werkzeug.utils import secure_filename
import os
# import sqlite3
from flask_cors import CORS
import psycopg2

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = 'static/images'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
DB_UP = False

conn = psycopg2.connect('dbname=photos user=docker password=test host=database')
cur= conn.cursor()
cur.execute('''CREATE TABLE IF NOT EXISTS public.images
            (date text, image_name text, category text)''' )
cur.close()
conn.close()
DB_UP = True

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/')
def index():
    """Endpoint to root on the server."""
    msg = "Backend is ready. DB Status: %s" % DB_UP
    message = jsonify(success=msg)
    return make_response(message, 200)


@app.route('/images/', methods=['GET'])
def images():
    """Endpoint to list images on the server."""
    files = []
    # get files from db 
    conn = psycopg2.connect('dbname=photos user=docker password=test host=database')
    cur = conn.cursor()
    cur.execute('''select * from public.images limit 100''')
    results = cur.fetchall()
    files = [r for r in results] 
    print(files)
    cur.close()
    conn.close()

    # DEBUGGING: Load files from static dir 
    # for file in os.listdir(UPLOAD_FOLDER):
    #     filepath = os.path.join(UPLOAD_FOLDER, file)
    #     if os.path.isfile(filepath) and allowed_file(filepath):
    #         files.append(f"image/{escape(file)}")
    message = jsonify(images=files)
    return make_response(message, 200)


@app.route('/image/<image>', methods=['GET'])
def get_image(image):
    """Endpoint to return an image from the server."""
    # filename = os.path.join(UPLOAD_FOLDER, f"{escape(image)}")
    filename = os.path.join(UPLOAD_FOLDER, image)
    return send_file(filename)


@app.route('/upload', methods=['POST'])
def upload():
    """
    Endpoint to upload an image to the server.
    curl -i -X POST -H "Content-Type: multipart/form-data" -F "pic=@test.jpg" http://0.0.0.0:5000/upload/
    """
    print(vars(request))
    if 'pic' not in request.files:
        message = jsonify(fail='No image provided')
        return make_response(message, 400)
    file = request.files['pic']

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(UPLOAD_FOLDER, filename))

        # database methods here
        category = request.form.get('cat')
        conn = psycopg2.connect('dbname=photos user=docker password=test host=database')
        cur = conn.cursor()
        cur.execute('''INSERT INTO public.images VALUES (%s,%s,%s)''',('2021-09-16', filename, category))
        cur.close()
        conn.close()
        message = jsonify(success=f"{file.filename}")
        return make_response(message, 200)
    else:
        message = jsonify(fail=f"Invalid file type: {file.filename}")
        return make_response(message, 400)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
