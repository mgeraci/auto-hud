window.AutoHUDModel = {
	data: {}

	set: (props) ->
		$.extend(true, @data, props)
		AutoHUD.view.render()

	get: (prop)->
		return @data[prop]

	getAll: ->
		return @data
}
