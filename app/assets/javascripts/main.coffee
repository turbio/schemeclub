# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	$('.submit-button').hide()
	passfield = $('.password-field').hide()
	namefield = $('.name-field')

	passfield.on 'input', ->
		valid_cred (valid) -> $('form').submit() if valid

	namefield.on 'input', ->
		valid_name (valid) ->
			$('.password-field').show() if valid

valid_name = (f) ->
	$.post '/api/valid_name',
		'name': $('.name-field').val(),
		(data) -> f data == true

valid_cred = (f) ->
	$.post '/api/valid_credentials',
		'name': $('.name-field').val()
		'password': $('.password-field').val(),
		(data) -> f data == true
