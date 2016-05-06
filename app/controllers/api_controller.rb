class ApiController < ApplicationController
	def valid_name
		render json: !User.where('lower(name) = ?', params[:name].downcase).first.nil?
	end

	def valid_credentials
		render json: !User.authenticate(params[:name], params[:password]).nil?
	end
end
