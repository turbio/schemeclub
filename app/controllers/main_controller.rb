class MainController < ApplicationController
	def index
		return redirect_to dash_path unless session[:user].nil?
		render template: 'auth/login'
	end
end
