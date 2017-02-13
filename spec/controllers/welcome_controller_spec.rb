require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
	render_views

	describe 'GET #index' do
		def show_slide(nth)
			"<div class=\"slide show\" id=\"slide_#{nth}\">"
		end

		it 'should return http success' do
			get :index
			expect(response).to have_http_status :success
			expect(assigns :slide).to eq 0
			expect(response.body).to include show_slide 0
		end

		it 'should return different pages by index' do
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

		it 'should include user name if logged in' do
			user = User.create!(name: 'welcomeslidetest', password: 'test')
			@request.session[:user] = user

			get :index
			expect(response.body).to match /welcomeslidetest/
		end
	end
end
