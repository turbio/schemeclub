class DashController < ApplicationController
	def index
		return render 'index' if session[:user_id].nil?
		@user = User.find(session[:user_id])
		@codes = RecruitCode.where(owner: @user.id).select do |code|
			code.available?
		end
	end
end
