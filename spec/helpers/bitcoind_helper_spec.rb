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
		gen_blocks 3
	end
end

def gen_blocks(number)
	opts = Bitcoind_opts + [ 'generate', number ]
	`bitcoin-cli #{opts.join ' '}`
end

RSpec.describe BitcoindHelper, type: :helper do
	describe 'with bitcoind running' do
		it 'should not throw error on new_address' do
			expect do
				new_address
			end.not_to raise_error
		end

		it 'should not throw error on get_balance' do
			expect do
				get_balance 'none'
			end.not_to raise_error
		end

		it 'should not throw error on get_transactions' do
			expect do
				get_transactions 'none'
			end.not_to raise_error
		end
	end

	describe '#new_address' do
		it 'should return the address of any user' do
			address = new_address

			expect(address).to be_a String
			expect(address.length).to be >= 24
			expect(address.length).to be <= 34
		end

		it 'should never return the same address' do
			addresses = 10.times.map do |i| new_address end

			expect(addresses).to eq addresses.uniq
		end
	end

	describe '#get_balance' do
		it 'should return a number' do
			address = new_address

			expect(get_balance address).to be_a BigDecimal
		end

		it 'should start address with no balance' do
			address = new_address

			expect(get_balance(address).to_s).to eq '0.0'
		end

		it 'should have balance when given bitcoins' do
			address = new_address

			expect(get_balance(address).to_s).to eq '0.0'

			give_bitcoins '1.2345678', address, true

			sleep 1

			expect(get_balance(address).to_s).to eq '1.2345678'
		end

		it 'should keep bitcoin amount accurately' do
			address = new_address

			expect(address).to be_a String
			expect(address.length).to be >= 24
			expect(address.length).to be <= 34

			expect(get_balance(address).to_s).to eq '0.0'

			12.times do
				give_bitcoins('0.00001', address)
			end

			gen_blocks 101

			expect(get_balance(address).to_s).to eq '0.00012'
		end

		it 'should require three confirmations' do
			address = new_address

			expect(get_balance(address).to_s).to eq '0.0'

			give_bitcoins '0.00001', address
			expect(get_balance(address).to_s).to eq '0.0'

			gen_blocks 1
			expect(get_balance(address).to_s).to eq '0.0'

			gen_blocks 1
			expect(get_balance(address).to_s).to eq '0.0'

			gen_blocks 1
			expect(get_balance(address).to_s).to eq '0.00001'
		end
	end

	describe '#get_transactions' do
		it 'should return an array' do
			expect(get_transactions(new_address)).to be_a Array
		end

		it 'user should start with no transactions' do
			address = new_address

			expect(get_transactions(new_address).length).to eq 0
		end

		it 'should show new transactions' do
			address = new_address

			expect(get_transactions(address).length).to eq 0

			give_bitcoins '0.00001', address

			expect(get_transactions(address).length).to eq 1
			expect(get_transactions(address)[0][:amount].to_s).to eq '0.00001'
			expect(get_transactions(address)[0][:confirmations]).to eq 0

			gen_blocks 1
			give_bitcoins '0.00002', address

			expect(get_transactions(address).length).to eq 2
			expect(get_transactions(address)[0][:amount].to_s).to eq '0.00001'
			expect(get_transactions(address)[0][:confirmations]).to eq 1

			expect(get_transactions(address)[1][:amount].to_s).to eq '0.00002'
			expect(get_transactions(address)[1][:confirmations]).to eq 0
		end
	end
end
