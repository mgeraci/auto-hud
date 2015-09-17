window.AutoHUD = {
	versionPollTime: 5000

	init: (params)->
		console.log params
		@C = params.C

		# get the model, view, and controller from the window
		@model = AutoHUDModel
		@view = AutoHUDView
		@controller = AutoHUDController

		# set up cross-references
		@model.view = @view
		@model.controller = @controller
		@model.C = params.C
		@view.model = @model
		@view.controller = @controller
		@view.C = params.C
		@controller.model = @model
		@controller.view = @view
		@controller.C = params.C

		# send data to the model
		@model.set(params)

		# initialize the underscore templates
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
				@model.set({noConnection: false})
			error: =>
				console.log "no response from the version watcher; the server must be down."
				@model.set({noConnection: true})
		})

	parseVersion: (data) ->
		return if !data.version?

		# if the version has updated, refresh the page
		if data.version != @version
			window.location.reload()
}
