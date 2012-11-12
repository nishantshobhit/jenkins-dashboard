JenkinsDashboard::Application.routes.draw do

	get "log_in" => "sessions#new", :as => "log_in"
	get "log_out" => "sessions#destroy", :as => "log_out"

	root :to => "dashboard#index"

	namespace :api do
		resources :test_report
		resources :health
		resources :duration
		resources :developers
		resources :jobs do
			resources :builds
		end
	end

	resources :users
	resources :sessions
	resources :dashboard

end
