from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def hello():
    return jsonify({"msg": "Hello, World!"})

if __name__ == "__main__": 
    app.run(port=5000,host="0.0.0.0")
