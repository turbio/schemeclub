net_profit = 0
current_slide = 0

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

distribute_wealth = (from, value=10) ->
	if $(from).hasClass('self')
		to = $('#slide_' + current_slide + ' .net-profit')
		end = true
	else
		to = $ from
			.closest 'ol'
			.prev('a')[0]

	fadeUp = (elem) ->
		$(elem).animate({
			top: ($(elem).offset().top - 40) + 'px',
			opacity: 0
		}, 750, () -> $(this).remove())

	$('body').append(
		$(cash_flow_elem)
		.text('+' + value)
		.css(get_center(from))
		.animate(get_center(to), 1000, ->
			fadeUp this
			if end
				#fadeUp this
			else
				$(this).text('+' + (value / 2))
				distribute_wealth to, value / 2
	))

add_sub = (elem, to) ->
	child = $(elem).fadeIn()
	to = to || $('#slide_' + current_slide + ' .child-container')
	to.append(child)
	child.ready -> distribute_wealth(child.find('a')[0])

slides = [
	->
	->
		net_profit = 0
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

		user_node = $($('#slide_' + current_slide + ' .tree-parent').children()[0])
		profit_elem = $('#slide_' + current_slide + ' .net-profit')

		$('#slide_' + current_slide + ' .tree-parent')
			.append($('<ol></ol>').addClass('child-container').fadeIn())

		run_set [
			->
				500
			->
				add_sub(elems[0])
				1500
			->
				profit_change_to 5
				2000
			->
				add_sub(elems[1])
				1500
			->
				profit_change_to 10
				2000
			->
				add_sub(elems[2])
				1500
			->
				profit_change_to 15
		]

	->
		net_profit = 15
		elem = [
			'<ol class="add-to-second">
				<li style="display: inline-block">
					<a>dan<span class="earned-from">2.50</span></a>
				</li></ol>',

			'<li style="display: inline-block">
				<a>erin<span class="earned-from">2.50</span></a>
			</li>',

			'<ol>
				<li style="display: inline-block" class="add-to-fourth">
					<a>frank<span class="earned-from">2.50</span></a>
				</li></ol>',

			'<ol>
				<li style="display: inline-block">
					<a>grace<span class="earned-from">1.25</span></a>
				</li></ol>',
		]

		to_add_to = $ '#slide_' + current_slide + ' .add-to-first'

		run_set [
			->
				500
			->
				add_sub(elem[0], to_add_to)
				to_add_to.find('span').first().text '7.50'
				3000
			->
				profit_change_to 17.5
				1000
			->
				to_add_to.find('span').first().text '10.00'

				to_add_to = $ '#slide_' + current_slide + ' .add-to-second'
				add_sub(elem[1], to_add_to)
				3000
			->
				profit_change_to 20
				1000
			->
				to_add_to = $ '#slide_' + current_slide + ' .add-to-third'
				to_add_to.find('span').first().text '7.50'
				add_sub(elem[2], to_add_to)
				3000
			->
				profit_change_to 22.50
				1000
			->
				to_add_to.find('span').first().text '8.75'

				to_add_to = $ '#slide_' + current_slide + ' .add-to-fourth'
				to_add_to.find('span').first().text '3.75'
				add_sub(elem[3], to_add_to)
				4000
			->
				profit_change_to 23.75
		]

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
	current_slide = parseInt(location.pathname.split('/').slice(-1)[0]) || 0

	check_slide(current_slide)
	next.on 'click', next_slide.bind(null, current_slide)
	prev.on 'click', prev_slide.bind(null, current_slide)

