# auto-hud

## local configuration file
To run, Auto-HUD requires a file called `localsettings.py` in the project root.
This file contains personal settings, like birthdays and API keys. Here is an
example `localsettings.py` file:

```.py
# change this number to trigger the client to reload. use if you want to hot
# swap the css, js, or template
VERSION = "0.000"

# your info for forecast.io
FORECASTIO_API_KEY = "[your api key]"
FORECASTIO_LAT_LONG = "40.676423,-73.980488"

# add birthdays with a tuple of (month, day) as a key, and a list of people and
# their birthyears. accepts multiple people on the same day. years are optional.
BIRTHDAYS = {
		(2, 10): [
				{
						'name': 'Edith Clarke',
						'year': 1883
				},
				{
						# Ms. Conwell's birthday is actually May 23, but I changed it here
						# to show how to have multiple people share a birthday.
						'name': 'Esther M. Conwell'
				}
		],
		(12, 9): [
				{
						'name': 'Grace Hopper',
						'year': 1906
				}
		],
		(12, 10): [
				{
						'name': 'Ada Lovelace',
						'year': 1813
				}
		]
}

# each day gets an array of chores, where each chore is a dictionary of text
# and an optional icon
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

## static files
Auto-HUD's JavaScript is written in CoffeeScript, and CSS with sass. To compile
the js, run:

	coffee -wc static/js/app.coffee

from the project root. To compile the css, run:

	sass -wc static/css/app.sass
