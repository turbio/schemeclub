class ApiController < ApplicationController
	def valid_name
		render plain: User.where('lower(name) = ?', params[:name].downcase).first.nil?.to_s
	end

	def valid_credentials
		render plain: User.authenticate(params[:name], params[:password]).nil?.to_s
	end
end
