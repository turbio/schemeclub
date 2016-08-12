class MainController < ApplicationController
	def logout
		#this is used to "TRY" and prevent users from creating many alt accounts as subordinates
		#once is logged in, it should no longer be possible to create a new account
		#this is incredibly easy to circumvent, but might make it just a little bit harder
		session[:last_user_id] = session[:user_id]

		session.delete(:user_id)
		redirect_to root_path
	end

	def login
		@user = User.authenticate(params[:login][:name], params[:login][:password])
		if @user
			session[:user_id] = @user.id

			redirect_to root_path
		else
			@user = { :errors => ['incorrect name or password'] }
			render 'index'
		end
	end

	def signup
		redirect_to join_path and return if session[:last_user_id].present?

		@code = RecruitCode.find_by(code: params[:signup][:code]) || RecruitCode.new()
		return render 'join' if !@code.available?

		@user = User.new(
			name: params[:signup][:name],
			password: params[:signup][:password],
			parent_id: @code.owner_id)

		if !@user.save
			render 'join'
			return
		end

		@code.claimed = true
		@code.save
		session[:user_id] = @user.id

		redirect_to welcome_path
	end

	def join
		@error = 'woops, you are already a member' and return if session[:user_id].present?
		@error = 'nice try, but you already have an account' and return if session[:last_user_id].present?

		@code_string = params[:id] || params[:signup][:code]
		@code = RecruitCode.find_by(code: @code_string) || RecruitCode.new()
	end

	def welcome
		return render 'index' if session[:user_id].nil?
		@user = User.find(session[:user_id])
		@slides = 3
		@slide = params[:id] ? params[:id].to_i : nil
	end
end
