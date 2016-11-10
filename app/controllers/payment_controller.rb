require 'net/http'
require 'bigdecimal'

class PaymentController < ApplicationController
	TOTAL = BigDecimal.new Rails.configuration.payment['entry_fee']
	include BitcoindHelper

	def get_info
		if session[:user_id].nil?
			redirect_to root_path and return { error: 'not logged in' }
		end

		payment = Payment.where(user_id: session[:user_id]).first

		if payment.nil?
			payment = Payment.create(
				user_id: session[:user_id],
				amount: TOTAL,
				direction: :in,
				address: new_address)
		end

		if get_balance(payment.address) >= TOTAL
			payment.update(confirmed: true)
		end

		{
			address: payment.address,
			total: TOTAL,
			transactions: get_transactions(payment.address),
			complete: payment.confirmed,
			qr_url: "#{qrcode_path}" +
				"?width=100" +
				"&height=100" +
				"&data=bitcoin:#{payment.address}?amount=#{TOTAL}"
		}
	end

	def index
		get_info.each do |key, value|
			instance_variable_set("@#{key}", value)
		end
	end

	def status
		render json: get_info
	end
end
