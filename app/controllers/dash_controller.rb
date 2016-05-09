class DashController < ApplicationController
	def index
		return render 'index' if session[:user_id].nil?
		@user = User.find(session[:user_id])
		@codes = RecruitCode.owned_by(@user)

		@allowed_to_create_codes = @codes.length < 3
	end
end
