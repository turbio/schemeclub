require 'rails_helper'

RSpec.describe QrcodeController, type: :controller do
	render_views

	describe 'GET #index' do
		it 'should return 400 if no data param is set' do
			get :index
			expect(response).to have_http_status 400

			get :index, { width: 100, height: 100 }
			expect(response).to have_http_status 400
		end

		it 'should return 200 with valid data' do
			get :index, { data: 'this is a test string' }
			expect(response).to have_http_status 200

			get :index, { width: 100, height: 100, data: 'test with dimensions' }
			expect(response).to have_http_status 200
		end

		it 'should return an svg' do
			get :index, { data: 'data' }
			expect(response).to have_http_status 200
			expect(response.body).to include '<svg'

			get :index, { width: 1111111, height: 22222222, data: 'data' }
			expect(response).to have_http_status 200
			expect(response.body).to include 'width="1111111"'
			expect(response.body).to include 'height="22222222"'
		end
	end
end
