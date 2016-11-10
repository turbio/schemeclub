require 'bigdecimal'

module BitcoindHelper
	@@server_config = Rails.configuration.payment['server']

	def get_address(user_id)
		res = query({
			id: 0,
			method: 'getaccountaddress',
			params: [user_id.to_s] })

		JSON.parse(res.body)['result']
	end

	def get_balance(user_id)
		res = query({
			id: 0,
			method: 'getbalance',
			params: [user_id.to_s, Rails.configuration.payment['confirmations']] })

		BigDecimal.new JSON.parse(res.body)['result'].to_s
	end

	def get_transactions(user_id)
		res = query({
			id: 0,
			method: 'listtransactions',
			params: [user_id.to_s] })

		JSON.parse(res.body)['result'].map do |t|
			{
				from: t['address'],
				amount: BigDecimal.new(t['amount'].to_s),
				confirmations: t['confirmations']
			}
		end
	end

	protected
		def query(body)
			req = Net::HTTP::Post.new('/')
			req.add_field('Content-Type', 'application/json')
			req.basic_auth @@server_config['user'], @@server_config['password']
			req.body = body.to_json

			http = Net::HTTP.start(@@server_config['host'], @@server_config['port'])
			http.request req
		end
end
