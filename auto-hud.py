from flask import Flask
from flask import render_template
from flask import jsonify
from flask import request
from datetime import datetime

version = "0.002"

app = Flask(__name__)

@app.route("/")
def index(params={}):
    return render_template("index.html", params = {
      "version": version
    })

@app.route("/data")
def data():
    d = datetime.now()

    data = {}
    data["version"] = version
    data["time"] = d.strftime("%H:%M")
    data["date"] = d.strftime("%B %-d, %Y")

    return jsonify(data)

if __name__ == "__main__":
    app.run(debug=True)
