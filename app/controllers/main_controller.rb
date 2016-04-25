class MainController < ApplicationController
	def dash
		@user = User.find(session[:user_id])
		@superior = User.find(@user.superior_id)
		@sub = User.where(superior_id: @user.id)

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
		@code = params[:signup][:code]
		@user = User.new(params.require(:signup).permit(:name, :password))

		if @user.save
			redirect_to root_path
		else
			render 'recruit'
		end
	end

	def join
		@code = params[:id] || params[:signup][:code]
		@code_errors = @code << ' ' <<
			if !RecruitCode.code_exists? @code
				'is not a valid code'
			elsif !RecruitCode.code_available? @code
				'is already taken'
			end
	end

	def new_code
		#TODO: this
		@code = RecruitCode.generate_new_code(User.find(session[:user_id]))
		redirect_to root_path
	end
end
