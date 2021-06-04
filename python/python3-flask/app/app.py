# app.py
# created by Slim.AI for Container of the Week
# check us out on Twitch at twitch.tv/SlimDevOps

from flask import Flask, jsonify

app = Flask(__name__)
app.config['DEBUG'] = True

@app.route('/')
def index(): 
    return jsonify({'msg': 'Success!'}) 


if __name__ == "__main__": 
    app.run(host='0.0.0.0', port=1300) 