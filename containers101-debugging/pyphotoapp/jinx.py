from flask import Flask, render_template

with open('/app/result.txt') as f:
    result = f.read()
    print(result)

app = Flask(__name__)

@app.route('/')
def index(): 
    return render_template('evil.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5000)