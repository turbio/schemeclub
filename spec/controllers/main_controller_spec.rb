require 'rails_helper'

RSpec.describe MainController, type: :controller do
	describe 'GET #index' do
		it 'should get index' do
			get 'index'
			expect(response.content_type).to eq "text/html"
			expect(response).to render_template("main/index")
		end
	end
end
