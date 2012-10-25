JenkinsDashboard::Application.routes.draw do
  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  root :to => "dashboard#index"
  resources :users
  resources :sessions
  resources :dashboard
  resources :builds
  resources :jobs
  resources :culprits
end
