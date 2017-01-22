class DashController < ApplicationController
	def index
		return render 'index' if session[:user_id].nil?
		@user = User.find(session[:user_id])
		@codes = RecruitCode.owned_by(@user)

		@allowed_to_create_codes = @codes.length < 3
	end

	def new_code
		@user = User.find(session[:user_id])

		if RecruitCode.owned_by(@user).length >= 3
			render plain: 'maximum of 3 recruit codes', status: 400
			return
		end

		@code = RecruitCode.generate_new_code(@user)
		redirect_to root_path
	end
end
