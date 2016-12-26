require 'net/http'
require 'bigdecimal'

class PaymentController < ApplicationController
	Total = BigDecimal.new Rails.configuration.payment['entry_fee']
	include BitcoinHelper

	def index
		get_info.each do |key, value|
			instance_variable_set("@#{key}", value)
		end
	end

	def status
		render json: get_info
	end

	private

	def get_info
		if session[:user_id].nil?
			redirect_to root_path and return { error: 'not logged in' }
		end

		payment = Payment.where(user_id: session[:user_id]).first

		if payment.nil?
			payment = Payment.create(
				user_id: session[:user_id],
				amount: Total,
				direction: :in,
				address: new_address)
		end

		info = address_info payment.address

		if info[:balance] >= Total
			payment.update(confirmed: true)
		end

		{
			address: payment.address,
			total: Total,
			transactions: info[:transactions],
			complete: payment.confirmed,
			qr_url: "#{qrcode_path}" +
				"?width=100" +
				"&height=100" +
				"&data=bitcoin:#{payment.address}?amount=#{Total}"
		}
	end
end
