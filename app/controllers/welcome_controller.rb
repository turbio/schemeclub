class WelcomeController < ApplicationController
	def index
		@user = User.find(session[:user]['id'])
		@slides = 5
		@slide = params[:id].to_i

		if !(0...@slides).include? @slide
			@slide = 0
		end
	end
end
