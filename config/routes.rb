Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
  
      resources :products, only: [:index, :show, :create, :update, :destroy]
      get "joins" => "products#joins"
      get "list_like" => "products#list_like"
      get "products/:id/categories"=> "products#show"

      resources :categories, only: [:index, :show, :create, :update, :destroy]

      resources :users, only: [:index, :show, :create, :update, :destroy]
      post "login" => "users#login"
      post "logout" => "users#logout"
      post "forget_password" => "users#forget_password"
      post "reset_password" => "users#reset_password"
      
    end
  end
end
