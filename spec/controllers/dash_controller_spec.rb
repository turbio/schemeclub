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
		render_views

		it 'should recieve new code on post' do
			user = User.create!(name: 'test', password: 'test')
			Payment.create!(
				user_id: user.id,
				amount: 1,
				confirmed: true,
				direction: :in,
				address: 'test'
			)
			expect(RecruitCode.owned_by(user).length).to eq 0

			@request.session[:user] = user

			post :new_code

			expect(response).to redirect_to root_path
			expect(RecruitCode.owned_by(user).length).to eq 1
		end
		it 'should not let users have more than 3 codes' do
			user = User.create!(name: 'test', password: 'test')
			Payment.create!(
				user_id: user.id,
				amount: 1,
				confirmed: true,
				direction: :in,
				address: 'test'
			)
			expect(RecruitCode.owned_by(user).length).to eq 0

			@request.session[:user] = user

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
			expect(response).to render_template("application/error")
			expect(response.body).to match /Maximum of 3 recruit codes allowed/
			expect(RecruitCode.owned_by(user).length).to eq 3
		end
		it 'should not create codes for users who have not payed fee' do
			user = User.create!(name: 'feenotpayed', password: 'test')
			expect(RecruitCode.owned_by(user).length).to eq 0

			@request.session[:user] = user

			post :new_code
			expect(response.status).to eq 400
			expect(response).to render_template("application/error")
			expect(response.body).to match /pay the registration fee before you can/
			expect(RecruitCode.owned_by(user).length).to eq 0
		end
	end
end
