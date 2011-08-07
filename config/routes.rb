BluePassers::Application.routes.draw do
  match "/auth/failure" => "sessions#failure"
  match "/auth/:provider/callback" => "sessions#create"

  root :to => "home#index"
end
