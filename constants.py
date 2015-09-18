# application-wide constants. this gets passed wholesale into javascript, so
# use 0/1 instead of True/False for bools.
C = {
    'sections': [
        'time',
        'date',
        'weather',
        'birthdays',
        'chores',
        'subway',
        'noConnection',
    ],

    'weatherPollTime': 1000 * 60 * 5,
    'weatherUrl': 'https://api.forecast.io/forecast/',

    'subwayPollTime': 1000 * 60,
    'subwayUrl': '/mta-service-status',
    'subwayRemoteUrl': 'http://web.mta.info/status/serviceStatus.txt',

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

    'subwayTimeRange': [5, 13],
    'subwayDayRange': [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
    ],

    'months': [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
    ],

    'daysPy': [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
    ],

    'daysJs': [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
    ],
}
