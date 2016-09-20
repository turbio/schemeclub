class AuthConstraint
	def matches?(request)
		request.session[:user_id].present?
	end
end

Rails.application.routes.draw do
	post 'api/valid_name'
	post 'api/valid_credentials'

	constraints(AuthConstraint.new) do
		root to: 'dash#index', to: 'authenticated_root'
	end
	root 'main#index'

	post '/login' => 'main#login'
	post '/signup' => 'main#signup'
	get '/logout' => 'main#logout'
	get '/welcome(/:id)' => 'main#welcome', as: 'welcome'
	post '/new_code' => 'dash#new_code'

	get '/:id' => 'main#join'
end
