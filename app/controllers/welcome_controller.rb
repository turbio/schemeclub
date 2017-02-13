class WelcomeController < ApplicationController
	def index
		if (@logged_in = !session[:user].nil?)
			@user = User.find(session[:user]['id'])
		else
			@user = 'you'
		end

		@slides = 5
		@slide = params[:id].to_i

		if !(0...@slides).include? @slide
			@slide = 0
		end
	end
end
