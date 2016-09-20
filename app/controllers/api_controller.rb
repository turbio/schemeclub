class ApiController < ApplicationController
	def valid_name
		if params[:name]
			render(json:
				!User.where('lower(name) = ?', params[:name].downcase).first.nil?)
		else
			render status: 400, nothing: true
		end
	end

	def valid_credentials
		if params[:name] && params[:password]
			render(json:
				!User.authenticate(params[:name], params[:password]).nil?)
		else
			render status: 400, nothing: true
		end
	end
end
