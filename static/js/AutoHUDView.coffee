window.AutoHUDView = {
	templates: {}

	init: ->
		# grab templates fromt the dom
		for section in C.sections
			@templates[section] = _.template($("##{section}-template").html())

	# render each section, unless it hasn't changed
	render: ->
		nextProps = @model.getAll()
		return if !nextProps?

		# bail if we haven't initialized the templates yet (race condition on
		# startup)
		return if _.isEqual({}, @templates)

		for section in C.sections
			hasLastProps = @lastProps?[section]?
			hasNextProps = nextProps?[section]?

			if hasLastProps && hasNextProps && _.isEqual(@lastProps[section], nextProps[section])
				continue

			$("##{section}-wrapper").html(
				@templates[section]({d: nextProps})
			)

		@lastProps = $.extend(true, {}, nextProps)
}
