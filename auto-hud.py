from flask import Flask
from flask import render_template
from flask import jsonify
from flask import Response
from datetime import datetime
import requests

# secret settings
from localsettings import VERSION
from localsettings import BIRTHDAYS
from localsettings import CHORES
from localsettings import FORECASTIO_API_KEY
from localsettings import FORECASTIO_LAT_LONG

# general settings
from constants import C

app = Flask(__name__)

@app.route('/')
def index_route(params={}):
    today = datetime.today()

    return render_template('index.html', params = {
      'version': VERSION,
      'C': C,
      'forecastioApiKey': FORECASTIO_API_KEY,
      'forecastioLatLong': FORECASTIO_LAT_LONG,
    })

@app.route('/mta-service-status')
def mta_service_status():
    r = requests.get(C['subwayRemoteUrl'])
    return Response(r.text, mimetype='text/xml')

@app.route('/song')
def song():
    r = requests.get(C['songRemoteUrl'])
    return Response(r.text, mimetype='text/html')

@app.route('/birthdays')
def birthdays():
    today = datetime.today()
    today_index = (today.month, today.day)
    today_birthdays = BIRTHDAYS.get(today_index)
    year = today.year
    res = []
    birthday_postfixes = {
        0: 'th',
        1: 'st',
        2: 'nd',
        3: 'rd',
        4: 'th',
        5: 'th',
        6: 'th',
        7: 'th',
        8: 'th',
        9: 'th',
    }

    if today_birthdays != None:
        for birthday in today_birthdays:
            if birthday.get('year') != None:
              birthday['age'] = year - birthday['year']
              birthday['postfix'] = birthday_postfixes[birthday['age'] % 10]

        res = today_birthdays

    return jsonify({
        'birthdays': res
    })

@app.route('/chores')
def chores():
    today = datetime.today()
    res = []
    weekday = C['daysPy'][today.weekday()]
    weekday_chores = CHORES.get(weekday)

    if weekday_chores != None:
        for chore in weekday_chores:
            time_range = chore.get('time_range')

            # add this chore to the list if it either has no time range, or it
            # has a time range and is in range
            if time_range == None:
                res.append(chore)
            else:
                if today.hour >= time_range[0] and today.hour < time_range[1]:
                    res.append(chore)

    return jsonify({
        'chores': res
    })

@app.route('/version')
def version_route():
    return jsonify({
        'version': VERSION
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
