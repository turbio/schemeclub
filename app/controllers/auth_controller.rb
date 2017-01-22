class AuthController < ApplicationController
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
			render 'login'
		end
	end

	def join_with_code
		@code_string = params[:id] || params[:join][:code]
		@code = RecruitCode.find_by(code: @code_string)

		return render 'error', locals: { error: 'code not found'} if @code.nil?

		session[:recruit_code] = @code

		render 'join'
	end

	def signup_with_code
		@code = RecruitCode.find_by(code: params[:join][:code])

		return render 'join' if @code.claimed

		@user = User.new(
			name: params[:join][:name],
			password: params[:join][:password],
			parent_id: @code.owner_id
		)

		if !@user.save
			render 'join'
			return
		end

		@code.claimed = true
		@code.save
		session[:user_id] = @user.id

		redirect_to welcome_path
	end

	def signup
		@user = User.new(
			name: params[:join][:name],
			password: params[:join][:password],
			parent_id: 1
		)

		render 'join' and return if !@user.save

		session[:user_id] = @user.id
		redirect_to welcome_path
	end

	def valid_name
		render status: 400, nothing: true unless params[:name]

		user = User.where('lower(name) = ?', params[:name].downcase).first
		render json: !user.nil?
	end

	def valid_credentials
		render status: 400, nothing: true unless params[:name] && params[:password]

		user = User.authenticate(params[:name], params[:password])
		render json: !user.nil?
	end
end
