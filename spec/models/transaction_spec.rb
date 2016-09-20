require 'rails_helper'

RSpec.describe Transaction, type: :model do
	it 'should create transactions between users' do
		alice = User.create!(name: 'alice', password: 'password')
		bob = User.create!(name: 'bob', password: 'password')

		transaction = Transaction.create!(
			to: [alice],
			from_id: bob.id,
			amount: 20,
			reason: :user_joined)
	end

	it 'should stringify nicely' do
		alice = User.create!(name: 'alice', password: 'password')
		bob = User.create!(name: 'bob', password: 'password')
		chris = User.create!(name: 'chris', password: 'password')

		transaction = Transaction.create!(
			to: [alice, chris],
			from_id: bob.id,
			amount: 1234.56,
			reason: :user_joined)

		expect("#{transaction}").to eq('bob -> alice, chris 1234.56')
	end

	it 'should get users in transaction up to' do
		alice = User.create!(name: 'alice', password: 'password')
		bob = User.create!(name: 'bob', password: 'password', parent_id: alice.id)
		carly = User.create!(name: 'carly', password: 'password', parent_id: bob.id)
		dan = User.create!(name: 'dan', password: 'password', parent_id: carly.id)
		erin = User.create!(name: 'erin', password: 'password', parent_id: dan.id)

		transaction = Transaction.create!(
			to: [dan, carly, bob, alice],
			from_id: erin.id,
			amount: 1234.56,
			reason: :user_joined)

		expect(transaction.up_to alice).to include(dan, carly, bob, alice)
		expect(transaction.up_to alice).not_to include(erin)

		expect(transaction.up_to dan).to include(dan)
		expect(transaction.up_to dan).not_to include(carly, bob, alice)
	end

	it 'should get amount to individual users' do
		god = User.create!(name: 'god', password: 'password')
		alice = User.create!(name: 'alice', password: 'password', parent_id: god.id)
		bob = User.create!(name: 'bob', password: 'password', parent_id: alice.id)
		carly = User.create!(name: 'carly', password: 'password', parent_id: bob.id)
		dan = User.create!(name: 'dan', password: 'password', parent_id: carly.id)
		erin = User.create!(name: 'erin', password: 'password', parent_id: dan.id)

		transaction = Transaction.create!(
			to: [god, dan, carly, bob, alice],
			from_id: erin.id,
			amount: 64,
			reason: :user_joined)

		expect(transaction.amount).to eq(64)
		expect(transaction.amount dan).to eq(64 / 2)
		expect(transaction.amount carly).to eq(64 / 4)
		expect(transaction.amount bob).to eq(64 / 8)
		expect(transaction.amount alice).to eq(64 / 16)
		expect(transaction.amount god).to eq(64 / 32)
	end
end
