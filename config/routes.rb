class AuthConstraint
	def matches?(request)
		request.session[:user_id].present?
	end
end

Rails.application.routes.draw do
	namespace 'api' do
		post 'valid_name'
		post 'valid_credentials'
	end

	get '/payment' => 'payment#index'
	get '/payment/status' => 'payment#status'

	get '/qr' => 'qrcode#index', as: 'qrcode'

	constraints(AuthConstraint.new) do
		root to: 'dash#index', as: 'authenticated_root'
	end
	root 'main#index'

	post '/login' => 'main#login'
	post '/join' => 'main#signup'
	get '/logout' => 'main#logout'
	get '/welcome(/:id)' => 'welcome#index', as: 'welcome'
	post '/new_code' => 'dash#new_code'

	get '/join' => 'main#join'
	get '/:id' => 'main#join_with_code', id: /[0-9].+/
end
