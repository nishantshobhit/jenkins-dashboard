JenkinsDashboard::Application.routes.draw do

	get "log_in" => "sessions#new", :as => "log_in"
	get "log_out" => "sessions#destroy", :as => "log_out"

	root :to => "dashboards#index"

	namespace :api do
		resources :test_report
		resources :health
		resources :duration
		resources :developers
		resources :commits
		resources :jobs do
			resources :builds
		end
	end

	resources :users
	resources :sessions
	resources :dashboards

end
