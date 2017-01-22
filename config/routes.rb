class AuthConstraint
	def matches?(request)
		request.session[:user_id].present?
	end
end

Rails.application.routes.draw do
	scope 'api' do
		post 'valid_name' => 'auth#valid_name'
		post 'valid_credentials' => 'auth#valid_credentials'
	end

	constraints(AuthConstraint.new) do
		root to: 'dash#index', as: 'dashboard'
		get '/payment' => 'payment#index'
		get '/qr' => 'qrcode#index', as: 'qrcode'
		post '/new_code' => 'dash#new_code'
	end

	root 'main#index'

	post '/login' => 'auth#login'
	post '/join' => 'auth#signup'
	get '/logout' => 'auth#logout'
	get '/welcome(/:id)' => 'welcome#index', as: 'welcome'

	get '/join' => 'auth#join'
	get '/:id' => 'auth#join_with_code', id: /[0-9].+/
end
