net_profit = 0

next = $ '.side-btn.next'
prev = $ '.side-btn.prev'

profit_change_to = (amount) ->
	cur_profit = net_profit
	net_profit = amount

	interval = setInterval ->
		if cur_profit >= net_profit
			end_increment()
		cur_profit += ((net_profit - cur_profit) / 10) + 0.0001
		set_currency cur_profit
	, 16

	end_increment = ->
		clearInterval interval
		set_currency net_profit

set_currency = (val) ->
	$ '.net-profit'
	.text '▲' + val.toFixed(2)

run_set = (set) ->
	if set.length > 0
		setTimeout run_set.bind(this, set), set.shift()() || 0

cash_flow_elem = '<span style="
color: #4CAF50;
font-size: 1em;
position: fixed;
text-shadow: #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px,
             #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px,
             #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px,
             #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px;
"></span>'

get_center = (elem) ->
	elem = $(elem)
	pos = elem.offset()

	{
		top: (pos.top + (elem.height() / 2)) + 'px',
		left: (pos.left + (elem.width() / 2)) + 'px'
	}

slides = [
	->
	->
		elems = [
			'<li style="display: inline-block">
				<a>alice<span class="earned-from">5.00</span></a>
			</li>',
			'<li style="display: inline-block">
				<a>bob<span class="earned-from">5.00</span></a>
			</li>',
			'<li style="display: inline-block">
				<a>carol<span class="earned-from">5.00</span></a>
			</li>'
		]

		user_node = $($('#slide_1 .tree-parent').children()[0])
		profit_elem = $('#slide_1 .net-profit')

		$('#slide_1 .tree-parent')
		.append(
			$ '<ol></ol>'
			.addClass 'child-container'
			.fadeIn())

		queue = [
			->
				500
			->
			->
				child = $(elems[0]).fadeIn()
				$('#slide_1 .child-container').append(child)
				child.ready ->
					$('body').append(
						$(cash_flow_elem)
						.text('+10')
						.css(get_center(child))
						.animate(get_center(user_node), 1000, ->
							$(this).text('+5')
							$('body').append(
								$(cash_flow_elem)
								.text('+5')
								.css(get_center(user_node))
								.animate({
									top: user_node.offset().top - 40 + 'px',
									opacity: 0
								}, 1000))
							)
						.animate(get_center(profit_elem), 1000)
						.animate({
							opacity: 0,
							top: profit_elem.offset().top
						}))
				1500
			->
				profit_change_to 5
				2000
			->
				child = $(elems[1]).fadeIn()
				$('#slide_1 .child-container').append(child)
				child.ready ->
					$('body').append(
						$(cash_flow_elem)
						.text('+5')
						.css(get_center(child))
						.animate(get_center(user_node), 1000)
						.animate(get_center(profit_elem), 1000)
						.animate({
							opacity: 0,
							top: profit_elem.offset().top
						}))
				1500
			->
				profit_change_to 10
				2000
			->
				child = $(elems[2]).fadeIn()
				$('#slide_1 .child-container').append(child)
				child.ready ->
					$('body').append(
						$(cash_flow_elem)
						.text('+5')
						.css(get_center(child))
						.animate(get_center(user_node), 1000)
						.animate(get_center(profit_elem), 1000)
						.animate({
							opacity: 0,
							top: profit_elem.offset().top
						}))
				1500
			->
				profit_change_to 15

		]

		run_set queue

	->
		console.log 'c'
]

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

