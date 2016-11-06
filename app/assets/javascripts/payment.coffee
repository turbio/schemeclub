update_info = (info) ->
	console.log info

$ ->
	$ '.reload-button'
		.css 'animation': 'spin 2s infinite linear'
		.text ''

	setInterval ->
		$.get '/payment/status', (result) -> 
	, 10000
