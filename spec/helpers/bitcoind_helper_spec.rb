require 'rails_helper'

Bitcoind_config = Rails.configuration.payment['server']
Bitcoind_opts = [
	"-rpcport=#{Bitcoind_config['port']}",
	"-rpcuser=#{Bitcoind_config['user']}",
	"-rpcpassword=#{Bitcoind_config['password']}"
]

def give_bitcoins(amount, address, confirm=false)
	opts = Bitcoind_opts + [ 'sendtoaddress', address, amount ]

	`bitcoin-cli #{opts.join ' '}`

	if confirm
		gen_blocks 101
	end
end

def gen_blocks(number)
	opts = Bitcoind_opts + [ 'generate', number ]
	`bitcoin-cli #{opts.join ' '}`
end

def new_user
	(rand * 10000).floor
end

RSpec.describe BitcoindHelper, type: :helper do
	describe 'with bitcoind running' do
		it 'should not throw error on get_address' do
			expect do
				get_address 0
			end.not_to raise_error
		end

		it 'should not throw error on get_balance' do
			expect do
				get_balance 0
			end.not_to raise_error
		end

		it 'should not throw error on get_transactions' do
			expect do
				get_transactions 0
			end.not_to raise_error
		end
	end

	describe '#get_address' do
		it 'should return the address of any user' do
			address = get_address new_user

			expect(address).to be_a String
			expect(address.length).to be >= 24
			expect(address.length).to be <= 34
		end

		it 'should return not the same address for multiple users' do
			startUser = new_user

			addresses = 10.times.map do |i|
				get_address startUser + i
			end

			expect(addresses).to eq addresses.uniq
		end

		it 'should return the same address for the same user' do
			user = new_user

			addresses = 10.times.map do
				get_address user
			end

			expect(addresses.uniq.length).to eq 1
		end
	end

	describe '#get_balance' do
		it 'should return a number' do
			user = new_user

			expect(get_balance user).to be_a BigDecimal
		end

		it 'should start users with no balance' do
			user = new_user

			expect(get_balance(user).to_s).to eq '0.0'
		end

		it 'should have balance when given bitcoins' do
			user = new_user
			address = get_address user

			expect(get_balance(user).to_s).to eq '0.0'

			give_bitcoins '1.2345678', address, true

			expect(get_balance(user).to_s).to eq '1.2345678'
		end

		it 'should keep bitcoin amount accurately' do
			user = new_user
			address = get_address user

			expect(address).to be_a String
			expect(address.length).to be >= 24
			expect(address.length).to be <= 34

			expect(get_balance(user).to_s).to eq '0.0'

			12.times do
				give_bitcoins('0.00001', address)
			end

			gen_blocks 101

			expect(get_balance(user).to_s).to eq '0.00012'
		end

		it 'should require three confirmations' do
			user = new_user
			address = get_address user

			expect(get_balance(user).to_s).to eq '0.0'

			give_bitcoins '0.00001', address
			expect(get_balance(user).to_s).to eq '0.0'

			gen_blocks 1
			expect(get_balance(user).to_s).to eq '0.0'

			gen_blocks 1
			expect(get_balance(user).to_s).to eq '0.0'

			gen_blocks 1
			expect(get_balance(user).to_s).to eq '0.00001'
		end
	end

	describe '#get_transactions' do
		it 'should return an array' do
			user = new_user

			expect(get_transactions user).to be_a Array
		end

		it 'user should start with no transactions' do
			user = new_user

			expect(get_transactions(user).length).to eq 0
		end

		it 'should show new transactions' do
			user = new_user

			expect(get_transactions(user).length).to eq 0

			give_bitcoins '0.00001', get_address(user)

			expect(get_transactions(user).length).to eq 1
		end
	end
end
