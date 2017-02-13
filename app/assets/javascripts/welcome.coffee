max_slide = 5
net_profit = 0
current_slide = 0

next = $ '.side-btn.next'
prev = $ '.side-btn.prev'

profit_change_to = (amount, fix=false) ->
	if fix
		net_profit = amount

	cur_profit = net_profit
	net_profit = amount

	interval = setInterval(
		->
			if cur_profit >= net_profit
				end_increment()
			cur_profit += ((net_profit - cur_profit) / 10) + 0.00001
			set_currency cur_profit,
		16
	)

	end_increment = ->
		clearInterval interval
		set_currency net_profit

set_currency = (val) -> $('.net-profit').text '▲' + val.toFixed(4)

set_time = null

run_set = (set, survive=true) ->
	set_time = setTimeout(
		run_set.bind(this, set, false),
		set.shift()() || 0
	) if set.length > 0

cash_flow_elem = '<span style="
color: #4CAF50;
font-size: 1em;
position: fixed;
text-shadow: #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px,
             #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px,
             #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px,
             #fff 0px 0px 4px,   #fff 0px 0px 4px,   #fff 0px 0px 4px;
" class="sim-elem"></span>'

get_center = (elem) ->
	elem = $(elem)
	pos = elem.offset()

	return {} if !pos

	{
		top: (pos.top + (elem.height() / 2)) + 'px',
		left: (pos.left + (elem.width() / 2)) + 'px'
	}

distribute_wealth = (from, value=16) ->
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
	child.addClass('sim-elem')
	to = to || $('#slide_' + current_slide + ' .child-container')
	to.append(child)
	child.ready -> distribute_wealth(child.find('a')[0])

slides = [
	-> #slide 0
		profit_change_to 0, true
	-> #slide 1
		profit_change_to 0, true
	-> #slide 2
		profit_change_to 0, true

		elems = [
			'<li style="display: inline-block" class="sim-elem">
				<a>alice<span class="earned-from">8.00</span></a>
			</li>',
			'<li style="display: inline-block" class="sim-elem">
				<a>bob<span class="earned-from">8.00</span></a>
			</li>',
			'<li style="display: inline-block" class="sim-elem">
				<a>carol<span class="earned-from">8.00</span></a>
			</li>'
		]

		user_node = $($('#slide_' + current_slide + ' .tree-parent').children()[0])
		profit_elem = $('#slide_' + current_slide + ' .net-profit')

		$('#slide_' + current_slide + ' .tree-parent')
			.append($('<ol></ol>').addClass('child-container sim-elem').fadeIn())

		run_set [
			->
				500
			->
				add_sub(elems[0])
				$('#child-earnings-0').fadeIn()
				1500
			->
				profit_change_to 8
				2000
			->
				add_sub(elems[1])
				$('.child-earnings').hide()
				$('#child-earnings-1').show()
				1500
			->
				profit_change_to 16
				2000
			->
				add_sub(elems[2])
				$('.child-earnings').hide()
				$('#child-earnings-2').show()
				1500
			->
				profit_change_to 24
				$('.replay-button').fadeIn()
		]

	-> #slide 3
		profit_change_to 24, true

		elem = [
			'<ol class="add-to-second" class="sim-elem">
				<li style="display: inline-block" class="sim-elem">
					<a>dan<span class="earned-from">4.00</span></a>
				</li></ol>',

			'<li style="display: inline-block" class="sim-elem">
				<a>erin<span class="earned-from">4.00</span></a>
			</li>'
		]

		to_add_to = $ '#slide_' + current_slide + ' .add-to-first'

		run_set [
			->
				500
			->
				add_sub(elem[0], to_add_to)
				to_add_to.find('span').first().text '12.00'
				3000
			->
				profit_change_to 28
				1000
			->
				to_add_to.find('span').first().text '16.00'

				to_add_to = $ '#slide_' + current_slide + ' .add-to-second'
				add_sub(elem[1], to_add_to)
				3000
			->
				profit_change_to 32
				$('.replay-button').fadeIn()
		]
		-> #slide 4
			profit_change_to 32, true
		-> #slide 5
]

run_slide = -> slides[current_slide]() if slides[current_slide]

set_stage = ->
	if current_slide == 0
		prev.animate { opacity: '0' }, 420, -> $(prev).css('display', 'none')
	else
		$(prev).css('display', 'block')
		prev.animate { opacity: '1' }, 420

	if current_slide == 5
		$(next).addClass 'done'
		$(next).removeClass 'next'
	else
		$(next).addClass 'next'
		$(next).removeClass 'done'

	$('.sim-elem').remove()
	$('#child-earnings-0').hide()
	$('#child-earnings-1').hide()
	$('#child-earnings-2').hide()
	clearTimeout set_time

goto_slide = (direction) ->
	if current_slide == max_slide && direction == 1
		window.location = '/join'

	if current_slide + direction > max_slide || current_slide + direction < 0
		return current_slide = 0

	next_slide = $('#slide_' + (current_slide + direction))
	cur_slide = $('#slide_' + current_slide)

	current_slide += direction

	history.pushState({}, '', '/welcome/' + current_slide);
	set_stage()

	next_slide
		.css('left', (direction) + '00%')
		.addClass('show')
		.animate(
			{ left: '0' },
			420,
			->
				run_slide()
		)

	cur_slide.animate { left: (direction * -1) + '00%' }, 420

$ ->
	current_slide = parseInt(location.pathname.split('/').slice(-1)[0]) || 0

	next.on 'click', ->
		goto_slide 1
		false
	prev.on 'click', ->
		goto_slide -1
		false

	set_stage()
	run_slide()

	$('.replay-button').on(
		'click',
		->
			set_stage()
			run_slide()
	)

