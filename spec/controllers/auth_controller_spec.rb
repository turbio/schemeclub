require 'rails_helper'

RSpec.describe AuthController, type: :controller do
	describe 'POST #login' do
		it 'should log user in with correct credentials' do
			User.create!(name: 'test', password: 'test')
			post :login, login: { name: 'test', password: 'test' }

			expect(response).to redirect_to '/'
		end

		it 'should not log user in with incorrect credentials' do
			post :login, login: { name: 'notauser', password: 'password' }

			expect(response).not_to redirect_to '/'
			expect(response.status).to eq 200
			expect(response).to render_template 'auth/login'
		end
	end

	describe 'GET #join' do
		render_views

		it 'should show join with no code' do
			get :join

			expect(response.status).to eq 200
			expect(response.body).to match /Join the club/
			expect(response.body).to match /signing up without a recruit code/
		end
	end

	describe 'GET #join_with_code' do
		render_views

		it 'should show join with code in session' do
			user = User.create!(name: 'test', password: 'test')
			code = RecruitCode.generate_new_code user

			@request.session[:recruit_code] = code.serializable_hash(include: :owner)

			get :join_with_code
			expect(response.status).to eq 200
			expect(response.body).not_to match /signing up without a recruit code/
		end

		it 'should show join page with valid code' do
			user = User.create!(name: 'test', password: 'test')
			code = RecruitCode.generate_new_code user
			get :join_with_code, id: code.code

			expect(response.status).to eq 200
			expect(response.body).not_to match /no recruit code/
			expect(response.body).to match /Join the club/
		end

		it 'should show join page with error message if no code' do
			get :join_with_code, id: '0est'
			expect(response.status).to eq 200
			expect(response.body).to match /code not found/
		end
	end

	describe 'POST #signup' do
		render_views

		it 'should create user with no code' do
			user = User.create!(name: 'root', password: 'root', id: 1)

			post :signup, join: {
				name: 'child',
				password: 'test'
			}

			user = User.find_by(name: 'child')
			expect(user).not_to eq nil
			expect(user.name).to eq 'child'
			expect(user.parent.name).to eq 'root'

			expect(response).to redirect_to '/welcome'
		end

		it 'should reject signup and show error with invalid data' do
			parent = User.create!(name: 'parent', password: 'test', id: 1)
			code = RecruitCode.generate_new_code parent

			post :signup, join: {
				code: code.code,
				name: 'ch',
				password: 'test'
			}

			expect(response.body).to match /Name is too short/

			post :signup, join: {
				code: code.code,
				name: 'invalid name?',
				password: 'test'
			}

			expect(response.body).to match /Name must be alphanumeric/
		end
	end

	describe 'POST #signup_with_code' do 
		it 'should create user with code' do
			user = User.create!(name: 'parent', password: 'test')
			code = RecruitCode.generate_new_code user

			@request.session[:recruit_code] = code.serializable_hash(include: :owner)

			post :signup_with_code, join: {
				name: 'child',
				password: 'test'
			}

			user = User.find_by(name: 'child')
			expect(user).not_to eq nil
			expect(user.name).to eq 'child'
			expect(user.parent.name).to eq 'parent'

			expect(response).to redirect_to '/welcome'
		end
	end

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

			post :valid_name, note_one_of: 'the params'
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
