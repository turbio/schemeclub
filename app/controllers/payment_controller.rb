require 'bigdecimal'

class PaymentController < ApplicationController
	def index
		@address = '1BoatSLRHtKNngkdXEeobR76b53LETtpyT'
		@total = BigDecimal.new '0.015'
		@remaining = @total - (@total * (rand * 100).floor / 100)
		@qr_url = "/qr?data=bitcoin:#{@address}?amount=#{@remaining}"
	end
end
