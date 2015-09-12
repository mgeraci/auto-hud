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
	render: (nextProps) ->
		if @lastProps?
			return if _.isEqual(@lastProps, nextProps)

		$("body").html(
			@presentationTemplate(nextProps)
		)

		@lastProps = $.extend(true, {}, nextProps)

	makeTemplates: ->
		@presentationTemplate = _.template($("#presentation-template").html())
}

controller = {
	months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

	setWatchers: ->
		@watchTime()


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
}

window.AutoHUD = {
	versionPollTime: 5000

	model: model
	view: view
	controller: controller

	init: (params)->
		# set up cross-references
		@model.view = @view
		@model.controller = @controller
		@view.model = @model
		@view.controller = @controller
		@controller.model = @model
		@controller.view = @view

		# set the current version on the sigleton. if it's missing, refresh.
		if !params.version?
			window.location.reload()
		else
			@version = params.version

		@view.makeTemplates()

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
