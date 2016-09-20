require 'rails_helper'

RSpec.describe User, type: :model do
	it 'authenticate a user with valid credentials' do
		alice = User.create!(name: 'alice', password: 'password')

		expect(User.authenticate 'alice', 'password').to eq(alice)
	end

	it 'rejects a user with invalid credentials' do
		bob = User.create!(name: 'bob', password: 'letmein')

		expect(User.authenticate 'bob', 'password').not_to eq(bob)
	end

	it 'should stringify a User to their name' do
		charley = User.create!(name: 'charley', password: 'letmein')

		expect("#{charley}").to eq('charley')
	end

	it 'should show transactions to a user' do
		dan = User.create!(name: 'dan', password: 'insecurepassword')
		ellen = User.create!(
			name: 'ellen',
			password: 'correcthorse',
			parent_id: dan.id)

		expect(dan.transactions.length).to eq(1)
		expect(ellen.transactions.length).to eq(0)

		expect(dan.transactions.first.from_id).to eq(ellen.id)

		erin = User.create!(
			name: 'erin',
			password: 'whoami',
			parent_id: dan.id)

		expect(dan.transactions.length).to eq(2)
		expect(ellen.transactions.length).to eq(0)
		expect(erin.transactions.length).to eq(0)
	end

	it 'should show amount earned from user' do
		dog = User.create!(name: 'dog', password: 'password123')

		fred = User.create!(
			name: 'fred',
			password: 'password123',
			parent_id: dog.id)
		gary = User.create!(
			name: 'gary',
			password: 'incorrecthorse',
			parent_id: fred.id)

		expect(fred.earned_from gary).to eq(5)

		harry = User.create!(
			name: 'harry',
			password: 'imawizard',
			parent_id: gary.id)

		expect(fred.earned_from gary).to eq(7.5)
		expect(fred.earned_from harry).to eq(2.5)
	end

	it 'should show total amount earned' do
		dog = User.create!(name: 'dog', password: 'password123')

		fred = User.create!(
			name: 'fred',
			password: 'password123',
			parent_id: dog.id)

		expect(fred.earned).to eq(0)

		gary = User.create!(
			name: 'gary',
			password: 'incorrecthorse',
			parent_id: fred.id)

		expect(fred.earned).to eq(5)
		expect(gary.earned).to eq(0)

		harry = User.create!(
			name: 'harry',
			password: 'imawizard',
			parent_id: gary.id)

		expect(fred.earned).to eq(7.5)
		expect(gary.earned).to eq(5)
	end
end
