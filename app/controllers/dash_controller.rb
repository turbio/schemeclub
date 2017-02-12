class DashController < ApplicationController
	def index
		return render 'index' if session[:user].nil?
		@user = User.find session[:user]['id']
		@codes = RecruitCode.owned_by @user

		@allowed_to_create_codes = @codes.length < 3

		@fee_payed = false
	end

	def new_code
		@user = User.find session[:user]['id']

		if RecruitCode.owned_by(@user).length >= 3
			render plain: 'maximum of 3 recruit codes', status: 400
			return
		end

		@code = RecruitCode.generate_new_code @user
		redirect_to root_path
	end
end
