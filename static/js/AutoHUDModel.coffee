window.AutoHUDModel = {
	data: {}

	set: (props) ->
		$.extend(true, @data, props)
		AutoHUD.view.render(@getAll())

	get: (prop)->
		return @data[prop]

	getAll: ->
		return @data
}
