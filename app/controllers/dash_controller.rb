class DashController < ApplicationController
	def index
		return render 'index' if session[:user_id].nil?
		@user = User.find(session[:user_id])
		@codes = RecruitCode.owned_by(@user)
	end
end
