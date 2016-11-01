class AuthConstraint
	def matches?(request)
		request.session[:user_id].present?
	end
end

Rails.application.routes.draw do
	get 'welcome/index'

	namespace 'api' do
		post 'valid_name'
		post 'valid_credentials'
	end

	get '/payment' => 'payment#index', as: 'payment'
	get '/qr' => 'qrcode#index', as: 'qrcode'

	constraints(AuthConstraint.new) do
		root to: 'dash#index', as: 'authenticated_root'
	end
	root 'main#index'

	post '/login' => 'main#login'
	post '/signup' => 'main#signup'
	get '/logout' => 'main#logout'
	get '/welcome(/:id)' => 'welcome#index', as: 'welcome'
	post '/new_code' => 'dash#new_code'

	get '/:id' => 'main#join'
end
