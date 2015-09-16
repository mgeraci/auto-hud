# Auto-HUD
Auto HUD is an application to power a heads up display meant for mounting behind
a 2-way mirror. It's `auto` because bumping a version number on the server will
trigger a client-side refresh (so you don't have to go fetch your display from
behind the mirror and hit "refresh").

The server is written with python and flask, and the client is written with Sass
and CoffeeScript, with Underscore templating.

## Running the app
The backend is written in python, and uses flask as the server. Dependencies are
listed in requirements.txt. You can `pip-install` them into a fresh Python
virtual environment. Assuming that you already have pip, virtualenv, and
virtualenvwrapper installed, run the following in the project root:

```
mkvirtualenv auto-hud
workon auto-hud
pip install -r requirements.txt
```

Then, to start the server, run `python auto-hud.py`.

## Static files
Static files are compiled with gulp, a node.js based build system). You'll need
node and gulp installed, and then you can run `npm install` in the project root
to install the packages required to compile Auto-HUD's frontend files. Just run
`gulp` in the project root to watch for Sass and CoffeeScript changes.

## Local configuration file
To run, Auto-HUD requires a file called `localsettings.py` in the project root.
This file contains "secret" settings, like birthdays and API keys. Here is an
example `localsettings.py` file:

```.py
# change this number to trigger the client to reload. use if you want to hot
# swap the css, js, or templates
VERSION = "0.000"

# your info for forecast.io
FORECASTIO_API_KEY = "<your api key>"
FORECASTIO_LAT_LONG = "40.676423,-73.980488"

# add birthdays with a tuple of (month, day) as a key, and a list of people and
# their birthyears as the value. accepts multiple people on the same day. years
# are optional.
BIRTHDAYS = {
		(2, 10): [
				{
						'name': 'Edith Clarke',
						'year': 1883
				},
				{
						# Ms. Conwell's birthday is actually May 23, but I changed it here
						# to show how to have multiple people can share a birthday.
						'name': 'Esther M. Conwell'
				}
		],
		(12, 9): [
				{
						'name': 'Grace Hopper',
						'year': 1906
				}
		]
}

# Chores module configuration. Each day gets an array of chores, where each
# chore is a dictionary with the following values:
# - text (str, required): description of the chore that will display
# - icon (str, optional): if present, an icon span will print with this class
# - time_range (tuple, optional): a start hour (inclusive) and end hour
#     (exclusive) during which to display the chore
CHORES = {
    'Monday': [
    ],
    'Tuesday': [
        {
            'text': 'Take out recycling tonight',
            'icon': 'recycling'
        }
    ],
    'Wednesday': [
    ],
    'Thursday': [
        {
            'text': 'Take out recycling tonight',
            'icon': 'recycling'
        }
        {
            'text': 'Today is laundry day!',
            'icon': 'laundry'
        }
    ],
    'Friday': [
    ],
    'Saturday': [
    ],
    'Sunday': [
    ],
}
```
