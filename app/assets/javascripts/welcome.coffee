net_profit = 0

next = $('.side-btn.next')
prev = $('.side-btn.prev')

profit_change_to = (amount) ->
	cur_profit = net_profit
	net_profit = amount

	interval = setInterval ->
		if cur_profit >= net_profit
			end_increment()
		cur_profit += ((net_profit - cur_profit) / 10)
		set_currency cur_profit
	, 16

	end_increment = ->
		clearInterval interval
		set_currency net_profit

set_currency = (val) ->
	$('.net-profit').text '▲' + val.toFixed(2)

slides = [
	->
		console.log 'a'
	->
		console.log 'b'
		elems = [
			'<li><a>alice<span class="earned-from">5.00</span></a></li>',
			'<li><a>bob<span class="earned-from">5.00</span></a></li>',
			'<li><a>carol<span class="earned-from">5.00</span></a></li>'
		];

		setTimeout( ->
			$('.tree-parent').append(
				$('<ol></ol>')
				.addClass('child-container')
				.fadeIn()
				.append(
					$(elems[0])
					.fadeIn()));
			profit_change_to 5

		, 500)
	->
		console.log 'c'
];

check_slide = (slide) ->
	if slides[slide]
		slides[slide]()

next_slide = (slide) ->
	if slide == 0
		prev.animate({
			opacity: '1'
		}, 420)

	$('#slide_' + (slide + 1))
		.css('left', '100%')
		.addClass('show')
		.animate({
			left: '0'
		},
		420,
		-> document.location = $(next).attr('href'))

	$('#slide_' + slide).animate({
			left: '-100%'
		}, 420)
	false

prev_slide = (slide) ->
	if slide == 1
		prev.animate({
			opacity: '0'
		}, 420)

	$('#slide_' + (slide - 1))
		.css('left', '-100%')
		.addClass('show')
		.animate({
			left: '0'
		},
		420,
		-> document.location = $(prev).attr('href'))

	$('#slide_' + slide).animate({
			left: '100%'
		}, 420)
	false

$ ->
	slide = parseInt(location.pathname.split('/').slice(-1)[0]) || 0

	check_slide(slide)
	next.on 'click', next_slide.bind(null, slide)
	prev.on 'click', prev_slide.bind(null, slide)

