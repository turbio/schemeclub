require 'net/http'
require 'bigdecimal'

class PaymentController < ApplicationController
	include BitcoinHelper

	EntryFee = BigDecimal.new Rails.configuration.payment['entry_fee']
	NoCodeFee = BigDecimal.new Rails.configuration.payment['nocode_fee']

	def index
		return render json: get_info if params[:format] === 'json'

		get_info.each do |key, value|
			instance_variable_set("@#{key}", value)
		end
	end

	private

	def get_info
		user = session[:user]

		payment = Payment.find_by user_id: user['id']

		if payment.nil?
			amount_due = EntryFee
			amount_due += NoCodeFee if user['recruit_code_id'].nil?

			payment = Payment.create(
				user_id: user['id'],
				amount: amount_due,
				direction: :in,
				address: new_address
			)
		end

		if !payment.confirmed
			info = address_info payment.address

			if info[:balance] >= payment.amount
				payment.update(confirmed: true)
				Transaction.give(
					User.find(user['id']),
					payment.amount
				)
			end
		else
			info = {
				transactions: []
			}
		end

		{
			address: payment.address,
			total: payment.amount,
			transactions: info[:transactions],
			complete: payment.confirmed,
			qr_url:
				qrcode_path +
				'?width=100' +
				'&height=100' +
				"&data=bitcoin:#{payment.address}?amount=#{payment.amount}"
		}
	end
end
