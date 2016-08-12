$ ->
	slide = parseInt(location.pathname.split('/').slice(-1)[0]) || 0

	next = $('.side-btn.next')
	prev = $('.side-btn.prev')

	next.on 'click', ->
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

	prev.on 'click', ->
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
