class MainController < ApplicationController
	def dash
		@user = User.find(session[:user_id])
		@code = RecruitCode.where(owner: @user.id).last
	end

	def logout
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
		@code = RecruitCode.find_by_code(params[:signup][:code])
		@user = User.new(name: params[:signup][:name], password: params[:signup][:password], parent_id: @code.owner_id)

		if @user.save
			@code.claimed = true
			@code.save
			session[:user_id] = @user.id
			redirect_to root_path
		else
			render 'join'
		end
	end

	def join
		if session[:user_id].present?
			@error = 'you are already part of the club'
			return
		end

		@code = RecruitCode.find_by_code(params[:id] || params[:signup][:code])
		@error =
			if @code.nil?
				@code.code + ' is not a valid code'
			elsif not @code.available?
				@code.code + ' is already taken'
			end

		return if @error
	end

	def new_code
		#TODO: this
		@code = RecruitCode.generate_new_code(User.find(session[:user_id]))
		redirect_to root_path
	end
end
