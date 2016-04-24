class AuthConstraint
	def matches?(request)
		request.session[:user_id].present?
	end
end

Rails.application.routes.draw do
	constraints(AuthConstraint.new) do
		root :to => 'main#dash', :as => "authenticated_root"
	end
	root 'main#index'

	post '/login' => 'main#login'
	post '/signup' => 'main#signup'
	get '/logout' => 'main#logout'
	post '/new_code' => 'main#new_code'

	get '/:id' => 'main#join'
end
