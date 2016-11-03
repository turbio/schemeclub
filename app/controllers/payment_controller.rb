require 'net/http'
require 'bigdecimal'

class PaymentController < ApplicationController
	include PaymentHelper

	def index
		if session[:user_id].nil?
			redirect_to root_path and return
		end

		@address = get_address session[:user_id]

		@total = BigDecimal.new Rails.configuration.payment['entry_fee']

		@remaining = @total - (@total * (rand * 100).floor / 100)

		@qr_url = "#{qrcode_path}" +
			"?width=100" +
			"&height=100" +
			"&data=bitcoin:#{@address}?amount=#{@remaining}"

		#@other = session['user_id'], JSON.parse(res.body)['result']
		#@other = get_address session['user_id']
	end

	def status
		@total = BigDecimal.new Rails.configuration.payment['entry_fee']

		render json: {
			remaining: @total - (@total * (rand * 100).floor / 100),
			confirmations: 0,
			complete: [true, false].sample
		}
	end
end
