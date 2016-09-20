require 'rails_helper'

RSpec.describe ApiController, type: :controller do
	describe 'GET #valid_name' do
		it 'should return true for valid username' do
			User.create!(name: 'test', password: 'test')
			post :valid_name, name: 'test'

			expect(response).to be_success
			expect(response.content_type).to eq 'application/json'
			expect(response.body).to eq 'true'
		end
		it 'should return false for invalid username' do
			post :valid_name, name: 'not a user'

			expect(response).to be_success
			expect(response.content_type).to eq 'application/json'
			expect(response.body).to eq 'false'
		end
		it 'should return error for invalid request' do
			post :valid_name
			expect(response).not_to be_success

			post :valid_name, node_one_of: 'the params'
			expect(response).not_to be_success
		end
	end

	describe 'GET #valid_credentials' do
		it 'should return true for valid username and password' do
			User.create!(name: 'test', password: 'test')
			post :valid_credentials, name: 'test', password: 'test'

			expect(response).to be_success
			expect(response.content_type).to eq 'application/json'
			expect(response.body).to eq 'true'
		end
		it 'should return false for invalid username' do
			User.create!(name: 'test', password: 'test')
			post :valid_credentials, name: 'nottest', password: 'test'

			expect(response).to be_success
			expect(response.content_type).to eq 'application/json'
			expect(response.body).to eq 'false'
		end
		it 'should return false for invalid password' do
			User.create!(name: 'test', password: 'test')
			post :valid_credentials, name: 'test', password: 'nottest'

			expect(response).to be_success
			expect(response.content_type).to eq 'application/json'
			expect(response.body).to eq 'false'
		end
		it 'should return error for invalid request' do
			post :valid_credentials
			expect(response).not_to be_success

			post :valid_credentials, node_one_of: 'the params'
			expect(response).not_to be_success
		end
	end
end
