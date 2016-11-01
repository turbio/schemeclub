class WelcomeController < ApplicationController
	def index
		return redirect_to controller: 'main' if session[:user_id].nil?

		@user = User.find(session[:user_id])
		@slides = 5
		@slide = params[:id].to_i

		if !(0...@slides).include? @slide
			@slide = 0
		end
	end
end
