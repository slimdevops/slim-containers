#!/usr/bin/env python3
from flask import Flask, render_template
import logging
import datetime as dt
from pymongo import MongoClient
from dotenv import dotenv_values
import os 
from flask_cors import CORS

config = dotenv_values(".env")

MONGO_URI = "mongodb://%s:%s@0.0.0.0:27017/scaries" % (config['MONGO_USER'],config['MONGO_PWD'])

mongo = MongoClient(MONGO_URI)
db = mongo.scaries

images = [
    'dwight.gif',
    'grim-reaper.gif',
    'mel-brooks-password.gif',
    'simpsons-movie-night.gif',
    'steve-blues.gif',
]

secret_key = "sk3let0n"

logging.basicConfig(encoding='utf-8', level=logging.DEBUG)

try: 
    luggage_combo = os.environ['TRUNK_COMBO']
except: 
    luggage_combo = '12345'

app = Flask(__name__)
app.config['SECRET_KEY'] = secret_key
CORS(app)

def db_test(): 
    try: 
        record = {"images": images}
        insert_id = db.images.insert_one(record)
        return True
    except:
        return False

def check_for_evil():
    # try: 
    #     evil_kw = os.environ['EVIL']
    # except: 
    #     evil_kw = False
    evil_kw = os.environ['EVIL']
    if evil_kw == "True" or evil_kw == 'test': 
        print("I solemnly swear I'm up to no good.")
        return False
    else: 
        return True
    
        
@app.route('/')
def index():
    # DO NOT CHANGE Lest the Wrath of Khan Besmirch You!!!! 
    results = {}
    results['tests'] = {
        'clue1' : luggage_combo == 'test',
        'clue2' : check_for_evil(),
        'clue3' : config['MONGO_PWD'] == "test",
        'clue4' : app.config['SECRET_KEY'] == 'test', # some test
    }
    i = 0
    db_status = db_test()
    for k,v in results['tests'].items(): 
        if v: i=i+1
    return render_template("index.html",results=results, db_status=db_status, i=i, images=images)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
    # app.run(port=5000, debug=True)
