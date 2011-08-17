BluePassers::Application.routes.draw do
  match "/auth/failure" => "sessions#failure"
  match "/auth/:provider/callback" => "sessions#create"

  resources :pages
  resources :airports
  resources :flights
  resources :users do
    resources :check_ins
  end

  resource :account
  resource :session

  root :to => "home#index"
end
