require 'rails_helper'

RSpec.describe User, type: :model do
	it 'should create user with valid information' do
		first = User.create!(name: 'first', password: 'password')
		second = User.create!(
			name: 'second',
			password: 'password',
			parent_id: first.id)
	end

	it 'should reject signup with invalid information' do
		expect do
			User.create!(name: 't', password: 'password')
		end.to raise_error(
			ActiveRecord::RecordInvalid,
			/Name is too short \(minimum is 3 characters\)/)

		expect do
			User.create!(name: 'no spaces', password: 'password')
		end.to raise_error(
			ActiveRecord::RecordInvalid,
			/Validation failed: Name must be alphanumeric/)

		expect do
			User.create!(name: 'nameisok', password: '')
		end.to raise_error(
			ActiveRecord::RecordInvalid,
			/Validation failed: Password can't be blank/)
	end

	it 'should authenticate a user with valid credentials' do
		alice = User.create!(name: 'alice', password: 'password')

		expect(User.authenticate 'alice', 'password').to eq alice
	end

	it 'should reject a user with invalid credentials' do
		bob = User.create!(name: 'bob', password: 'letmein')

		expect(User.authenticate 'bob', 'password').not_to eq bob
	end

	it 'should stringify a User to their name' do
		charley = User.create!(name: 'charley', password: 'letmein')

		expect("#{charley}").to eq 'charley'
	end
end
