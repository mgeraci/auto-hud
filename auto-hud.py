from flask import Flask
from flask import render_template
from flask import jsonify
from flask import request
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/data")
def data():
    d = datetime.now()

    data = {}
    data["time"] = d.strftime("%H:%M")
    data["date"] = d.strftime("%B %-d, %Y")

    return jsonify(data)

if __name__ == "__main__":
    app.run(debug=True)
