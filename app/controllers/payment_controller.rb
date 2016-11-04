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

		@remaining = @total - get_balance(session['user_id'])

		@qr_url = "#{qrcode_path}" +
			"?width=100" +
			"&height=100" +
			"&data=bitcoin:#{@address}?amount=#{@remaining}"

		@other = get_transactions(session[:user_id]).map do |t|
			"#{t['address']} -[#{t['amount']}]-> #{t['account']} c:#{t['confirmations']}"
		end.join('<br>').html_safe
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
