require 'rails_helper'

def stop_bitcoind
	bitcoind_pid = `pidof bitcoind`

	if bitcoind_pid != ''
		`kill #{bitcoind_pid}`

		#give it a second to die
		sleep 1

		stop_bitcoind
	end
end

def start_bitcoind
	bitcoind_pid = `pidof bitcoind`

	bitcoind_config = Rails.configuration.payment['server']
	opts = [
		"-rpcport=#{bitcoind_config['port']}",
		"-rpcuser=#{bitcoind_config['user']}",
		"-rpcpassword=#{bitcoind_config['password']}",
		"-regtest"
	].join ' '

	if bitcoind_pid == ''
		pid = spawn("bitcoind #{opts}")

		#give it a second to initialize
		sleep 1
	end
end

RSpec.describe PaymentHelper, type: :helper do
	#just to make sure we're starting with a fresh bitcoind server
	stop_bitcoind

	describe 'without bitcoind running' do
		it 'should throw error on get_address' do
			stop_bitcoind

			expect do
				get_address 0
			end.to raise_error Errno::ECONNREFUSED
		end

		it 'should throw error on get_balance' do
			stop_bitcoind

			expect do
				get_balance 0
			end.to raise_error Errno::ECONNREFUSED
		end

		it 'should throw error on get_transactions' do
			stop_bitcoind

			expect do
				get_transactions 0
			end.to raise_error Errno::ECONNREFUSED
		end
	end

	describe 'with bitcoind running' do
		it 'should not throw error on get_address' do
			start_bitcoind

			expect do
				get_address 0
			end.not_to raise_error
		end

		it 'should not throw error on get_balance' do
			start_bitcoind

			expect do
				get_balance 0
			end.not_to raise_error
		end

		it 'should not throw error on get_transactions' do
			start_bitcoind

			expect do
				get_transactions 0
			end.not_to raise_error
		end
	end

	describe '#get_address' do
		it 'should return the address of any user' do
			start_bitcoind

			address = get_address (rand * 10000).floor

			expect(address).to be_a String
			expect(address.length).to be >= 24
			expect(address.length).to be <= 34
		end

		it 'should return not the same address for multiple users' do
			start_bitcoind

			startUser = (rand * 10000).floor

			addresses = 10.times.map do |i|
				get_address startUser + i
			end

			expect(addresses).to eq addresses.uniq
		end

		it 'should return the same address for the same user' do
			start_bitcoind

			user = (rand * 10000).floor

			addresses = 10.times.map do
				get_address user
			end

			expect(addresses.uniq.length).to eq 1
		end
	end
end
