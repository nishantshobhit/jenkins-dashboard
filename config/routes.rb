JenkinsDashboard::Application.routes.draw do
 	get "test_reports/show"

	get "log_in" => "sessions#new", :as => "log_in"
	get "log_out" => "sessions#destroy", :as => "log_out"

	root :to => "dashboard#index"

	resources :users
	resources :sessions
	resources :dashboard
	resources :jobs
	resources :culprits

	match 'jobs/:id/builds/health' => 'builds#health'

	resources :jobs do
		resources :builds do
			resources :test_report, :controller => "test_reports"
		end
	end

end
