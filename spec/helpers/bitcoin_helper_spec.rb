require 'rails_helper'

BitcoinConf = Rails.configuration.payment

def give_bitcoins(amount, address, confirm=false)
	http = Net::HTTP.start(BitcoinConf['host'], BitcoinConf['port'])

	req = Net::HTTP::Post.new("/debug/give/#{amount}/#{address}")
	req.basic_auth BitcoinConf['user'], BitcoinConf['password']

	http.request(req)

	if confirm
		gen_blocks 3
	end
end

def gen_blocks(number)
	http = Net::HTTP.start(BitcoinConf['host'], BitcoinConf['port'])

	req = Net::HTTP::Post.new("/debug/gen/#{number}")
	req.basic_auth BitcoinConf['user'], BitcoinConf['password']

	http.request(req)
end

def sync
	http = Net::HTTP.start(BitcoinConf['host'], BitcoinConf['port'])

	req = Net::HTTP::Post.new('/sync')
	req.basic_auth BitcoinConf['user'], BitcoinConf['password']

	http.request(req)
end

RSpec.describe BitcoinHelper, type: :helper do
	describe 'with bitcoin adapter running' do
		it 'should not throw error on new_address' do
			expect do
				new_address
			end.not_to raise_error
		end

		it 'should not throw error on address_info' do
			expect do
				address_info 'none'
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

	describe '#address_info' do
		before do gen_blocks 101 end # ensure we have enough (fake) bitcoins

		it 'should return a hash' do
			address = new_address

			expect(address_info address).to be_a Hash
		end

		it 'should start address with no balance' do
			address = new_address

			expect(address_info(address)[:balance].to_s).to eq '0.0'
		end

		it 'should have balance when given bitcoins' do
			address = new_address

			expect(address_info(address)[:balance].to_s).to eq '0.0'

			give_bitcoins '1.2345678', address, true
			sync

			expect(address_info(address)[:balance].to_s).to eq '1.2345678'
		end

		it 'should keep bitcoin amount accurately' do
			address = new_address

			expect(address).to be_a String
			expect(address.length).to be >= 24
			expect(address.length).to be <= 34

			expect(address_info(address)[:balance].to_s).to eq '0.0'

			12.times do
				give_bitcoins('0.00001', address)
			end

			gen_blocks 101

			sync

			expect(address_info(address)[:transactions].length).to eq 12
			expect(address_info(address)[:balance].to_s).to eq '0.00012'
		end

		it 'should require three confirmations' do
			address = new_address

			expect(address_info(address)[:balance].to_s).to eq '0.0'

			give_bitcoins '0.00001', address
			sync
			expect(address_info(address)[:balance].to_s).to eq '0.0'

			gen_blocks 1
			sync
			expect(address_info(address)[:balance].to_s).to eq '0.0'

			gen_blocks 1
			sync
			expect(address_info(address)[:balance].to_s).to eq '0.0'

			gen_blocks 1
			sync
			expect(address_info(address)[:balance].to_s).to eq '0.00001'
		end

		it 'should return an array for transactions' do
			expect(address_info(new_address)[:transactions]).to be_a Array
		end

		it 'user should start with no transactions' do
			address = new_address

			expect(address_info(new_address)[:transactions].length).to eq 0
		end

		it 'should show new transactions' do
			address = new_address

			expect(address_info(address)[:transactions].length).to eq 0

			give_bitcoins '0.00001', address
			sync

			expect(address_info(address)[:transactions].length).to eq 1
			expect(address_info(address)[:transactions][0][:amount].to_s).to eq '0.00001'
			expect(address_info(address)[:transactions][0][:confirmations]).to eq 0

			gen_blocks 1
			give_bitcoins '0.00002', address
			sync

			expect(address_info(address)[:transactions].length).to eq 2
			expect(address_info(address)[:transactions][0][:amount].to_s).to eq '0.00001'
			expect(address_info(address)[:transactions][0][:confirmations]).to eq 1

			expect(address_info(address)[:transactions][1][:amount].to_s).to eq '0.00002'
			expect(address_info(address)[:transactions][1][:confirmations]).to eq 0
		end
	end
end
