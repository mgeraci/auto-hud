window.AutoHUDController = {
	useTestWeatherData: false
	watchers: {}

	init: ->
		for section in C.sections
			@makeWatcher(section)

	# start a timer for each section which has one. each section needs:
	# - a function called sectionGetter, where `section` is the section name
	# - an entry in constants.py called sectionPollTime, where `section` is the
	#   section name
	makeWatcher: (section) ->
		return if !section?

		getter = @["#{section}Getter"]
		return if !getter? || !_.isFunction(getter)

		pollTime = C["#{section}PollTime"]
		return if !pollTime

		# set the intial state
		getter.call(@)

		# set an interval
		@watchers[section] = setInterval(=>
			getter.call(@)
		, pollTime)


	# time and date
	#############################################################################

	timeGetter: ->
		d = new Date()
		month = C.months[d.getMonth()]

		@model.set({
			time: {
				hours: @padZeroes(d.getHours())
				minutes: @padZeroes(d.getMinutes())
				seconds: @padZeroes(d.getSeconds())
			}
			date: {
				month: month
				day: d.getDate()
				year: d.getFullYear()
			}
		})

	# 5 => "05"
	padZeroes: (number) ->
		if number < 10
			number = "0#{number}"

		return number


	# birthdays
	#############################################################################

	birthdaysGetter: ->
		$.ajax(C.birthdaysUrl, {
			type: "GET"
			success: (data) =>
				@model.set(data)
		})


	# chores
	#############################################################################

	choresGetter: ->
		$.ajax(C.choresUrl, {
			type: "GET"
			success: (data) =>
				@model.set(data)
		})


	# chores
	#############################################################################

	birdPodcastsGetter: ->
		$.ajax(C.birdPodcastsUrl, {
			type: "GET"
			success: (data) =>
				res = {
					birdPodcastCount: data.program_count
				}

				@model.set(res)
		})


	# weather
	#############################################################################

	weatherGetter: ->
		if @useTestWeatherData
			@formatWeather(weatherData)
			return

		url = "#{C.weatherUrl}#{@model.get("forecastioApiKey")}/#{@model.get("forecastioLatLong")}"

		# to use test data, comment out the `getJSON` and add:
		# @formatWeather(weatherData)
		$.getJSON("#{url}?callback=?", (data) =>
			@formatWeather(data)
		)

	###
	Format weather data from forecast.io into something a little more simple:
	current: 75º, rain
	today: 65º-77º, rain in the afternoon
	###
	formatWeather: (data) ->
		weather = {
			current: {}
			preview: {}
		}

		weather.current.temperature = @formatTemperature(data.currently.apparentTemperature)
		weather.current.summary = data.currently.summary
		weather.current.icon = data.currently.icon

		# determine if we want to show a preview for today (if it's the morning)
		# or tomorrow (if it's the afternoon)
		if new Date().getHours() < 16
			dayIndex = 0
		else
			dayIndex = 1

		preview = data.daily.data[dayIndex]
		weather.preview = @formatDayWeather(preview, dayIndex)

		@model.set({weather: weather})

	formatTemperature: (temperature) ->
		temperature = Math.round(temperature)

		return """
			<span class="degree">#{temperature}</span>
			<span class="degree-symbol">º</span>
		"""

	formatDayWeather: (day, tomorrow = false)->
		return {
			low: @formatTemperature(day.temperatureMin)
			high: @formatTemperature(day.temperatureMax)
			summary: day.summary.replace(/\.$/, "")
			icon: day.icon
			tomorrow: tomorrow
			precip: Math.round(day.precipProbability * 100)
		}


	# subway
	#############################################################################

	subwayGetter: ->
		d = new Date()

		# if the constants have a subway day range, check that we qualify
		if C.subwayDayRange?
			day = C.daysJs[d.getDay()]

			if C.subwayDayRange.indexOf(day) < 0
				return

		# if the constants have a subway time range, check that we qualify
		if C.subwayTimeRange? && C.subwayTimeRange.length == 2
			hour = d.getHours()

			if hour < C.subwayTimeRange[0] || hour >= C.subwayTimeRange[1]
				@model.set({subway: null})
				return

		$.ajax(C.subwayUrl, {
			type: "GET"
			dataType: "xml"
			success: (data) =>
				@parseSubway(data)
		})

	parseSubway: (data) ->
		subwayStatus = {}

		return if !data || !$(data).length

		for line in $(data).find("service subway line")
			line = $(line)
			name = line.find("name")
			status = line.find("status")

			# bail if there's a missing element
			continue if !name.length || !status.length

			name = name.text()
			status = status.text()

			# bail if we don't care about this subway line
			continue if !C.subwayLinesToShow[name]

			subwayStatus[name] = {
				lines: @formatLines(name)
				status: status
			}

		@model.set({subway: subwayStatus})

	formatLines: (lines) ->
		res = []

		for line in lines.split("")
			res.push("""
				<span class="hud-section-subway-line">#{line}</span>
			""")

		return res.join("")


	# currenty playing song
	#############################################################################

	songGetter: ->
		$.get(C.songUrl, (data) =>
			if !data?
				@model.set({song: null})
				return

			@formatSong(data)
		)

	formatSong: (data) ->
		data = $.parseHTML(data)
		html = $("<div></div>").append(data)
		playingStatus = html.find("#playingStatus").text().toLowerCase()
		isPlaying = playingStatus.indexOf("playing") >= 0

		# key is what part of the song, value is what to look for in a link
		linkMap = {
			artist: "artist_id"
			album: "album_id"
			song: "songinfo"
		}

		# start with the results set to null. this way, when it goes from playing
		# to paused, it clears the display
		resultsMap = {
			artist: null
			album: null
			song: null
		}

		if isPlaying
			links = html.find(".playingSong a")

			for link in links
				for key, value of linkMap
					if link.href.indexOf(value) >= 0
						resultsMap[key] = link.text

		@model.set(resultsMap)
}
