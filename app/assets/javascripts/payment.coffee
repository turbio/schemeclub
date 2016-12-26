interval = null

cached = {}

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

	total: (val) ->
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
			clearInterval interval
			$('.complete-dialog').removeClass('hidden')
			$('.reload-button').remove()

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

	if $('.complete-dialog').hasClass('hidden')
		interval = setInterval ->
			$.get '/payment/status', (result) -> update_info result
		, 30000
