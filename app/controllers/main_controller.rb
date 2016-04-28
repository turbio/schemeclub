class MainController < ApplicationController
	def dash
		@user = User.find(session[:user_id])
		@code = RecruitCode.where(owner: @user.id).last || RecruitCode.new
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
		@code = RecruitCode.find_by(code: params[:signup][:code]) || RecruitCode.new()
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

		@initial_transaction = Transaction.create(
			to: @user.parent.id,
			from: @user.id,
			amount: 10,
			reason: 'user_joined')

		redirect_to root_path
	end

	def join
		if session[:user_id].present?
			@error = 'woops, you are already a member'
			return
		end

		@code_string = params[:id] || params[:signup][:code]
		@code = RecruitCode.find_by(code: @code_string) || RecruitCode.new()
		@error =
			if @code.nil?
				@code_string + ' is not a valid code'
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
