window.AutoHUD = {
	pollTime: 5000

	init: (params)->
		# set the current version on the sigleton. if it's missing, refresh.
		if !params.version?
			window.location.reload()
		else
			@version = params.version

		@fetchData()
		setInterval(=>
			@fetchData()
		, @pollTime)

	fetchData: ->
		$.ajax("/data", {
			type: "GET"
			success: (data) =>
				@parseData(data)
			error: =>
				console.log "no response"
		})

	parseData: (data) ->
		return if !data.version?

		# if the version has updated, refresh the page
		if data.version != @version
			window.location.reload()
			return

		console.log data
}
