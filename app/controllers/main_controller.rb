class MainController < ApplicationController
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
		if !params[:join].include? :code
		end

		@code = RecruitCode.find_by(code: params[:join][:code]) || RecruitCode.new()
		return render 'join' if !@code.available?

		@user = User.new(
			name: params[:join][:name],
			password: params[:join][:password],
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

	def join_with_code
		@code_string = params[:id] || params[:join][:code]
		@code = RecruitCode.find_by(code: @code_string)

		return render 'error', locals: { error: 'code not found'} if @code.nil?

		render 'join'
	end
end
