model = {
	data: {}

	set: (props) ->
		$.extend(true, @data, props)
		AutoHUD.view.render(@getAll())

	get: (prop)->
		return @data[prop]

	getAll: ->
		return @data
}

view = {
	templates: {}

	render: (nextProps) ->
		# bail if we haven't initialized the templates yet (race condition on
		# startup)
		return if _.isEqual({}, @templates)

		if @lastProps?
			return if _.isEqual(@lastProps, nextProps)

		for section in @model.get("sections")
			$("##{section}-wrapper").html(
				@templates[section]({d: nextProps})
			)

		@lastProps = $.extend(true, {}, nextProps)

	makeTemplates: ->
		for section in @model.get("sections")
			@templates[section] = _.template($("##{section}-template").html())
}

controller = {
	weatherPollTime: 1000 * 60 * 5
	weatherUrl: "https://api.forecast.io/forecast/"
	months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

	setWatchers: ->
		@watchTime()
		@watchWeather()


	# time and date
	#############################################################################

	watchTime: ->
		@timeWatcher = setInterval(=>
			@setTime()
		, 1000)

	setTime: ->
		d = new Date()

		minutes = d.getMinutes()
		if minutes < 10
			minutes = "0#{minutes}"

		seconds = d.getSeconds()
		if seconds < 10
			seconds = "0#{seconds}"

		month = @months[d.getMonth()]

		@model.set({
			time: "#{d.getHours()}:#{minutes}:#{seconds}"
			date: "#{month} #{d.getDate()}, #{d.getFullYear()}"
		})


	# weather
	#############################################################################

	watchWeather: ->
		@getWeather()
		setInterval(=>
			@getWeather()
		, @weatherPollTime)

	getWeather: ->
		url = "#{@weatherUrl}#{@model.get("forecastioApiKey")}/#{@model.get("forecastioLatLong")}"

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
			today: {}
		}

		weather.current.temperature = @formatTemperature(data.currently.apparentTemperature)
		weather.current.summary = data.currently.summary
		weather.current.icon = data.currently.icon

		today = data.daily.data[0]

		weather.today.low = @formatTemperature(today.temperatureMin)
		weather.today.high = @formatTemperature(today.temperatureMax)
		weather.today.summary = today.summary
		weather.today.icon = today.icon

		@model.set({weather: weather})

	formatTemperature: (temperature) ->
		temperature = Math.round(temperature)
		return "#{temperature}ºF"
}

window.AutoHUD = {
	versionPollTime: 5000

	model: model
	view: view
	controller: controller

	init: (params)->
		console.log params
		# set up cross-references
		@model.view = @view
		@model.controller = @controller
		@view.model = @model
		@view.controller = @controller
		@controller.model = @model
		@controller.view = @view

		# send data to the model
		@model.set(params)

		@view.makeTemplates()

		# set the current version on the sigleton. if it's missing, refresh.
		if !params.version?
			window.location.reload()
		else
			@version = params.version

		# watch for version changes
		@versionWatcher = setInterval(=>
			@fetchVersion()
		, @versionPollTime)

		@controller.setWatchers()


	# versioning
	#############################################################################

	fetchVersion: ->
		$.ajax("/version", {
			type: "GET"
			success: (data) =>
				@parseVersion(data)
			error: =>
				console.log "no response from the version watcher; the server must be down."
		})

	parseVersion: (data) ->
		return if !data.version?

		# if the version has updated, refresh the page
		if data.version != @version
			window.location.reload()
}
