require 'rails_helper'

RSpec.describe DashController, type: :controller do
	describe 'GET #index' do
		it 'should get dash index when logged in' do
			user = User.create!(name: 'test', password: 'test')

			@request.session[:user_id] = user.id

			get :index
			expect(response.content_type).to eq "text/html"
			expect(response).to render_template("dash/index")
		end
	end
	describe 'POST #new_code' do
		it 'should recieve new code on post' do
			user = User.create!(name: 'test', password: 'test')
			expect(RecruitCode.owned_by(user).length).to eq 0

			@request.session[:user_id] = user.id

			post :new_code

			expect(response).to redirect_to root_path
			expect(RecruitCode.owned_by(user).length).to eq 1
		end
		it 'should not let users have more than 3 codes' do
			user = User.create!(name: 'test', password: 'test')
			expect(RecruitCode.owned_by(user).length).to eq 0

			@request.session[:user_id] = user.id

			post :new_code
			expect(response).to redirect_to root_path
			expect(RecruitCode.owned_by(user).length).to eq 1

			post :new_code
			expect(response).to redirect_to root_path
			expect(RecruitCode.owned_by(user).length).to eq 2

			post :new_code
			expect(response).to redirect_to root_path
			expect(RecruitCode.owned_by(user).length).to eq 3

			post :new_code
			expect(response.status).to eq 400
			expect(response.body).to eq 'maximum of 3 recruit codes'
			expect(RecruitCode.owned_by(user).length).to eq 3
		end
		it 'should not create code without valid user' do
			post :new_code
			expect(response).to redirect_to root_path
		end
	end
end
