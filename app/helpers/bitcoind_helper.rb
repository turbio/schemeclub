require 'bigdecimal'

module BitcoindHelper
	@@server_config = Rails.configuration.payment['server']

	def new_address
		res = query('getnewaddress', 'payments')

		JSON.parse(res.body)['result']
	end

	def get_balance(address)
		res = query(
			'getreceivedbyaddress',
			address,
			Rails.configuration.payment['confirmations'])

		BigDecimal.new JSON.parse(res.body)['result'].to_s
	end

	def get_transactions(address)
		res = JSON.parse(query('listtransactions', 'payments').body)

		res['result'].select do |t|
			t['address'] == address
		end.map do |t|
			{
				amount: BigDecimal.new(t['amount'].to_s),
				confirmations: t['confirmations']
			}
		end
	end

	protected
		def query(method, *params)
			req = Net::HTTP::Post.new('/')
			req.add_field('Content-Type', 'application/json')
			req.basic_auth @@server_config['user'], @@server_config['password']
			req.body = {
				id: 0,
				method: method,
				params: params
			}.to_json

			http = Net::HTTP.start(@@server_config['host'], @@server_config['port'])
			http.request req
		end
end
