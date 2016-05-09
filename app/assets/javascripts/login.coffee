$ ->
	$('.submit-button').hide()
	passfield = $('.password-field').hide()
	namefield = $('.name-field')

	passfield.on 'input', ->
		valid_cred (valid) -> $('form').submit() if valid

	namefield.on 'input', ->
		if namefield.val().length >= 3
			valid_name (valid) ->
				if valid
					passfield.fadeIn(300)
					namefield.removeClass('invalid-input')
					namefield.addClass('valid-input')
				else
					namefield.removeClass('valid-input')
					namefield.addClass('invalid-input')

valid_name = (callback) ->
	$.post '/api/valid_name',
		'name': $('.name-field').val(),
		(data) ->
			callback data

valid_cred = (callback) ->
	$.post '/api/valid_credentials',
		'name': $('.name-field').val()
		'password': $('.password-field').val(),
		(data) ->
			callback data
