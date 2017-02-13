class AuthConstraint
	def matches?(request)
		request.session[:user].present?
	end
end

class HasRecruitCode
	def matches?(request)
		request.session[:recruit_code].present?
	end
end

Rails.application.routes.draw do
	scope 'api' do
		post 'valid_name' => 'auth#valid_name'
		post 'valid_credentials' => 'auth#valid_credentials'
	end

	constraints(AuthConstraint.new) do
		root to: 'dash#index', as: 'dash'
		get '/payment' => 'payment#index'
		get '/qr' => 'qrcode#index', as: 'qrcode'
		post '/new_code' => 'dash#new_code'
	end

	constraints(HasRecruitCode.new) do
		root to: 'auth#join_with_code', as: 'recruit_root'
		get '/join' => 'auth#join_with_code'
		post '/join' => 'auth#signup_with_code'
	end

	root 'main#index'
	get '/signin' => 'main#index', as: 'signin'

	post '/login' => 'auth#login'
	get '/logout' => 'auth#logout'
	get '/welcome(/:id)' => 'welcome#index', as: 'welcome'

	get '/join' => 'auth#join'
	post '/join' => 'auth#signup'

	get '/:id' => 'auth#join_with_code', id: /[0-9]\w{3}/
end
