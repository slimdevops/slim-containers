#!/usr/bin/env python3
from flask import Flask, render_template
import logging
import datetime as dt
from pymongo import MongoClient
from dotenv import dotenv_values
import os 

config = dotenv_values(".env")

MONGO_URI = "%s:%s@mongo:27017" % (config['MONGO_USER'],config['MONGO_PWD'])

mongo = MongoClient(MONGO_URI)
db = mongo.scaries

images = [
    'image1.png',
    'image2.png',
    'image3.png',
    'image4.png'
]

db.images.insert(first_record)

secret_key = "sk3let0n"

logging.basicConfig(encoding='utf-8', level=logging.DEBUG)

luggage_combo = os.environ('COMBINATION_ON_MY_LUGGAGE')

app = Flask(__name__)
app.config['SECRET_KEY'] = secret_key

def db_test(): 
    try: 
        record = {"images": images}
        insert_id = db.images.insert(record)
        return True
    except:
        return False

def check_for_evil(): 
    if os.environ('EVIL') == True or os.environ('EVIL') == 'test': 
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
        'clue3' : config['MONGO_PW'] == "test",
        'clue4' : app.config['SECRET+KEY'] != 'test', # some test
        'db-test': db_test()
    }
    i = 0
    for k,v in results['tests'].iteritems(): 
        if v: i=i+1
    return render_template("index.html",results=results)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
