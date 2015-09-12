$ ->
	AutoHUD.init()

window.AutoHUD = {
	init: ->
		@fetchData()

	fetchData: ->
		$.ajax("/data", {
			type: "GET"
			success: (data) =>
				@parseData(data)
		})

	parseData: (data) ->
		console.log data
}
