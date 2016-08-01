class DashController < ApplicationController
	def index
		return render 'index' if session[:user_id].nil?
		@user = User.find(session[:user_id])
		@codes = RecruitCode.owned_by(@user)

		@allowed_to_create_codes = @codes.length < 3
	end

	def new_code
		@user = User.find(session[:user_id])
		redirect_to root_path if @user.nil?

		render plain: 'maximum of 3 recruit codes' and return if RecruitCode.owned_by(@user).length >= 3
		@code = RecruitCode.generate_new_code(@user)
		redirect_to root_path
	end
end
