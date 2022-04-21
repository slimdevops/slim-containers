# totally full test coverage
import json
from flask import Flask
from routes import create_routes

def test_hello():
    app = Flask(__name__)
    create_routes(app)
    client = app.test_client()
    url = '/'

    response = client.get(url)
    data = json.loads(response.get_data(as_text=True))
    print(data)

    assert response.status_code == 200
    assert data['message'] == 'Backend is ready. DB Status: False'
