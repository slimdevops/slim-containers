#TODO: Volumes w/ Mongo in it 
#TODO: Readme

from flask import Flask, flash, redirect, url_for, render_template, request
from werkzeug.utils import secure_filename
import os 
import sqlite3 


app = Flask(__name__)
app.secret_key = 'slimdevops-seeeeekret-kee'

UPLOAD_FOLDER = 'static/images'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

try: 
    con = sqlite3.connect('data/image.db')
    cur= con.cursor()
    cur.execute('''CREATE TABLE images
               (date text, image_name text, category text)''' )
    cur.close()
    con.close()
except: 
    print("DB already created")


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index(): 
    # get images from local file
    images = os.listdir('static/images')
    print(images)
    return render_template('index.html', images=images)

@app.route('/upload',methods=['POST'])
def upload(): 
    if request.method == 'POST':
        if 'pic' not in request.files: 
            flash('No file part')
            return redirect('/')
        file = request.files['pic']

        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            
            # database methods here
            category = request.form.get('cat')
            # oid = coll.insert_one({'img_name': filename, 'category': category})
            con = sqlite3.connect('data/image.db')
            cur = con.cursor()
            cur.execute('''INSERT INTO images VALUES (?,?,?)''',('2021-09-16', filename, category))
            cur.close()
            con.close()
            flash('File uploaded successfully')

            return redirect('/')

        else:
            flash('Invalid file')
            return redirect('/')
    else:
        flash('Invalid method')

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5000)
