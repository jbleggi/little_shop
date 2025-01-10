Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show, :create, :update, :destroy]
      resources :items, only: [:index, :show, :create, :update, :destroy]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  # index
  get "/api/v1/merchants", to: "api/v1/merchants#index"
  # get "/api/v1/merchants?sorted=age", to: "api/v1/merchants#index"

  get "/api/v1/merchant", to: "api/v1/merchant#index"
  get "/api/v1/merchant/:id", to: "api/v1/merchant#show"
  post "/api/v1/merchant", to: "api/v1/merchant#create"
  patch "/api/v1/merchant/:id", to: "api/v1/merchant#update"
  delete "api/v1/merchant/:id", to: "api/v1/merchant#destroy"

  get "/api/v1/item", to: "api/v1/item#index"
  get "/api/v1/item/:id", to: "api/v1/item#show"
  post "/api/v1/item", to: "api/v1/item#create"
  patch "/api/v1/item/:id", to: "api/v1/item#update"
  delete "api/v1/item/:id", to: "api/v1/item#destroy"
  
end
