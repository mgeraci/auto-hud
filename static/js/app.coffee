model = {
	data: {}

	set: (props) ->
		$.extend(true, @data, props)
		AutoHUD.render(@getAll())

	get: (prop)->
		return @data[prop]

	getAll: ->
		return @data
}

window.AutoHUD = {
	versionPollTime: 5000
	model: model
	months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

	init: (params)->
		# set the current version on the sigleton. if it's missing, refresh.
		if !params.version?
			window.location.reload()
		else
			@version = params.version

		@makeTemplates()

		# watch for version changes
		@versionWatcher = setInterval(=>
			@fetchVersion()
		, @versionPollTime)

		@watchTime()


	# render
	#############################################################################

	render: (nextProps) ->
		if @lastProps?
			return if _.isEqual(@lastProps, nextProps)

		$("body").html(
			@presentationTemplate(nextProps)
		)

		@lastProps = $.extend(true, {}, nextProps)


	# versioning
	#############################################################################

	fetchVersion: ->
		$.ajax("/version", {
			type: "GET"
			success: (data) =>
				@parseVersion(data)
			error: =>
				console.log "no response"
		})

	parseVersion: (data) ->
		return if !data.version?

		# if the version has updated, refresh the page
		if data.version != @version
			window.location.reload()
			return

		console.log data


	# time and date
	#############################################################################

	watchTime: ->
		@timeWatcher = setInterval(=>
			@setTime()
		, 1000)

	setTime: ->
		d = new Date()

		seconds = d.getSeconds()
		if seconds < 10
			seconds = "0#{seconds}"

		month = @months[d.getMonth()]

		@model.set({
			time: "#{d.getHours()}:#{d.getMinutes()}:#{seconds}"
			date: "#{month} #{d.getDate()}, #{d.getFullYear()}"
		})


	# util
	#############################################################################

	makeTemplates: ->
		@presentationTemplate = _.template($("#presentation-template").html())
}
