require 'rails_helper'

RSpec.describe MainController, type: :controller do
	describe 'GET #index' do
		it 'should get index' do
			get :index
			expect(response.content_type).to eq 'text/html'
			expect(response).to render_template 'main/index'
		end
	end
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
			expect(response).to render_template 'main/index'
		end
	end
	describe 'GET #join' do
		render_views

		it 'should show join page with valid code' do
			user = User.create!(name: 'test', password: 'test')
			code = RecruitCode.generate_new_code user
			get :join, id: code.code

			expect(response.status).to eq 200
			expect(response.body).not_to match /no recruit code/
			expect(response.body).to match /Join the club/
		end
		it 'should show join page with error message if invalid code' do
			get :join, id: 'test'
			expect(response.status).to eq 200
			expect(response.body).to match /no recruit code/
		end
	end
	describe 'POST #signup' do
		render_views

		it 'should create users' do
			parent = User.create!(name: 'parent', password: 'test')
			code = RecruitCode.generate_new_code parent

			post :signup, signup: {
				code: code.code,
				name: 'child',
				password: 'test'
			}

			user = User.find_by(name: 'child')
			expect(user).not_to eq nil
			expect(user.name).to eq 'child'
			expect(user.parent.name).to eq 'parent'

			expect(response).to redirect_to '/welcome'
		end
		it 'should reject signup and show error with invalid data' do
			parent = User.create!(name: 'parent', password: 'test')
			code = RecruitCode.generate_new_code parent

			post :signup, signup: {
				code: code.code,
				name: 'ch',
				password: 'test'
			}

			expect(response.body).to match /Name is too short/

			post :signup, signup: {
				code: code.code,
				name: 'invalid name?',
				password: 'test'
			}

			expect(response.body).to match /Name must be alphanumeric/
		end
	end
end
