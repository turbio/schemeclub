module PaymentHelper
	@@server_config = Rails.configuration.payment['server']
	@@http = Net::HTTP.start(@@server_config['host'], @@server_config['port'])

	def query(body)
		req = Net::HTTP::Post.new('/')
		req.add_field('Content-Type', 'application/json')
		req.basic_auth @@server_config['user'], @@server_config['password']
		req.body = body.to_json

		@@http.request req
	end

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
			params: [user_id.to_s] })

		JSON.parse(res.body)['result']
	end

	def get_transactions(user_id)
		res = query({
			id: 0,
			method: 'listtransactions',
			params: [user_id.to_s] })

		JSON.parse(res.body)['result']
	end
end
