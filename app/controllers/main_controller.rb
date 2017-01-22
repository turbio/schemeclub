class MainController < ApplicationController
	def index
		render template: 'auth/login'
	end
end
