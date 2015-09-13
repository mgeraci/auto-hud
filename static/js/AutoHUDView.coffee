window.AutoHUDView = {
	templates: {}

	render: (nextProps) ->
		# bail if we haven't initialized the templates yet (race condition on
		# startup)
		return if _.isEqual({}, @templates)

		for section in @C.sections
			if @lastProps? && _.isEqual(@lastProps[section], nextProps[section])
				continue

			$("##{section}-wrapper").html(
				@templates[section]({d: nextProps})
			)

		@lastProps = $.extend(true, {}, nextProps)

	makeTemplates: ->
		for section in @C.sections
			@templates[section] = _.template($("##{section}-template").html())
}
