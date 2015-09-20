# Auto HUD
Auto HUD is an application to power a heads up display meant for mounting behind
a 2-way mirror. It's `auto` because bumping a version number on the server will
trigger a client-side refresh (so you don't have to go fetch your display from
behind the mirror and hit "refresh").

The server is written with python and flask, and the client is written with Sass
and CoffeeScript, with Underscore templating.

This project was inspired by Hannah Mittelstaedt's awesome
[HomeMirror](https://github.com/HannahMitt/HomeMirror).

## Contents
* [Running the app](#running-the-app)
* [Configuration](#configuration)
	* [localsettings.py](#localsettingspy)
	* [constants.py](#constantspy)
* [Static files](#static-files)

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

Then, to start the server, run `python auto-hud.py`. But you'll need to add a
configuration file before it starts up. What configuration file? Glad you asked.

## Configuration
Auto HUD requires two configuration files in the project root to run,
`localsettings.py` and `constants.py`. Localsettings contains personal sitewide
settings, like api keys and birthdays. Constants contains non-sensitive
sitewide settings, like the order of modules.

### localsettings.py
Here is an example `localsettings.py` file:

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
        },
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

### constants.py
If you'd like to modify the app, you may consider changing a definition in
`constants.py`. Some of the more interesting constants, and their defaults,
are:

```
# list your modules here. the order determines the display.
'sections': [
		'time',
		'weather',
		'birthdays',
		'chores',
		'subway',
		'noConnection',
],

# how frequently to update the weather
'weatherPollTime': 1000 * 60 * 5,

# there's also birthdaysPollTime, choresPollTime, and subwayPollTime

# indicate which subway lines you wish to display with a `1`
'subwayLinesToShow': {
		'7':    0,
		'123':  0,
		'456':  0,
		'ACE':  0,
		'BDFM': 1,
		'G':    0,
		'JZ':   0,
		'L':    0,
		'NQR':  1,
		'S':    0,
		'SIR':  0,
},

# what days you'd like to see subway status
'subwayDayRange': [
		'Monday',
		'Tuesday',
		'Wednesday',
		'Thursday',
		'Friday',
],

# a time range during which to display subway status
'subwayTimeRange': [5, 13],
```

## Static files
Static files are compiled with gulp, a node.js based build system). You'll need
node and gulp installed, and then you can run `npm install` in the project root
to install the packages required to compile Auto-HUD's frontend files. Just run
`gulp` in the project root to watch for Sass and CoffeeScript changes.
