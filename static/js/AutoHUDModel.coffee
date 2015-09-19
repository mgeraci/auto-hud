window.AutoHUDModel = {
	data: {}

	set: (props) ->
		for own key, value of props
			@data[key] = value

		AutoHUD.view.render()

	get: (prop)->
		return @data[prop]

	getAll: ->
		return @data
}
