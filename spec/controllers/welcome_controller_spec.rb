require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
	render_views

	describe 'GET #index' do
		def show_slide(nth)
			"<div class=\"slide show\" id=\"slide_#{nth}\">"
		end

		it 'should redirect if not logged in' do
			get :index
			expect(response).to have_http_status 302
		end

		it 'should return http success' do
			user = User.create!(name: 'welcomeslidetest', password: 'test')
			@request.session[:user_id] = user.id

			get :index
			expect(response).to have_http_status :success
			expect(assigns :slide).to eq 0
			expect(response.body).to include show_slide 0
		end

		it 'should return different pages by index' do
			user = User.create!(name: 'welcomeslidetest', password: 'test')
			@request.session[:user_id] = user.id

			get :index, :id => 0
			expect(response).to have_http_status :success
			expect(assigns :slide).to eq 0
			expect(response.body).to include show_slide 0

			get :index, :id => 1
			expect(response).to have_http_status :success
			expect(assigns :slide).to eq 1
			expect(response.body).to include show_slide 1

			get :index, :id => 2
			expect(response).to have_http_status :success
			expect(assigns :slide).to eq 2
			expect(response.body).to include show_slide 2
		end

		it 'should return first slide if invalid id' do
			user = User.create!(name: 'welcomeslidetest', password: 'test')
			@request.session[:user_id] = user.id

			get :index, :id => -5
			expect(response).to have_http_status :success
			expect(response.body).to include show_slide 0

			get :index, :id => 100
			expect(response).to have_http_status :success
			expect(response.body).to include show_slide 0

			get :index, :id => 'notanumber'
			expect(response).to have_http_status :success
			expect(response.body).to include show_slide 0
		end
	end
end
