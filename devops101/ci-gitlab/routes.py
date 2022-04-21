from flask import jsonify

def create_routes(app):
    @app.route("/")
    def hello_world():
        return jsonify( message = "hellow" )
