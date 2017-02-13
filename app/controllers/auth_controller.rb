class AuthController < ApplicationController
	def logout
		session.delete :user
		redirect_to root_path
	end

	def login
		@user = User.authenticate(
			params[:login][:name],
			params[:login][:password]
		)

		if @user
			session[:user] = @user
			session.delete :recruit_code
			redirect_to root_path
		else
			@user = { :errors => ['incorrect name or password'] }
			render 'login'
		end
	end

	def join_with_code
		@code =
			if params.include? :id
				session[:recruit_code] = RecruitCode
					.includes(:owner)
					.find_by(code: params[:id])
					&.serializable_hash(include: :owner)
			else
				session[:recruit_code]
			end

		return render 'error', locals: { error: 'code not found'} if @code.nil?

		render 'join'
	end

	def signup_with_code
		code = RecruitCode.find_by(code: session[:recruit_code]['code'])

		@user = User.new(
			name: params[:join][:name],
			password: params[:join][:password],
			parent_id: code.owner_id,
			recruit_code: code
		)

		if !@user.save
			@code = session[:recruit_code]
			render 'join'
			return
		end

		code.save
		session[:user] = @user
		session.delete :recruit_code

		redirect_to welcome_path
	end

	def signup
		@user = User.new(
			name: params[:join][:name],
			password: params[:join][:password],
			parent_id: 1
		)

		render 'join' and return if !@user.save

		session[:user] = @user
		session.delete :recruit_code

		redirect_to welcome_path
	end

	def valid_name
		return render status: 400, nothing: true unless params[:name]

		user = User.where('lower(name) = ?', params[:name].downcase).first
		render json: !user.nil?
	end

	def valid_credentials
		name, password = params.values_at :name, :password
		return render status: 400, nothing: true unless name && password

		user = User.authenticate(params[:name], params[:password])
		render json: !user.nil?
	end
end
