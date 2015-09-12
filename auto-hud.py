from flask import Flask
from flask import render_template
from flask import jsonify
from flask import request
from datetime import datetime

version = "0.001"

app = Flask(__name__)

@app.route("/")
def index_route(params={}):
    return render_template("index.html", params = {
      "version": version
    })

@app.route("/version")
def version_route():
    data = {}
    data["version"] = version

    return jsonify(data)

if __name__ == "__main__":
    app.run(debug=True)
