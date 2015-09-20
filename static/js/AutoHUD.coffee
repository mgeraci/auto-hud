window.AutoHUD = {
	versionPollTime: 5000

	init: (params)->
		# set the app constants on the window
		window.C = params.C

		# get the model, view, and controller from the window
		@model = AutoHUDModel
		@view = AutoHUDView
		@controller = AutoHUDController

		# set up cross-references
		@model.view = @view
		@model.controller = @controller
		@view.model = @model
		@view.controller = @controller
		@controller.model = @model
		@controller.view = @view

		# send the initial data to the model
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

		# kick off the watchers for each section
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
				@model.set({noConnection: true})
		})

	parseVersion: (data) ->
		return if !data.version?

		# if the version has updated, refresh the page
		if data.version != @version
			window.location.reload()
}
