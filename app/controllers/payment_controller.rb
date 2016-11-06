require 'net/http'
require 'bigdecimal'

class PaymentController < ApplicationController
	TOTAL = BigDecimal.new Rails.configuration.payment['entry_fee']
	include PaymentHelper

	def get_info
		@address = get_address(session[:user_id])
		@remaining = TOTAL - get_balance(session['user_id'])

		{
			address: @address,
			remaining: @remaining,
			transactions: get_transactions(session[:user_id]),
			complete: @remaining <= 0,
			qr_url: "#{qrcode_path}" +
				"?width=100" +
				"&height=100" +
				"&data=bitcoin:#{@address}?amount=#{@remaining}"
		}
	end

	def index
		if session[:user_id].nil?
			redirect_to root_path and return
		end

		get_info.each do |key, value|
			instance_variable_set("@#{key}", value)
		end
	end

	def status
		if session[:user_id].nil?
			redirect_to root_path and return
		end

		render json: get_info
	end
end
