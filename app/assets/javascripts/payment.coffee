interval = null

cached =
	qr_url: $('.bitcoin-qr').attr('src')
	remaining: $('.remaining').val()
	address: $('.bitcoin-address').val()
	complete: !$('.button').hasClass('hidden')
	transaction: []

build_transaction = (transaction) ->
	$('<div class="transaction-record"/>')
		.append(
			$('<span class="confirmations"/>')
				.text(transaction.confirmations + ' / 3 confirmations'))
		.append(
			$('<span class="currency"></span>')
				.text('+' + transaction.amount + ' BTC'))

update =
	qr_url: (val) ->
		$('.bitcoin-qr').attr('src', val)

	remaining: (val) ->
		$('.remaining').val(val)

	address: (val) ->
		$('.bitcoin-address').val(val)

	transactions: (val) ->
		if $('.pending-transaction').length == 0 && val.length > 0
			$('.copy-button')
				.after '<div class="pending-transaction">pending transaction:</div>'

		$('.transaction-record').remove()
		$('.pending-transaction').after(build_transaction(t)) for t in val

	complete: (val) ->
		if val
			$('.button').removeClass('hidden')
		else
			$('.button').addClass('hidden')

update_info = (info) ->
	for key in Object.keys(info)
		if JSON.stringify(cached[key]) != JSON.stringify(info[key])
			update[key] && update[key](info[key])
			cached[key] = info[key]

$ ->
	$ '.reload-button'
		.css 'animation': 'spin 2s infinite linear'
		.text ''
		.attr 'href', null

	interval = setInterval ->
		$.get '/payment/status', (result) -> update_info result
	, 1000
