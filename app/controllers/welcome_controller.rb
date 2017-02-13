class WelcomeController < ApplicationController
	def index
		if (@logged_in = !session[:user].nil?)
			@user = User.find(session[:user]['id'])
		else
			@user = 'you'
		end

		@slides = 6
		@slide = params[:id].to_i

		if !(0...@slides).include? @slide
			@slide = 0
		end
	end

	def about
		@user = 'You'
	end
end
