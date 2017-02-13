class DashController < ApplicationController
	def index
		return render 'index' if session[:user].nil?
		@user = User.find session[:user]['id']
		@codes = RecruitCode.owned_by @user

		@allowed_to_create_codes = @codes.length < 3
	end

	def new_code
		@user = User.find session[:user]['id']

		if !@user.fee_payed
			return render 'error', locals: { error: I18n.t('no_fee') }
		end

		if RecruitCode.owned_by(@user).length >= 3
			render plain: I18n.t('max_codes'), status: 400
			return
		end

		@code = RecruitCode.generate_new_code @user
		redirect_to root_path
	end
end
