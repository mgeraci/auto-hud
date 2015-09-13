C = {
    'sections': [
        'time',
        'date',
        'birthdays',
        'weather',
        'subway',
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
}
