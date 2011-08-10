BluePassers::Application.routes.draw do
  match "/auth/failure" => "sessions#failure"
  match "/auth/:provider/callback" => "sessions#create"

  resources :airports
  resources :flights
  resources :users
  resource :account

  root :to => "home#index"
end
