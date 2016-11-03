$ ->
	$ '.reload-button'
		.css 'animation': 'spin 2s infinite linear'
		.text ''

	setInterval ->
		$.get '/payment/status', (result) -> console.log result
	, 10000
